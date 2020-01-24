locationSplit <- function(input, output, session, inputData, aggData){
  
  plotData <- inputData[,.N, .(job_type,London)]
  # Roles
  output$plotRoles <- renderPlot({

    ggplot(data = plotData[job_type == "Contract"],
           aes(x = London, y = N, fill = London))  + geom_bar(stat = "identity") + labs(y = "Job Count")
  })
  
  # Pay
  output$plotPay <- renderPlot({
    
    ggplot(data = inputData[job_type == "Permanent"], aes(x = London, y = salaryMax, fill = London)) + geom_boxplot() +
      scale_y_continuous(limits = c(0, NA),
                         breaks = scales::pretty_breaks(n = 10)) 
  })
  
}


