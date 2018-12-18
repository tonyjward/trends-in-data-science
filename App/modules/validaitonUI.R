validationUI <- function(id, choices, selected){
  ns <- shiny::NS(id)
  
  tagList(
    fluidRow(
      column(6,
             wellPanel(
               dateRangeInput(ns("daterange"), "Date range: Model Validation",
                              start = "2018-09-08",
                              end = "2018-09-17")
               
             )),
      column(6,
             wellPanel(
               h3(textOutput(ns("activeSubstation"))),
               h3(textOutput(ns("activeTransformer"))),
               h3(textOutput(ns("activeCooling")))
             ))
    ),
    "If no data is shown, check that the dates selected have time spent in the active cooling state",
    plotOutput(ns("validationTimeSeries"))
    
  ) 
}

