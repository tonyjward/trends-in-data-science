wordCloud <- function(input, output, session, glmnet_list){
  
  job_type <- 'Permanent'
  
  glmnet_item <- glmnet_list[['Permanent']]
  glmnet_coef <- glmnet_item[[1]]
  idx_positive <- glmnet_item[[2]]
  idx_negative <- glmnet_item[[3]]
  
  # Time Series Bar Plot
  output$wordCloud <- renderPlot({
    
    wordcloud(words = glmnet_coef[idx_positive, rn],
              freq = glmnet_coef[idx_positive, coef],
              min.freq=2,
              #scale=c(6, .1), 
              colors=brewer.pal(6, "Dark2"))
    
  })
  
  
  
}