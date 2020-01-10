topicProb <- function(input, output, session, inputData){
  output$table <- DT::renderDataTable({
    
    # rename column names e.g. Topic1 becomes "1"
    #topicNames <- grep("Topic", colnames(inputData()),value = TRUE)

    
    #displayNames <- c("text_field",topicNames)
    
    datatable(
      inputData()[order(-`Posted Date`)],
      filter = "top",
      options = list(
        autoWidth = TRUE,
        scrollX = TRUE, # required to change column length https://github.com/rstudio/DT/issues/29
        columnDefs = list(list(width = '1000px', targets = 4)))
    )
  }) 
}


