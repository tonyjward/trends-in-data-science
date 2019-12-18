topicVizUI <- function(id){
  ns <- shiny::NS(id)
  
  tagList(
    visOutput(ns("plot"))
  ) 
}