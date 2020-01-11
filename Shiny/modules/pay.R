pay <- function(input, output, session, inputData){
  
  # Time Series Bar Plot
  output$plotContract <- renderPlot({
    
    ggplot(data = inputData()[job_type == "Contract"], aes(x = Tools, y = salaryMax, fill = Tools)) + geom_boxplot() +
      scale_y_continuous(limits = c(0, NA))
    
  })
  
  output$plotPerm <- renderPlot({
    
    ggplot(data = inputData()[job_type == "Permanent"], aes(x = Tools, y = salaryMax, fill = Tools)) + geom_boxplot() +
      scale_y_continuous(limits = c(0, NA))
    
  })
  
}