tools <- function(input, output, session, inputData){
  
  # Time Series Bar Plot
  output$plot <- renderPlot({
    
    plotData <- inputData[,.N, .(Tools, job_type)]
    
    ggplot(data = plotData,
           aes(x = Tools, y = N, fill = job_type))  + geom_bar(stat = "identity") + coord_flip() + labs(y = "Job Count")
  })
  
  
}