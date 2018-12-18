training <- function(input, 
                     output, 
                     session, 
                     loadedData,
                     loadedDno,
                     loadedSubstation,
                     loadedTransformer,
                     loadedTransformerName,
                     loadDataClick){
  
  
  #-----------------------------------------------------------------------
  #   0.  Update date ranges
  
  ## Update date range min/max based on selected transformer
  observe({
    
    loadDataClick() # required so that each time we load data we update report date min/max
    
    updateDateRangeInput(session,
                         inputId = "daterangeTraining",
                         min    = min(loadedData()$time)%>% format("%Y-%m-%d"),
                         max    = max(loadedData()$time) %>% format("%Y-%m-%d"),
                         # https://stackoverflow.com/questions/11922181/adding-time-to-posixct-object-in-r
                         start  = min(loadedData()$time) %>% format("%Y-%m-%d"), 
                         end    = summary(loadedData()$time)[['3rd Qu.']] %>% format("%Y-%m-%d")) 
  })
  

  #-----------------------------------------------------------------------
  #   1.  Filter data
  
  # User selects what time period to use for model training
  loadedDataFiltered <- reactive({
    loadedData() %>% filter(dplyr::between(time,
                                   left = as.POSIXct(input$daterangeTraining[1]),
                                   right = as.POSIXct(input$daterangeTraining[2])))
  })
  
  #-----------------------------------------------------------------------
  #   2.  Assess quality of data
  

  QUALITY_AMBIENT_TEMPERATURE <- reactive({loadedDataFiltered()$'Bad Data: Ambient Temperature' %>% mean()})
  QUALITY_TANK_TOP_OIL_TEMPERATURE <- reactive({loadedDataFiltered()$'Bad Data: Tank Top Oil Temperature' %>% mean()})
  QUALITY_LV_AMPS <- reactive({loadedDataFiltered()$'Bad Data: LV Amps' %>% mean()})
  QUALITY_COOLINGSTAGENUM <- reactive({loadedDataFiltered()$'Bad Data: Cooling Stage' %>% mean()})
  
  #-----------------------------------------------------------------------
  #   2.  Update cooling stage input
  
  # User should only be able to select cooling stages that exist in the selected time period
  loadedDataUniqueCooling <- reactive({
    
    loadedDataFiltered()$'Cooling Stage' %>% unique() %>% sort()
  })
  
  observe({
    
    input$daterangeTraining # to ensure available training states updates when training dates change
    
    updateRadioButtons(session,
                       "selectedCooling",
                       choices = loadedDataUniqueCooling(),
                       selected = loadedDataUniqueCooling()[1])
  })
  
  #-----------------------------------------------------------------------
  #   3.  Create required data for Particle Swarm Optimisation
  
  DataTrain <- reactive({list(y                   = loadedDataFiltered()$'Tank Top Oil Temperature',
                              K2                  = loadedDataFiltered()$K2,
                              Amb_temp            = loadedDataFiltered()$'Ambient Temperature',
                              T_o1                = loadedDataFiltered()$'Tank Top Oil Temperature'[1],
                              time                = loadedDataFiltered()$time,
                              dayOfYear           = cut(loadedDataFiltered()$time,"day"),
                              COOLINGSTAGENUM     = loadedDataFiltered()$'Cooling Stage',
                              Dt                  = loadedDataFiltered()$dT,
                              k_11                = loadedDataFiltered()$K_11,
                              currentlyOptimising = as.numeric(input$selectedCooling)
                              #currentlyOptimising = 0
  )
  })
  
  popsize <- 10
  generations <- 300
  
  ps <- reactive({
    list(min = c(1,1,0.1, 0.1),
         max = c(1500,90, 40, 2),
         minmaxConstr = TRUE,
         c1 = 0.9,
         c2 = 0.9,
         iner = 0.9,
         initV = 1,
         nP = popsize,
         nG = generations,
         maxV = 5,
         loopOF = FALSE,
         printBar = TRUE,
         printDetail = FALSE,
         storeSolutions = FALSE)
  })
  
  #-----------------------------------------------------------------------
  #   4.  Run Particle Swarm based on action button
  
  solASTON <- eventReactive(input$startTraining,{
    
    # Create a Progress object
    progress <- shiny::Progress$new(session, min = 1, max = 300)
    progress$set(message = "Finding solution", value = 1)
    # Close the progress when this reactive exits (even if there's an error)
    on.exit(progress$close())
    
    # Create a callback function to update progress.
    # Each time this is called:
    # - If `value` is NULL, it will move the progress bar 1/5 of the remaining
    #   distance. If non-NULL, it will set the progress to that value.
    # - It also accepts optional detail text.
    updateProgress <- function(value = NULL, detail = NULL) {
      progress$set(value = value, detail = detail)
    }
    
    NMOF::PSopt(OF = ASTON, algo = ps(), Data = DataTrain(), updateProgress = updateProgress)
    
  })
  

  #-----------------------------------------------------------------------
  #   5.  Ensure state of key variables updates when training button clicked
  
  
  trainStart <- reactive({
    if (input$startTraining ==0)
      return()
    isolate(input$daterangeTraining[1])
  })
  
  trainEnd <- reactive({
    if (input$startTraining ==0)
      return()
    isolate(input$daterangeTraining[2])
  })
  
  modelledCooling <- reactive({
    if (input$startTraining ==0)
      return()
    isolate(input$selectedCooling)
  })
  
  modelledDno <- reactive({
    if (input$startTraining ==0)
      return()
    isolate(loadedDno())
  })
  
  modelledSubstation <- reactive({
    if (input$startTraining ==0)
      return()
    isolate(loadedSubstation())
  })
  
  modelledTransformer <- reactive({
    if (input$startTraining ==0)
      return()
    isolate(loadedTransformer())
  })
  
  modelledTransformerName <- reactive({
    if (input$startTraining ==0)
      return()
    isolate(loadedTransformerName())
  })
  
  
  #-----------------------------------------------------------------------
  #   6.  Send data to UI
  
  output$activeSubstationTrain <- renderText({
    paste("Modelled Substation:", modelledSubstation())
  })
  
  output$activeTransformerTrain <- renderText({
    paste("Modelled Transformer:", modelledTransformer())
  })
  
  output$activeCoolingStageTrain <- renderText({
    paste("Modelled CoolingStage:", modelledCooling())
  }) 
  
  output$coefficients <- renderTable({
    
    data.frame(Name = c("tao_o", "dT_or", "R", "x"),
               Value = solASTON()$xbest[1:4])

  })
  
  # Data Quality
  output$dataQuality <- renderTable({
    data.frame(Sensor = c("Ambient Temperature", "Tank Top Oil Temperature", "LV Amps", "Cooling Stage"),
               "Proportion Missing" = c(QUALITY_AMBIENT_TEMPERATURE(), QUALITY_TANK_TOP_OIL_TEMPERATURE(), QUALITY_LV_AMPS(), QUALITY_COOLINGSTAGENUM()),
               check.names = FALSE)
  })

  #-----------------------------------------------------------------------
  #   7.  Return output
  
  return(list(model                   = solASTON,
              trainStart              = trainStart,
              trainEnd                = trainEnd,
              modelledCooling         = modelledCooling,
              modelledDno             = modelledDno,
              modelledSubstation      = modelledSubstation,
              modelledTransformer     = modelledTransformer,
              modelledTransformerName = modelledTransformerName
  ))
}