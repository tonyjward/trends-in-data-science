wordCloudUI <- function(id){
  ns <- shiny::NS(id)
  
  tagList(
    plotOutput(ns("wordCloud")),
    br()
  ) 
}