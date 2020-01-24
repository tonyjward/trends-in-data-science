topicProbUI <- function(id){
  ns <- shiny::NS(id)
  
  tagList(
    DT::dataTableOutput(ns("table"))
  ) 
}