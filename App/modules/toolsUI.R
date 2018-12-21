toolsUI <- function(id){
  ns <- shiny::NS(id)
  
  tagList(
    plotOutput(ns("plot"))
  ) 
}