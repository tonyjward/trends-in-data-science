trainingUI <- function(id, choices, selected){
  ns <- shiny::NS(id)
  
  tagList(
    fluidRow(
      column(6,
             wellPanel(
               dateRangeInput(ns("daterangeTraining"), h3("Date range: Model Training"),
                              start = "2018-09-01",
                              end = "2018-09-03")
               
             )),
      column(6,
             wellPanel(
               radioButtons(ns("selectedCooling"), label = h3("Cooling Stage to be optimised"),
                            choices = c(0,1,2,3), selected = 1)
             ))
    ),

    fluidRow(
      column(6,
             wellPanel(
               h3("Data Quality"),
               tableOutput(ns("dataQuality"))
             )),
      column(6,
             wellPanel(
               h3("Thermal Coefficients"),
               actionButton(inputId = ns("startTraining"),
                            label = "Run"),
               tableOutput(ns("coefficients"))
             ))
      )
   
  )
}

