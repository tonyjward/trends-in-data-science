reportsUI <- function(id, choices, selected){
  ns <- shiny::NS(id)
  
  tagList(
    selectInput(ns("select"), 
                label = NULL, 
                choices = choices,
                selected = selected),
    
    hr(),
    plotOutput(ns("plot"))
  ) 
}