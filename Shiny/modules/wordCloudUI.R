wordCloudUI <- function(id){
  ns <- shiny::NS(id)
  
  tagList(
    # plotOutput(ns("wordCloudPositive")),
    # plotOutput(ns("wordCloudNegative"))
    fluidRow(
      column(6,
             wellPanel(
               h3("Positive Coefficients"),
               plotOutput(ns("wordCloudPositive"))
             )),
      column(6,
             wellPanel(
               h3("Negative Coefficients"),
               plotOutput(ns("wordCloudNegative"))
             )))
      
    )

}