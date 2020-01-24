locationSplitUI <- function(id){
  ns <- shiny::NS(id)
  
  tagList(
    radioButtons(ns("job_type"), label = h3("Select Job Type"),
                 choices = list("Permanent", "Contract"), 
                 selected = "Permanent"),
    br(),
    h3("Roles"),
    plotOutput(ns("plotRoles")),
    br(),
    h3("Pay"),
    plotOutput(ns("plotPay"))
  ) 
}