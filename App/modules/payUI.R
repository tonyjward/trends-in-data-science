payUI <- function(id){
  ns <- shiny::NS(id)
  
  tagList(
    h3("Perm"),
    plotOutput(ns("plotPerm")),
    br(),
    h3("Contract"),
    plotOutput(ns("plotContract"))
  ) 
}