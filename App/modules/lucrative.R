lucrative <- function(input, output, session, inputData){
  
  # Time Series Bar Plot
  output$plotContract <- renderPlot({
    
    plotmo(inputData()[[2]])
    
  })
  
  output$plotPerm <- renderPlot({
    
    plotmo(inputData()[[1]])
    
  })
  
}