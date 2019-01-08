topics <- function(input, output, session, inputData){
  
  # Time Series Bar Plot
  output$plot <- renderPlot({
    
    topicNames <- grep("Topic", colnames(inputData), value = TRUE)
    
    newNames <- paste0(topWords$topWords," (", topicNames, ")")
    
    setnames(inputData,
             old = topicNames,
             new = newNames)
    
    moltenData <- melt(data = inputData,
                       id.vars = "job_type",
                       measure.vars = newNames)
    
    ggplot(data = moltenData,
           aes(x = variable , y = value, fill = job_type)) + geom_bar(stat = "identity") + coord_flip() + labs(x = "Topic", y = "Sum of Topic Probabilities")
    
  })
  
}


