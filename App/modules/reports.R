reports <- function(input, output, session, plotData){
  output$plot <- renderPlot({
    ggplot(plotData() %>% filter(variable == input$select),
           aes(x = time, y = value, group = "variable")) + geom_line(colour = "blue") +
      labs(title = NULL)
  })
}