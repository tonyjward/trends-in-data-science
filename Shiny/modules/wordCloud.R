wordCloud <- function(input, output, session, glmnet_list){
  
  job_type <- 'Permanent'
  
  glmnet_coef <- glmnet_list[['Permanent']]
  
  threshold <- 100
  
  # Word clouds
  output$wordCloudPositive <- renderWordcloud2({
    wordcloud2(glmnet_coef[freq > threshold & positive_coef == TRUE][order(freq),.(word, freq)])
    
  })
  
  output$wordCloudNegative <- renderWordcloud2({
    wordcloud2(glmnet_coef[freq > threshold & positive_coef == FALSE][order(freq),.(word, freq)])
  })
  
  
  
}