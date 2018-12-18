monitorUI <- function(id){
  ns <- shiny::NS(id)
  
  tagList(
    
    # Display active substation/transformer with actively deployed thermal constants
    fluidRow(
      column(4,
             wellPanel(
               h3(textOutput(ns("activeSubstation"))),
               h3(textOutput(ns("activeTransformer"))))),
      column(8,
             wellPanel(
               h3("Active Thermal Constants"),
               DT::dataTableOutput(ns("tbl"))
             ))
    ),
    
    # Filter data based on time range
    dateRangeInput(ns("daterange"), "Date range: Model Validation",
                   start = "2018-09-08",
                   end = "2018-09-17"),
    
    # Plot Actual vs Predicted top oil temperature
    plotOutput(ns("validationTimeSeries")),
    
    # Plot original variables (load, cooling stage etc)
    reportsUI(ns("monitorPlot"), choices = plotVars, selected = plotVars[1])
  ) 
}


