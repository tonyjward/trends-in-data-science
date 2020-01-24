overall <- function(input, output, session, inputData){
  
  # Time Series Bar Plot
  output$plot <- renderPlot({
    
    plotData <- inputData[,.N, job_type]
    
    ggplot(data = plotData,
           aes(x = job_type, y = N))  + geom_bar(stat = "identity") + labs(y = "Job Count")
  })
  
  
}