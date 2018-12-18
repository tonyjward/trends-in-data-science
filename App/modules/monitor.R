monitor <- function(input,
                    output,
                    session, 
                    deployClick,
                    loadDataClick,
                    substation,
                    transformer,
                    loadedTransformerName,
                    loadedData,
                    plotVars){
  
  #-----------------------------------------------------------------------
  #   0.  Update date ranges
  
  ## Update date range min/max based on selected transformer
  observe({ 
    
    loadDataClick() # required so that each time we load data we update report date min/max
    
    updateDateRangeInput(session,
                         inputId = "daterange",
                         min    = min(loadedData()$time)%>% format("%Y-%m-%d"),
                         max    = max(loadedData()$time) %>% format("%Y-%m-%d"),
                         # https://stackoverflow.com/questions/11922181/adding-time-to-posixct-object-in-r
                         start  = (max(loadedData()$time) - 3600 * 24 * 30) %>% format("%Y-%m-%d"), 
                         end    = max(loadedData()$time) %>% format("%Y-%m-%d")) 
  })
  
  #-----------------------------------------------------------------------
  #   2.  Load Thermal Constants for currently loaded transformer
  
  constants <- reactive({
    
    # Ensure table refreshes each time someone loads a new set of data
    loadDataClick() 
    
    # Ensure table refreshes each time someone deploys a new set of thermal constants
    deployClick()
    
    sql <- "SELECT CAST(STAGE as FLOAT) AS STAGE
                    ,CAST([X] AS FLOAT) AS X
                    ,CAST([T_O] AS FLOAT) AS T_O
                    ,CAST([R] AS FLOAT) AS R
                    ,CAST([DT_OR] AS FLOAT) AS DT_OR
                    ,[MODIFIED_USER]
                    ,[START_DATE]
                    ,[TRAINING_START]
                    ,[TRAINING_END]
            FROM [RTTR_Dev].[dbo].[THERMAL_CONSTANTS]
            WHERE TRANSFORMER_NAME_FK = ?id1 AND INDICATOR = 'Y'
            ORDER BY STAGE;"
    
    query <- sqlInterpolate(conn, sql, id1 = loadedTransformerName()) # prevents sql injection attacks
    
    constants <- dbGetQuery(conn, query) %>% as.data.table()
    
    # Make names nice
    setnames(constants,
             old = c(
               "START_DATE", 
               "TRAINING_START", 
               "TRAINING_END", 
               "MODIFIED_USER",
               "STAGE"),
             new = c( "Deployment Date Start", 
                      "Training Data Start", 
                      "Training Data End", 
                      'Modified User',
                      "Cooling Stage"))
    
    # Required so that we can join to loaded Data 
    setkey(constants, 'Cooling Stage')
    
    constants
  }) 
  
  #-----------------------------------------------------------------------
  #   2.  Plot Actual vs Predicted
  
  monitorData <- reactive({
    loadedData() %>% filter(dplyr::between(time,
                                           left = as.POSIXct(input$daterange[1]),
                                           right = as.POSIXct(input$daterange[2]))) %>%
      left_join(constants(), by = 'Cooling Stage') %>%
      mutate(predicted =IEC_monitor(T_o1     = .$`Tank Top Oil Temperature`[1],
                                    Amb_temp = .$`Ambient Temperature`,
                                    K2       = .$K2,
                                    Dt       = .$dT,
                                    k_11     = .$K_11,
                                    tao_o    = .$T_O,
                                    dT_or    = .$DT_OR,
                                    R        = .$R,
                                    x        = .$X),
             actual = .$`Tank Top Oil Temperature`) %>%
      melt(id.vars = c("time", "Cooling Stage"), measure.vars = c(plotVars, "actual", "predicted")) 
  })
  
  output$validationTimeSeries <- renderPlot({

      ggplot(data = monitorData() %>% filter(variable %in% c("actual","predicted")),
             aes(x = time, y = value, group = variable, colour = variable)) + geom_line() + theme(legend.position="top",
                                                                                                  legend.text = element_text(size = 16))
  }
  )
  
  #-----------------------------------------------------------------------
  #   2.  Plot other variables
  #   This requires a nested call to the report module
  
  monitorDataOriginalVars <- reactive({
    monitorData() %>% filter(!variable %in% c("actual","predicted"))
  })
  
  callModule(reports, "monitorPlot", plotData = monitorDataOriginalVars)
  
  #-----------------------------------------------------------------------
  #   4.  Send data to UI
  
  # Details of active transformer
  output$activeSubstation <- renderText({
    paste("Substation:", substation()) 
  })
  output$activeTransformer<- renderText({
    paste("Transformer:", transformer()) 
  })

  # Thermal Constants of active transformer
  # https://stackoverflow.com/questions/51730816/remove-showing-1-to-n-of-n-entries-shiny-dt
  output$tbl <- DT::renderDataTable({
    datatable(constants(),
              rownames = FALSE,
              options = list(dom = 't')) %>% # 
      formatRound(c("X", "T_O", "R", "DT_OR"), 2) %>%
      formatDate(c("Deployment Date Start"), method = "toUTCString", params = NULL) %>%
      formatDate(c("Training Data Start", 
                   "Training Data End" ), method = "toDateString", params = NULL) %>%
      formatStyle(columns = "Cooling Stage", 'text-align' = 'center')
  })
  
}


