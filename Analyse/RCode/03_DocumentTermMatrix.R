# 03_DocumentTermMatrix.R

# Purpose: Produce corpus and document term matrix for use in topic modelling

# In order to get readable output in the ldaVIs plot, we "unstem" the stemmed words
# i.e. the stemming process is required for topic modelling (machine >> machin) but for plotting we want to 
# go back the other way. 
# In order to do this we take the most likely choice based on frequency count of stemmed/unstemmed terms

# Contents:
#  0. Settings
#  1. Load data required
#  2. Create Corpus
#  3. Process data
#  4. Remove cases where text is NA or missing 
#  5. Stem
#  6. Document term matrix
#  7. Replace Stemmed words with the most likely unstemmed equivilant
#  8. 'Undo stem' the document term matrix to get meaningful column names
#  9. Use document term matrix to create job descriptions using unstemmed words
#  10. Identify words selected to be used in document term matrix
#  11. Partitioning into Train/Validation
#  DONE. Save results and gc()

# ----------------------------------------------------------
#  0. Settings

text_field <- "Skills"

train_folds <- 1:8
val_folds   <- 9:10

# minimum occurances of the word required to be included in document term matrix
min_bound <- 30

#---------------------------------------------------------------------
#  1. Load data required
dt_all <- readRDS(dt, file = file.path(dirRData, "02_dt_all.RData"))

#---------------------------------------------------------------------
#  2. Create Corpus
setnames(dt_all,text_field,"text")

# remove all punctuation
dt_all[, text := gsub("[[:punct:]]|–"," ", text)]

txtCorpus = Corpus(DataframeSource(dt_all[,c("doc_id", "text"), with = FALSE])) 

#---------------------------------------------------------------------
#  3. Process data

# lower case
txtCorpus = tm_map(txtCorpus, content_transformer(tolower))

# convert bigrams to unigrams
txtCorpus <- tm_map(txtCorpus,
                    content_transformer(gsub),
                    pattern = "big data", replacement = "big_data")

# remove stopwords, punctation etc
txtCorpus <- tm_map(txtCorpus, stripWhitespace) 
txtCorpus <- tm_map(txtCorpus, removeWords, stopwords("english")) 
txtCorpus <- tm_map(txtCorpus, removeWords, c("data", "science", "scientist", "will", "work", "â", "Â", "experience"))
txtCorpus <- tm_map(txtCorpus, removePunctuation)
txtCorpus <- tm_map(txtCorpus, removeNumbers)

#---------------------------------------------------------------------
#  4. Remove cases where text is NA or missing 

txtNchars <- sapply(txtCorpus, function(x){
  x[[1]][[1]] %>% nchar() 
}) %>% as.vector()

idx_empty <- is.na(txtNchars) | txtNchars == 0

paste("we have ", sum(idx_empty), "empty Rows")

dt_all[idx_empty, text]

if(sum(idx_empty >0))
  # if there are documents with no entries in the dtm these will be removed 
{
  print("WE HAVE REMOVED DOCUMENTS FROM THE DATA")
  txtCorpus <- txtCorpus[!idx_empty]
  dt_removed <- dt_all[idx_empty]
  dt_all <- dt_all[!idx_empty]
}

#---------------------------------------------------------------------
#  5. Stem

# save unstemmed corpus for later
txtCorpusUnStemmed <- copy(txtCorpus)

# stem corpus
txtCorpusStemmed <- tm_map(txtCorpus, stemDocument)

#---------------------------------------------------------------------
#  6. Document term matrix

dtm_control <- list(stemming = F,
                    stopwords = F, 
                    wordLengths = c(1, Inf), 
                    removeNumbers = T,
                    removePunctuation = F,
                    bounds = list(global = c(min_bound, Inf)))

dtm_control_no_bounds <- list(stemming = F,
                              stopwords = F, 
                              wordLengths = c(1, Inf), 
                              removeNumbers = F,
                              removePunctuation = F,
                              bounds = list(global = c(1, Inf)))

txtDtmStemmed <- DocumentTermMatrix(txtCorpusStemmed,
                             control = dtm_control)

