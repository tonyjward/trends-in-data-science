topicProb <- function(input, output, session, inputData){
  output$table <- DT::renderDataTable({
    
    columnNames <- c("text_field",grep("Topic", colnames(inputData),value = TRUE))
    
    datatable(
      inputData[, ..columnNames],
      filter = "top",
      options = list(
        autoWidth = TRUE,
        scrollX = TRUE, # required to change column length https://github.com/rstudio/DT/issues/29
        columnDefs = list(list(width = '1000px', targets = 1)))
    )
  }) 
}




