# options(shiny.reactlog=TRUE) 
# options(shiny.error = browser)
# options(shiny.sanitize.errors = TRUE)


outputData <- readRDS(file = "RData/05i_OutputData.RData")
optimalSettings <- readRDS(file = "RData/05f_optimalSettings.RData")
optimalK <- readRDS(file = "RData/05f_optimalK.RData")  %>% as.character() 

# DEBUGGING
# outputData <- readRDS(file = "/home/rstudio/App/RData/05i_OutputData.RData")
# optimalSettings <- readRDS(file = "/home/rstudio/App/RData/05f_optimalSettings.RData")
# optimalK <- readRDS(file = "/home/rstudio/App/RData/05f_optimalK.RData")  %>% as.character()

dt <- outputData[[optimalK]][[1]]
jsonviz <- outputData[[optimalK]][[2]]
topWords <- outputData[[optimalK]][[3]]

# jsonviz <- readRDS(file = "RData/jsonviz_Skills_iterations_2000_size_10.RData")

server <- function(input, output, session) {
  
  #-----------------------------------------------------------------------
  #   2.  Load Data
  
  callModule(loadData, "id1", jobData = dt)
  

  #-----------------------------------------------------------------------
  #   3.  LDA Vis
  
  callModule(topicViz, "id2a", json = jsonviz)
  
  callModule(topicProb, "id2b", inputData = dt)
  
  callModule(topicWords, "id2c", inputData = topWords)
  
  callModule(topicScree, "id2d", inputData = optimalSettings)
  
  #-----------------------------------------------------------------------
  #   4.  Contract vs Perm
  
  callModule(tools, "id4a", inputData = dt)
  
  callModule(topics, "id4b", inputData = dt)
  
  callModule(pay, "id4c", inputData = dt)
  
  
  #-----------------------------------------------------------------------
  #   5.  Tools
  
  callModule(timeSeries, "id5", jobData = dt)
  
  
  
  
  ## Update date range min/max based on selected transformer
#   observe({
#     loadDataClick() # required so that each time we load data we update report date min/max
#     
#     updateDateRangeInput(session,
#                          inputId = "daterangeReports",
#                          min    = min(loadedData()$time)%>% format("%Y-%m-%d"),
#                          max    = max(loadedData()$time) %>% format("%Y-%m-%d"),
#                          # https://stackoverflow.com/questions/11922181/adding-time-to-posixct-object-in-r
#                          start  = (max(loadedData()$time) - 3600 * 24 * 30) %>% format("%Y-%m-%d"), 
#                          end    = max(loadedData()$time %>% format("%Y-%m-%d"))) 
#   })
#   
# 
#   loadedDataMolten <- reactive({
#     melt(loadedData(), id.vars = c("time"), measure.vars = plotVars) 
#   })
#   
#   loadedDataMoltenFiltered <- reactive({
#     loadedDataMolten() %>% filter(dplyr::between(time,
#                                          left = as.POSIXct(input$daterangeReports[1]),
#                                          right = as.POSIXct(input$daterangeReports[2])
#     ))
#   })
#   
#   callModule(reports, "Top Oil", plotData = loadedDataMoltenFiltered)
# callModule(reports, "Load", plotData = loadedDataMoltenFiltered)
#   
#   #-----------------------------------------------------------------------
#   #   5.  Training
#   
#   trainingResult <- callModule(training, "id5",
#                                loadedData            = loadedData,
#                                loadedDno             = loadedDno,
#                                loadedSubstation      = loadedSubstation,
#                                loadedTransformer     = loadedTransformer,
#                                loadedTransformerName = loadedTransformerName,
#                                loadDataClick         = loadDataClick)
#   
#   trainingResult_model      <- reactive({trainingResult$model()})
#   trainingResult_trainStart <- reactive({trainingResult$trainStart()})
#   trainingResult_trainEnd   <- reactive({trainingResult$trainEnd()})
#   trainingResult_cooling    <- reactive({trainingResult$modelledCooling()}) 
#   modelledDno               <- reactive({trainingResult$modelledDno()})
#   modelledTransformerName   <- reactive({trainingResult$modelledTransformerName()}) 
#   modelledSubstation        <- reactive({trainingResult$modelledSubstation()})   
#   modelledTransformer       <- reactive({trainingResult$modelledTransformer()})   
# 
#   #-----------------------------------------------------------------------
#   #   6.  Validation
#   
#   callModule(validation, "id6",
#              loadedData    = loadedData,
#              substation    = loadedSubstation,
#              transformer   = loadedTransformer,
#              cooling       = trainingResult_cooling,
#              constants     = trainingResult_model,
#              loadDataClick = loadDataClick)
# 
#   #-----------------------------------------------------------------------
#   #   7.  Heat Run Data
#   
#   heatRunResult <- callModule(heatRun, "id7", 
#                               TName     = modelledTransformerName,
#                               cooling   = trainingResult_cooling,
#                               constants = trainingResult_model)
#   
#   dT_hr         <- reactive({heatRunResult$dT_hr()})
#   tao_w         <- reactive({heatRunResult$tao_w()})
#   heatRun_dT_hr <- reactive({heatRunResult$heatRun_dT_hr()})
#   heatRun_tao_w <- reactive({heatRunResult$heatRun_tao_w()})
#   
#   #-----------------------------------------------------------------------
#   #   8.  Deploy
#   
#   ## Only want to allow user to deploy if they have trained model and entered heat run data
#   
#   deployClick <- callModule(deploy, "id8",
#                             Dno            = modelledDno,
#                             TName          = modelledTransformerName,
#                             substation     = modelledSubstation,
#                             transformer    = modelledTransformer,
#                             Stage          = trainingResult_cooling,
#                             constants      = trainingResult_model,
#                             DT_HR          = dT_hr,
#                             T_W            = tao_w,
#                             Modified_User  = 'Tony',
#                             Training_Start = trainingResult_trainStart,
#                             Training_End   = trainingResult_trainEnd,
#                             Heat_Run_DT_HR = heatRun_dT_hr,
#                             Heat_Run_T_W   = heatRun_tao_w,
#                             currentSession = session)
#   
#   #-----------------------------------------------------------------------
#   #   9. Constants
#   
#   callModule(constantsActive, "id9a", deployClick = deployClick)
#   
#   callModule(constantsHistory, "id9b", deployClick = deployClick)
#   
#   #-----------------------------------------------------------------------
#   #   10. Monitor
#   
#   callModule(monitor, 
#              "id10", 
#              deployClick = deployClick,
#              loadDataClick = loadDataClick,
#              substation    = loadedSubstation,
#              transformer   = loadedTransformer,
#              loadedTransformerName = loadedTransformerName,
#              loadedData = loadedData,
#              plotVars = plotVars)
    
  #-----------------------------------------------------------------------
  #   4.  Test
  
  # output$summary1 <- renderText ({
  #   format(as.POSIXct(dateTrainingStart()), format = "%Y-%m-%d")
  #   #dateTrainingStart()
  # })

} 



