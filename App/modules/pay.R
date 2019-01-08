pay <- function(input, output, session, inputData){
  
  # Time Series Bar Plot
  output$plotContract <- renderPlot({
    
    ggplot(data = inputData[job_type == "Contract"], aes(x = Tools, y = salaryMax, fill = Tools)) + geom_boxplot()
    
  })
  
  output$plotPerm <- renderPlot({
    
    ggplot(data = dt_all[job_type == "Permanent"], aes(x = Tools, y = salaryMax, fill = Tools)) + geom_boxplot()
    
  })
  
}