txtDtmUnStemmed <- DocumentTermMatrix(txtCorpusUnStemmed,
                             control = dtm_control_no_bounds)

#---------------------------------------------------------------------
#  7. Replace Stemmed words with the most likely unstemmed equivilant

# frequency count of unstemmed words accross all documents
unstemmed_words <- data.table(doc_id = seq(1,ncol(txtDtmUnStemmed)),
                             unstemmed = colnames(txtDtmUnStemmed),
                             freq = col_sums(txtDtmUnStemmed))

# create a corpus where each document contains an original word from above, then stem
unstemmed_corpus <- unstemmed_words %>% 
  rename('text' = 'unstemmed') %>%
  DataframeSource() %>% 
  Corpus() %>%
  tm_map(stemDocument)

# add stemmed words onto list of original words
unstemmed_words[, stemmed := sapply(unstemmed_corpus, as.character)]

# select the most frequently used unstemmed word for each stemmed word
# https://stackoverflow.com/questions/24558328/how-to-select-the-row-with-the-maximum-value-in-each-group
mapping <- unstemmed_words[unstemmed_words[, .I[which.max(freq)], by=stemmed]$V1]

#---------------------------------------------------------------------
#  8. 'Undo stem' the document term matrix to get meaningful column names

colnames_stemmed <- data.frame(stemmed = colnames(txtDtmStemmed))

colnames_mapping <- mapping[colnames_stemmed, on = "stemmed"]

# sometimes the unstemmed word is NA
colnames_mapping[!is.na(unstemmed), replacement := unstemmed]
colnames_mapping[is.na(unstemmed), replacement := stemmed]

colnames(txtDtmStemmed) <- colnames_mapping$replacement

#---------------------------------------------------------------------
#  9. Use document term matrix to create job descriptions using unstemmed words

wordsUsedList2 <-  apply(txtDtmStemmed, 1, function(x){
  glue_collapse(colnames(txtDtmStemmed)[x>0], sep = " ")
  # sum(x>0)
})

jumbled_sentence <- unlist(wordsUsedList2)

bag_of_words <- data.table(doc_id = seq(1, length(jumbled_sentence)),
                             text = jumbled_sentence)

txtCorpus <- bag_of_words %>% DataframeSource() %>% Corpus() 


txtDtm <- DocumentTermMatrix(txtCorpus,
                             control = dtm_control_no_bounds)

#---------------------------------------------------------------------
#  10. Identify words selected to be used in document term matrix
vocab <- colnames(txtDtm)

wordsUsedList <-  apply(txtDtm, 1, function(x){
    glue_collapse(vocab[x>0], sep = " ")

})

dt_all[, wordsUsed := unlist(wordsUsedList)]

#---------------------------------------------------------------------
#   11. Partitioning into Train/Validation

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
       mapping,
       #idxFilter,
       file = file.path(dirRData,'03_dt_all.RData'))
} else {
  save(dt_all, 
       train_folds,
       val_folds,
       mapping,
       #idxFilter,
       file = file.path(dirRData,'03_dt_all.RData'))
}

save(text_field,
     file = file.path(dirRData,'03_settings.RData'))

save(dt_train, 
     file = file.path(dirRData,'03_dt_train.RData'))

save(dt_valid, 
     file = file.path(dirRData,'03_dt_valid.RData'))

save(txtCorpus,
     file = file.path(dirRData,'03_txtCorpus.RData'))

save(txtCorpus_train,
     file = file.path(dirRData,'03_txtCorpus_train.RData'))

save(txtCorpus_valid,
     file = file.path(dirRData,'03_txtCorpus_valid.RData'))

save(txtDtm,
     file = file.path(dirRData,'03_txtDtm.RData'))

save(txtDtm_train,
     dtmRows,
     dtmCols,
     text_field,
     filter,
     file = file.path(dirRData,'03_txtDtm_train.RData'))

save(txtDtm_valid,
     text_field,
     filter,
     file = file.path(dirRData,'03_txtDtm_valid.RData'))


cleanUp(functionNames)
gc()
