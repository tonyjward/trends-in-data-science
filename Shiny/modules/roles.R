roles <- function(input, output, session, inputData){
  
  # Time Series Bar Plot
  output$plotContract <- renderPlot({
    
    ggplot(data = inputData[job_type == "Contract"], aes(x = Tools, fill = Tools)) + geom_bar(stat = "count",
                                                                                              alpha = 0.7) +
      scale_y_continuous(limits = c(0, NA),
                         breaks = scales::pretty_breaks(n = 10)) +
      ylab("Job Count")
    
  })
  
  output$plotPerm <- renderPlot({
    
    ggplot(data = inputData[job_type == "Permanent"], aes(x = Tools, fill = Tools)) + geom_bar(stat = "count",
                                                                                               alpha = 0.7) +
      scale_y_continuous(limits = c(0, NA),
                         breaks = scales::pretty_breaks(n = 10)) +
      ylab("Job Count")
    
  })
  
}