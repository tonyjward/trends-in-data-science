heatRunUI <- function(id, choices, selected){
  ns <- shiny::NS(id)
  
  tagList(
    tabPanel(title = "Heat Run Data",
             sidebarLayout(
               
               #-----------------------------------------------------------------------
               #   1.  Heat run data for both top oil gradient and winding time constant?
               
               sidebarPanel(
                 radioButtons(ns("heatRun_dT_hr"), 
                              "do you have heat run data for Top Oil Gradient",
                              choices = c("YES" ,"NO"),
                              selected = character(0)),
                 radioButtons(ns("heatRun_tao_w"), 
                              "do you have winding time constant",
                              choices = c("YES" ,"NO"),
                              selected = character(0))
               ),
               
               #-----------------------------------------------------------------------
               #   2.  If data is available then allow user input, else calculate and display value
               
               mainPanel(
                 conditionalPanel(
                   condition = paste0("input['", ns("heatRun_dT_hr"), "'] == 'YES'"),          
                   numericInput(ns("dT_hr"),
                                h3("Hot Spot to Top Oil Gradient at Rated Current"),
                                value = NULL)
                 ),
                 conditionalPanel(
                   condition = paste0("input['", ns("heatRun_dT_hr"), "'] == 'NO'"),
                   h3("Hot Spot to Top Oil Gradient at Rated Current"),
                   textOutput(ns("dT_hr")),
                   tags$p("")
                 ),
                 conditionalPanel(
                   condition =  paste0("input['", ns("heatRun_tao_w"), "'] == 'YES'"),
                   numericInput(ns("tao_w"),
                                h3("Winding time constant"),
                                value = NULL)
                 ),
                 conditionalPanel(
                   condition = paste0("input['", ns("heatRun_tao_w"), "'] == 'NO'"),
                   h3("Winding time constant"),
                   textOutput(ns("tao_w")),
                   tags$p("")
                 )
               )
             )) 
  ) 
}

 
