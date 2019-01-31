# 05a_DocumentTermMatrix.R
# Author: Tony Ward
# Date: 21 June 2016

# Purpose: Filter data priot to Topic Modelling - e.g. keep only AD claims

# Contents:
#   1. Define Macro Variables
#   2. Create Document Term Matrix
#   3. (Optional) Remove most frequent terms using TF-IDF  
#   4. (Optional) Remove sparse terms
#   5. Remove Custom Stopwords
#   6. Adjust Document Term Matrix to Remove Documents with no contents
#   7. Create corpus required for supervised LDA
#   8. Partitioning into Train/Test


# Notes
# Steve Perkins - change lines 119 - 129 to make more efficient - don't need to 
# recreate dtm


# TODO - IF THERE ARE NO DOCUS REMOVED THEN THE SAVE DOESN'T WORK
#---------------------------------------------------------------------
#   _. Load data required

dt_all <- readRDS(dt, file = "/home/rstudio/RData/02a_dt_all.RData")

#---------------------------------------------------------------------
#  1. Define Macro Variables


field_name <- "Skills"

# Partitioning
train_folds <- 1:8
val_folds   <- 9:10

#---------------------------------------------------------------------
#  2. Create Document Term Matrix

setnames(dt_all,field_name,"text")




dt_all[, text := gsub("[[:punct:]]|–"," ", text)]

# CREATE CORPUS
txtCorpus = Corpus(DataframeSource(dt_all[,c("doc_id", "text"), with = FALSE])) 
txtCorpus = tm_map(txtCorpus, content_transformer(tolower)) #  CONVERT TO LOWER CASE

# txtCorpus <- tm_map(txtCorpus,
#                     content_transformer(gsub),
#                     pattern = "sat nav|tomtom| tom tom", replacement = "satnav")



# txtCorpus <- tm_map(txtCorpus,
#                     content_transformer(gsub),
#                     pattern = ":punct:", replacement = " ")

txtCorpus <- tm_map(txtCorpus, stripWhitespace) # 

# We have two choices of where we could stem, either using tmp_map(txtCorpus, stemDocument)
# or as an argument to Document term matrix. We prefer the former because we later will be using
# txtCorpus to create structure needed for lda::lda.collapsed.gibbs.sampler so better to just stem once

txtCorpus <- tm_map(txtCorpus, removeWords, stopwords("english"))

# remove custom stopwords
txtCorpus <- tm_map(txtCorpus, removeWords, c("data", "science", "scientist", "will", "work", "experience")) 
txtCorpus <- tm_map(txtCorpus, stemDocument)
txtCorpus <- tm_map(txtCorpus, removePunctuation)
txtCorpus <- tm_map(txtCorpus, removeNumbers)

dtmControl <- list(stemming = F, 
                   stopwords = F, 
                   wordLengths = c(1, Inf), 
                   removeNumbers = T,
                   removePunctuation = F,
                   bounds = list(global = c(2, Inf)))

txtDtm <- DocumentTermMatrix(txtCorpus,
                             control = dtmControl)

# distribution of word frequencies
table(row_sums(txtDtm))

dtmPlot(txtDtm,1:30, "Top 30 words original")





#---------------------------------------------------------------------
#  3. (Optional) Remove most frequent terms using TF-IDF
# based on http://davidmeza1.github.io/2015/07/20/topic-modeling-in-R.html

## remove terms using tf-idf
# term_tfidf <- tapply(txtDtm$v/row_sums(txtDtm)[txtDtm$i], txtDtm$j, mean) * log2(nDocs(txtDtm)/col_sums(txtDtm > 0))

# summary(term_tfidf)
# 
# txtDtm <- txtDtm[,term_tfidf >= summary(term_tfidf)["Median"]]
# summary(col_sums(txtDtm))
# table(col_sums(txtDtm))
# dim(txtDtm)

#---------------------------------------------------------------------
#  4. (Optional) Remove sparse terms

# Decide how much sparsity you want
# dim(txtDtm)
# sparsity <- 0.999
# removeSparseTerms(txtDtm,sparsity) %>% dim()
# summary(col_sums(txtDtm))
# table(col_sums(txtDtm))

# Overwrite txtDtm with new sparsity level
# txtDtm <- removeSparseTerms(txtDtm,sparsity)



