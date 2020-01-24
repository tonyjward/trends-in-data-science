locationSplitUI <- function(id){
  ns <- shiny::NS(id)
  
  tagList(
    h3("Roles"),
    plotOutput(ns("plotRoles")),
    br(),
    h3("Pay"),
    plotOutput(ns("plotPay"))
  ) 
}