topicProb <- function(input, output, session, inputData){
  output$table <- DT::renderDataTable({
    
    inputData()[, doc_id := as.character(doc_id)]

    datatable(
      inputData()[, .(doc_id, text_field, Topic, Probability)],
      filter = "top",
      options = list(
        autoWidth = TRUE,
        scrollX = TRUE, # required to change column length https://github.com/rstudio/DT/issues/29
        columnDefs = list(list(width = '200px', targets = 2),
                          list(width = '80px', targets = 0))),
      rownames = FALSE,
      colnames = c("ID" = "doc_id",
                   "Description" = "text_field",
                   "Topic" = "Topic",
                   "Probability" = "Probability")
    )
  }) 
}