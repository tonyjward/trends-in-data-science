topicNumUI <- function(id, choices, selected){
  ns <- shiny::NS(id)
  
  tagList(
    plotOutput(ns("plot")),
    selectInput(inputId = ns("selectedK"),
                label = h3("Select Number of Topics"),
                choices = choices,
                selected = selected
                )
  ) 
}