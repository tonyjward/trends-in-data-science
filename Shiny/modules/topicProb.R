topicProb <- function(input, output, session, inputData){
  output$table <- DT::renderDataTable({
    
    # rename column names e.g. Topic1 becomes "1"
    #topicNames <- grep("Topic", colnames(inputData()),value = TRUE)

    
    #displayNames <- c("text_field",topicNames)
    
    datatable(
      inputData()[order(-Probability), .(doc_id, text_field, Topic, Probability)],
      filter = "top",
      options = list(
        autoWidth = TRUE,
        scrollX = TRUE, # required to change column length https://github.com/rstudio/DT/issues/29
        columnDefs = list(list(width = '200px', targets = 3)))
    )
  }) 
}


