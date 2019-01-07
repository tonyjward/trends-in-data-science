topicWordsUI <- function(id){
  ns <- shiny::NS(id)
  
  tagList(
    tableOutput(ns("table"))
  ) 
}