roles <- function(input, output, session, inputData){
  
  # Time Series Bar Plot
  output$plotContract <- renderPlot({
    
    ggplot(data = inputData()[job_type == "Contract"], aes(x = Tools, fill = Tools)) + geom_bar(stat = "count")
    
  })
  
  output$plotPerm <- renderPlot({
    
    ggplot(data = inputData()[job_type == "Permanent"], aes(x = Tools, fill = Tools)) + geom_bar(stat = "count")
    
  })
  
}