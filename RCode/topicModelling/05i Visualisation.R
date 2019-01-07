# 05e Visualisation.R
# Author: Tony Ward
# Date: 17 September 2018

# Purpose: To produce visualisations and predicted topic probabilities for a series of topic models
#           that were generated from 05g fitting models with optimal settings.R


# Outstanding
# Turn posterior propability export into a function for training and test data


#---------------------------------------------------------------------
#   _. Load data required

# To use the most recently run models use 
# identifier <- '05g_models'
# Alternatively specify the complete identifier such as 
# identifier <- '05g_directorate_Network_Operations_yearQtr_2018Q12018Q22018Q3_allImprovements_iterations_10000'
# identifier <- '05g_directorate_Network_Operations_yearQtr_2018Q12018Q22018Q3_description_iterations_10000'

# LDA
identifier <- '05g_models'

# CTM
# identifier <- '05o_models'


load(file = file.path(dirRData,paste0(identifier,'.RData')))
load(file = file.path(dirRData,'05a_txtCorpus.RData'))
load(file = file.path(dirRData,'05a_txtDtm.RData'))
#load(file = file.path(dirRData,'05a_txtDtm_train.RData'))
load(file = file.path(dirRData,'05a_dt_all.RData'))


# if you want to limit the number of rows that can scored with predicted probabilities
maxRows <- 9999999