#---------------------------------------------------------------------
#  6. Adjust Document Term Matrix to Remove Documents with no contents
#   After all our transformation (stopword removal etc) we may be left with some rows
#   of our document term matrix that have no entries. This is a problem for the topic modelling
#   algorithm. 
#   Instead of removing the empty rows from the dtm matrix, we can identify the documents in our corpus 
#   that have zero length and remove the documents directly from the corpus, before performing a second 
#   dtm with only non empty documents.This is useful to keep a 1:1 correspondence between the dtm and the corpus.


dim(txtDtm)
dim(dt_all)

rowTotals <- row_sums(txtDtm) 
# empty.rows <- txtDtm[rowTotals == 0, ]$dimnames[1][[1]]
emptyRows <- rowTotals == 0

paste("we have ", sum(emptyRows), "empty Rows")

dt_all[emptyRows, text]

firstRow <- txtDtm[emptyRows,]

colnames(txtDtm)[firstRow$j]


if(sum(emptyRows >0))
  # if there are documents with no entries in the dtm these will be removed 
{
  print("WE HAVE REMOVED DOCUMENTS FROM THE DATA")
  length(txtCorpus)
  dim(txtDtm)
  txtCorpus <- txtCorpus[!emptyRows]
  txtDtm <- DocumentTermMatrix(txtCorpus,
                               control = dtmControl)
  length(txtCorpus)
  dim(txtDtm)
  dt_removed <- dt_all[emptyRows]
  dt_all <- dt_all[!emptyRows]
  
}

#---------------------------------------------------------------------
#  3. Identify words selected to be used in document term matrix
vocab <- colnames(txtDtm)

wordsUsedList <-  apply(txtDtm, 1, function(x){
  glue_collapse(vocab[x>0], sep = " ")
  # sum(x)
})

dt_all[, wordsUsed := unlist(wordsUsedList)]


# dt_all[1:90,list(text, wordsUsed)]


#---------------------------------------------------------------------
#  5. Investigate specific terms. Bring back examples
# 
# freq %>% class()
# rownames(freq)[1]
# 
# idxWord <- txtDtm[,"resetfiori"] %>% as.matrix() %>% as.vector() > 0
# dt_all[idxWord, text]



#---------------------------------------------------------------------
#   8. Partitioning into Train/Validation

idx_train  <- dt_all$fold %in% train_folds
idx_val    <- dt_all$fold %in% val_folds

txtDtm_train <-txtDtm[idx_train,]
txtDtm_valid <-txtDtm[idx_val,]

dt_train <-dt_all[idx_train]
dt_valid <-dt_all[idx_val]

txtCorpus_train <-txtCorpus[idx_train]
txtCorpus_valid <-txtCorpus[idx_val]

dtmCols <- ncol(txtDtm_train)
dtmRows <- nrow(txtDtm_train)
#--------------------------------------------------------------
# DONE. Save results and gc()

if (exists("dt_removed")){
  save(dt_all, 
       dt_removed,
       train_folds,
       val_folds,
       #idxFilter,
       file = file.path(dirRData,'05a_dt_all.RData'))
} else {
  save(dt_all, 
       train_folds,
       val_folds,
       #idxFilter,
       file = file.path(dirRData,'05a_dt_all.RData'))
}

save(
  #filter_name1,
   #  filter_condition1,
    # filter_name2,
     #filter_condition2,
     field_name,
     file = file.path(dirRData,'05a_settings.RData'))


save(dt_train, 
     file = file.path(dirRData,'05a_dt_train.RData'))

save(dt_valid, 
     file = file.path(dirRData,'05a_dt_valid.RData'))

save(txtCorpus,
     file = file.path(dirRData,'05a_txtCorpus.RData'))

save(txtCorpus_train,
     file = file.path(dirRData,'05a_txtCorpus_train.RData'))

save(txtCorpus_valid,
     file = file.path(dirRData,'05a_txtCorpus_valid.RData'))

save(txtDtm,
     file = file.path(dirRData,'05a_txtDtm.RData'))

save(txtDtm_train,
     dtmRows,
     dtmCols,
     field_name,
     filter,
     file = file.path(dirRData,'05a_txtDtm_train.RData'))

save(txtDtm_valid,
     field_name,
     filter,
     file = file.path(dirRData,'05a_txtDtm_valid.RData'))


cleanUp(functionNames)
gc()
