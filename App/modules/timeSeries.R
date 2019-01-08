timeSeries <- function(input, output, session, jobData){
  
  # Time Series Bar Plot
  output$plot <- renderPlot({
    ggplot(data = jobData, aes_string(x = "yearMonDay", fill = "Tools")) + "geom_bar"()
  })
  
  
}