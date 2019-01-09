topicWords <- function(input, output, session, inputData, selectedK){
  output$table <- renderTable({
    inputData()
  })
  
  output$selectedK <- renderText({selectedK()})
}


