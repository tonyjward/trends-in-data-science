heatRun <- function(input,
                    output, 
                    session,
                    TName,
                    cooling,
                    constants){
  
  #-----------------------------------------------------------------------
  #   0.  Validate Inputs
  
  DT_OR <- reactive({
    validate(
      need(!is.null(constants()$xbest[2]), "Please train the model first")
    )
    constants()$xbest[2]
    })
  
  TName_ <- reactive({
    validate(
      need(!is.null(TName()), "Please train the model first")
    )
    TName()
  })
  
  cooling_ <- reactive({
    validate(
      need(!is.null(cooling()), "Please train the model first")
    )
    cooling()
  })
  
  heatRun_dT_hr_ <- reactive({
    validate(
      need(!is.null(input$heatRun_dT_hr), "Please enter heat run data first")
    )
    input$heatRun_dT_hr
  })
  
  heatRun_tao_w_ <- reactive({
    validate(
      need(!is.null(input$heatRun_tao_w), "Please enter heat run data first")
    )
    input$heatRun_tao_w
  })
  
  #-----------------------------------------------------------------------
  #   1.  Calculate/Enter Thermal Constants dT_hr and tao_w
  
  dT_hr <- reactive({
    
    if (heatRun_dT_hr_() == "YES") {
      input$dT_hr
    } else if (heatRun_dT_hr_() == "NO"){
      sql <- "SELECT [WHS_LIMIT], [ASSUMED_AMBIENT]
              FROM [RTTR_Dev].[dbo].[TRANSFORMER_RULES]
              WHERE TRANSFORMER_NAME_FK = ?id1 AND STAGE = ?id2 AND FLAG = 'Y';"
      
      query <- sqlInterpolate(conn, sql, 
                              id1 = TName_(),
                              id2 = cooling_())

      manufacturerAssumptions <- dbGetQuery(conn, query)
      
      # Calculation is dT_hr = WHS_LIMIT - dT_OR - ASSUMED_AMBIENT
      sum(manufacturerAssumptions$WHS_LIMIT[1] %>% as.numeric(),
          -1 * DT_OR() %>% as.numeric(),
          -1 * manufacturerAssumptions$ASSUMED_AMBIENT[1] %>% as.numeric())
    }
  })
  
  tao_w <- reactive({
    if (is.null(cooling))
      return()
    else if (heatRun_tao_w_() == "YES") {
      input$tao_w
    } else if (heatRun_tao_w_() == "NO"){
      sql <- "SELECT [TAO_W]
              FROM [RTTR_Dev].[dbo].[TAO_W_TABLE5] A
              INNER JOIN [RTTR_Dev].[dbo].[TRANSFORMER_RULES] B
              ON A.TREATMENT = B.TREATMENT AND B.TRANSFORMER_NAME_FK = ?id1 AND B.STAGE = ?id2 AND B.FLAG = 'Y';"
      
      query <- sqlInterpolate(conn, sql, 
                              id1 = TName_(),
                              id2 = cooling_())
      
      result <- dbGetQuery(conn, query)
      
      result$TAO_W[1]
      
    }
  })

  #-----------------------------------------------------------------------
  #   2.  Send data to UI
  
  # Thermal Constants
  output$dT_hr <- renderText ({
    paste("A value of", dT_hr() %>% round(2), "has been calculated so that the  Real Time Rating matches the Manufaturers Rating, at the ambient temperature assumed by the manufacturer.") 
  })
  output$tao_w <- renderText ({
    paste("A value of ", tao_w() %>% round(2), "has been selected from Table 5 of the IEC Standard based on the current cooling stage")
  })
  
  #-----------------------------------------------------------------------
  #   3.  Return output
  
  return(list(dT_hr = dT_hr,
              tao_w = tao_w,
              heatRun_dT_hr = heatRun_dT_hr_,
              heatRun_tao_w = heatRun_tao_w_))
}



