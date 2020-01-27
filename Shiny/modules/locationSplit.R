locationSplit <- function(input, output, session, inputData, aggData){
  
  # Roles
  output$plotRoles <- renderPlot({

    ggplot(data = aggData[job_type == input$job_type],
           aes(x = London, y = N, fill = London))  + geom_bar(stat = "identity",
                                                              alpha = 0.7) + labs(y = "Job Count")
  })
  
  # Pay
  output$plotPay <- renderPlot({
    
    ggplot(data = inputData[job_type == input$job_type], aes(x = London, y = salaryMax, fill = London)) + 
      geom_boxplot(alpha = 0.7) + scale_y_continuous(limits = c(0, NA),
                                          breaks = scales::pretty_breaks(n = 10)) 
  })
  
}


