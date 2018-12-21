topicVizUI <- function(id, choices, selected){
  ns <- shiny::NS(id)
  
  tagList(
    visOutput(ns("plot"))
  ) 
}