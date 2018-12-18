deployUI <- function(id){
  ns <- shiny::NS(id)
  uiOutput(ns("deployToDatabase"))
  
}


