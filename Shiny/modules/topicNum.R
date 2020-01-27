topicNum <- function(input, output, session, inputData){
  
  output$plot <- renderPlot({
    ggplot(inputData, aes(x = k, y = perplexity)) + geom_line() + labs(title = "Number of Topics vs Perplexity",
                                                                             x = "No. Topics",
                                                                             y = "Perplexity")
  })
  
  return(reactive({input$selectedK}))
}


