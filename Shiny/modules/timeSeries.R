timeSeries <- function(input, output, session, inputData){
  
  # Time Series Bar Plot
  output$plot <- renderPlot({
    ggplot(data = inputData(), aes_string(x = "yearMonDay", fill = "Tools")) + "geom_bar"()
  })
  
  
}