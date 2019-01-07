topicProb <- function(input, output, session, inputData){
  output$table <- DT::renderDataTable({
    datatable(inputData)
  }) 
}