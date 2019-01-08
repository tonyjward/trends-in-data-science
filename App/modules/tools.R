tools <- function(input, output, session, inputData){
  
  # Time Series Bar Plot
  output$plot <- renderPlot({
    
    inputData[, Tools := ifelse(Python_R == "TRUE_TRUE", "Python or R",
                         ifelse(Python_R == "TRUE_FALSE", "Python but not R",
                                ifelse(Python_R == "FALSE_TRUE", "R but not Python","Neither Language")))]
    
    plotData <- inputData[,.N, .(Tools, job_type)]
    
    ggplot(data = plotData,
           aes(x = Tools, y = N, fill = job_type))  + geom_bar(stat = "identity") + coord_flip() + labs(y = "Job Count")
  })
  
  
}