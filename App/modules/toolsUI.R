toolsUI <- function(id){
  ns <- shiny::NS(id)
  
  tagList(
    plotOutput(ns("plot")),
    tableOutput(ns("table"))
  ) 
}