outputData<- lapply(names(fitted_many_p), function(x) {
  # LDA_fit <- fitted_many_p[[1]]
  
  LDA_fit <- fitted_many_p[[x]]
  
  # VISUALISE TOPICS
  # Note that we use the just the corpus and document term matrix from the training data
  # as this was the data used to train the model
  
  print(LDA_fit@k)
  topicsizes <- LDA_fit@k
  directory <- paste(dirROutput,"/",identifier,"_size_",topicsizes,sep="")
  jsonviz <- topicJson (LDA_fit, txtCorpus, txtDtm)
  x <- fromJSON(jsonviz)
  serVis(jsonviz, out.dir=directory, open.browser = FALSE,as.gist=FALSE)
  
  # OBTAIN TOPIC PROBABILITIES
  # Note that we score the entire data (both training and validation datasets) and then
  # add a column indicating whether the row is in the training or validation set
  
  # obtain posterior term/topic probabilities
  posterior_All = posterior(LDA_fit,
                            newdata = txtDtm)
  
  # grab topic probabilities
  topic_probsAll <- posterior_All$topics
  
  # re-order the topic probabilities to match the visualisation
  topic_probsAll <- topic_probsAll[,x$topic.order] 
  colnames(topic_probsAll) <- paste0("Topic",c(1:topicsizes))
  
  # create correlation matrix of topic probabilities
  # res <- cor(topic_probsAll) %>% round(3)
  # 
  # write.table(res,
  #             file = paste0(directory,'/correlations_',identifier,"_size_",topicsizes,'.txt'))
  
  # assign a topic to each document
  topic_temp=apply(topic_probsAll,1,function(x) colnames(topic_probsAll)[which(x==max(x))])
  flatten=function(x){paste(x,collapse=" ")}
  topic_flat = lapply(topic_temp, flatten)
  topic_list_df=lapply(topic_flat, data.frame, stringsAsFactors = FALSE)
  topic_classAll=rbind.fill(topic_list_df)
  colnames(topic_classAll) = "topic_pred"
  
  # identify duplicate classifications
  dup_idx = sapply(topic_classAll, function(x){nchar(x)>8})
  topic_classAll$topic_pred[dup_idx] <- "Multiple"
  
  # top topic words
  top_words <- tidy(LDA_fit, matrix = "beta") %>%
    group_by(topic) %>%
    top_n(5, beta) %>%
    ungroup() %>%
    arrange(topic, -beta) %>%
    group_by(topic) %>%
    slice(seq_len(5)) %>% # to make sure we definitely only bring back top n results since there may be ties
    group_by(topic) %>%
    summarize (topWords = paste(term, collapse = " ")) %>%
    mutate(topic = paste0("Topic",topic)) %>%
    as.data.table()
  
  # re-order the topic numbers to match the visualisation
  top_words <- top_words[x$topic.order]
  top_words[,topic := paste0("Topic",c(1:topicsizes))]
  
  
  
  
  # export topic probabilities, topic assignments and raw text field to csv file
  outputAll=data.table(round(100*topic_probsAll), 
                       topic=topic_classAll[[1]],
                       text_field = dt_all[,text], 
                       partition = ifelse(dt_all[["fold"]] %in% train_folds,"TRAIN","VALID")
  )
  
  
  outputAll[top_words, topWords := i.topWords, on = "topic"]
  outputAll[is.na(topWords), topWords := "NA - Multiple Topics"]
  
  outputAll[,wordsUsed := dt_all$wordsUsed]
  
  outputAll <- cbind(outputAll, dt_all[,-c("text", "wordsUsed")])
  
  
  # replace line endings for all character variables so we can export
  
  characterIdx <- sapply(outputAll, is.character)
  characterNames <- names(characterIdx)[characterIdx]
  
  outputAll[, (characterNames):= lapply(.SD, function(x){
    gsub("[\r\n]", "", x)
  }), .SDcols = characterNames]
  
  # save as data.frame 
  
  # facet_wrap plot of top words
  # av_CSAT <- outputAll[topWords != "NA - Multiple Topics",list(overall_CSAT_score = mean(overall_CSAT_score, na.rm = TRUE),
  #                                                              count = .N),, by = list(topic = gsub("Topic","",topic))][order(overall_CSAT_score)]
  # 
  # create data.frame to re-order topics
  topicReorder <- data.frame(topic = x$topic.order,
                             newTopic = 1:topicsizes)
  
  lda_topics <- tidy(LDA_fit, matrix = "beta")
  
  ap_top_terms <- lda_topics %>%
    group_by(topic) %>%
    top_n(8, beta) %>%
    ungroup() %>%
    arrange(topic, -beta) %>%
    group_by(topic) %>%
    slice(seq_len(8)) %>% # to make sure we definitely only bring back top n results since there may be ties
    left_join(topicReorder, by = "topic") %>%
    as.data.frame() %>%
    mutate(topic = newTopic) %>%
    select(-one_of("newTopic"))# swaps names round and gets rid of old topic
  
  # visualise top words per topic
  # plotTopWords <- ap_top_terms %>%
  #   mutate(term = reorder(term, beta)) %>%
  #   ggplot(aes(term, beta, fill = factor(topic))) +
  #   geom_col(show.legend = FALSE) +
  #   facet_wrap(~ factor(topic, levels = av_CSAT$topic), scales = "free") +
  #   coord_flip()
  # 
  
  topicsizes <- LDA_fit@k
  directory <- paste(dirROutput,"/",identifier,"_size_",topicsizes,sep="")
  
  
  # save JSON for shiny
  # saveRDS(jsonviz, file = paste0(directory,'/jsonviz_',identifier,"_size_",topicsizes,'.RData'))
  
  # save topic probability matrix together with original data
  # write.table(outputAll[1:min(nrow(outputAll),maxRows),], paste0(directory,'/topics_all_',identifier,"_size_",topicsizes,'.txt'), row.names=F,eol="\r\n",sep='\t')
  
  list(outputAll,jsonviz, top_words)
})


names(outputData) <- hyperparams$k  

# save for future reference
save(outputData,
     file = file.path(dirRData,paste0('05i_',identifier,'_OutputData.RData')))

# save for immediate use
save(outputData,
     file = file.path(dirRData,paste0('05i_OutputData.RData')))

# save for use in shiny app
saveRDS(outputData,
     file = 'App/RData/05i_OutputData.RData')


cleanUp(functionNames)
gc()