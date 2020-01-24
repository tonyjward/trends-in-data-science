# 07_Shiny_TopicModelling.R

# Purpose: To produce visualisations and predicted topic probabilities for a series of topic models
#           that were generated from 05g fitting models with optimal settings.R


#---------------------------------------------------------------------
#   _. Load data required

load(file = file.path(dirRData, '05_models.RData'))
load(file = file.path(dirRData, '03_txtCorpus.RData'))
load(file = file.path(dirRData, '03_txtDtm.RData'))
load(file = file.path(dirRData, '03_dt_all.RData'))

#---------------------------------------------------------------------
#   _. Load data required



outputData<- lapply(names(fitted_many_p), function(x) {
  # LDA_fit <- fitted_many_p[[1]]
  
  LDA_fit <- fitted_many_p[[x]]
  
  # VISUALISE TOPICS
  # Note that we use the just the corpus and document term matrix from the training data
  # as this was the data used to train the model
  
  print(LDA_fit@k)
  topicsizes <- LDA_fit@k

  jsonviz <- topicJson(LDA_fit, txtCorpus, txtDtm)
  x <- fromJSON(jsonviz)

  
  # OBTAIN TOPIC PROBABILITIES
  # Note that we score the entire data (both training and validation datasets) and then
  # add a column indicating whether the row is in the training or validation set
  
  # posterior topic probabilities
  topic_probsAll <- posterior(LDA_fit,newdata = txtDtm)$topics # or use LDA_fit@gamma which "should" give same results but doesn't
  
  # re-order the topic probabilities to match the visualisation
  topic_probsAll <- topic_probsAll[,x$topic.order] 
  colnames(topic_probsAll) <- paste0("Topic",c(1:topicsizes))
  
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
  
  # rename columns to be more informative i.e. rather than Topic1 rename as top words followed by (Topic1)
  topicNames <- grep("Topic", colnames(topic_probsAll), value = TRUE)
  colnames(topic_probsAll) <- paste0(top_words$topWords," (", topicNames, ")")
  
  # export topic probabilities, topic assignments and raw text field to csv file
  outputAll=data.table(round(100*topic_probsAll),
                       doc_id = dt_all[,doc_id],
                       text_field = dt_all[,text], 
                       partition = ifelse(dt_all[["fold"]] %in% train_folds,"TRAIN","VALID"))
  
  
  # replace line endings for all character variables so we can export
  # characterIdx <- sapply(outputAll, is.character)
  # characterNames <- names(characterIdx)[characterIdx]
  # 
  # outputAll[, (characterNames):= lapply(.SD, function(x){
  #   gsub("[\r\n]", "", x)
  # }), .SDcols = characterNames]
  
  outputMolten <- melt(outputAll, 
                       id.vars = c("doc_id", "text_field"), 
                       measure.vars = grep(pattern = 'Topic', colnames(outputAll), value = TRUE),
                       value.name = "Probability",
                       variable.name = "Topic")
  
  # create data.frame to re-order topics
  topicReorder <- data.frame(topic = x$topic.order,
                             newTopic = 1:topicsizes)
  
  # give nicer column names for shiny app
  setnames(top_words,
           old = c("topic", "topWords"),
           new = c("Topic", "Top Words"))
  
  list(jsonviz = jsonviz, 
       top_words = top_words, 
       outputMolten = outputMolten)
})

names(outputData) <- hyperparams$k  


# save for use in shiny app
saveRDS(outputData,
     file = file.path(dirShiny, '07_OutputData.RData'))

cleanUp(functionNames)
gc()
