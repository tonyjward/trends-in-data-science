inspectDataUI <- function(id){
  ns <- shiny::NS(id)
  DT::dataTableOutput(ns("tbl"))
    
  
}

