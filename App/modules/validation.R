validation <- function(input, 
                     output, 
                     session, 
                     loadedData,
                     substation,
                     transformer,
                     cooling,
                     constants,
                     loadDataClick){ 
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
                         start  = summary(loadedData()$time)[['3rd Qu.']] %>% format("%Y-%m-%d"), 
                         end    = max(loadedData()$time) %>% format("%Y-%m-%d")) 
  })
  
    
  #-----------------------------------------------------------------------
  #   1.  Filter data
  #   User selects what time period to use for model validation
  
  dtFiltered <- reactive({
    loadedData() %>% filter(dplyr::between(time,
                                   left = as.POSIXct(input$daterange[1]),
                                   right = as.POSIXct(input$daterange[2]))) 
  })
  
  #-----------------------------------------------------------------------
  #   2.  IEC Calculation
  #   Preds is a matrix with dimensions [n , length(param)]
  
  plotDataValidation <- reactive({
    tempDF <- data.frame( time = dtFiltered()$time,
                          cooling_ = dtFiltered()$'Cooling Stage',
                          actual = dtFiltered()$'Tank Top Oil Temperature',
                          predicted = IEC_train( T_o1     = dtFiltered()$'Tank Top Oil Temperature'[1],
                                                 Amb_temp = dtFiltered()$'Ambient Temperature',
                                                 K2       = dtFiltered()$K2,
                                                 Dt       = dtFiltered()$dT,
                                                 k_11     = dtFiltered()$K_11,
                                                 tao_o    = constants()$xbest[1],
                                                 dT_or    = constants()$xbest[2],
                                                 R        = constants()$xbest[3],
                                                 x        = constants()$xbest[4]
                          ))
    moltenData <- melt(tempDF, id.vars = c("time", "cooling_"), measure.vars = c("actual", "predicted"))
    
    # Only keep data where cooling stage matches models active cooling stage
    moltenData %>% filter(cooling_ == cooling())
    
  }) 
  
  #-----------------------------------------------------------------------
  #   3.  Produce plot
  
  output$validationTimeSeries <- renderPlot({
    ggplot(plotDataValidation(),
           aes(x = time, y = value, group = variable, colour = variable)) + geom_line() 
  })
  
  #-----------------------------------------------------------------------
  #   4.  Send data to UI
  
  output$activeSubstation <- renderText({
    paste("Substation:", substation())
  })
  
  output$activeTransformer <- renderText({
    paste("Transformer:", transformer())
  })
  
  output$activeCooling <- renderText({
    paste("CoolingStage:", cooling())
  }) 
  
}




