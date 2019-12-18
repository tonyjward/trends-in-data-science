topicWordsUI <- function(id){
  ns <- shiny::NS(id)
  
  tagList(
    textOutput(ns("selectedK")),
    tableOutput(ns("table"))
  ) 
}