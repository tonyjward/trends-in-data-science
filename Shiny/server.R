# options(shiny.reactlog=TRUE) 
# options(shiny.error = browser)
# options(shiny.sanitize.errors = TRUE)

#-----------------------------------------------------------------------
#   .  Load Data
  
  # Data
  dt <- readRDS(file = "RData/06_dt_all.RData")

  # Topic Modelling
  outputData <- readRDS(file = "RData/07_OutputData.RData")
  # 
  # # Time Series plots
  # month <- readRDS(file = 'RData/08_month.RData')
  # month_job_type <- readRDS(file = 'RData/08_month_job_type.RData')
  # month_tools <- readRDS(file = 'RData/08_month_tools.RData')
  
  # DEBUGGING
  # outputData <- readRDS(file = file.path(dirShiny, '07_OutputData.RData'))
 

server <- function(input, output, session) {
  
  #-----------------------------------------------------------------------
  #   Tab 1.  Home
  
  #-----------------------------------------------------------------------
  #   Tab 2.  Data
  
  callModule(inspectData, "id1", jobData = dt)
  
  #-----------------------------------------------------------------------
  #   Tab 3.  Topic Modelling
  
  # Users selects number of topics
  selectedK <- callModule(topicNum, "id2a",
                          inputData = optimalSettings)

  # Create reactive elements
  jsonviz <- reactive({
    outputData[[selectedK()]][['jsonviz']]
  })
  topWords <- reactive({
    outputData[[selectedK()]][['top_words']]
  })
  topicProbs <- reactive({
    outputData[[selectedK()]][['outputMolten']]
  })

  callModule(topicViz,   "id2b", json = jsonviz)
  callModule(topicProb,  "id2c", inputData = topicProbs)
  callModule(topicWords, "id2d", inputData = topWords)
  
  #-----------------------------------------------------------------------
  #   3.  Contract vs Perm

  # callModule(tools,  "id3a", inputData = dt)
  # callModule(topics, "id3b", inputData = dt)
  # callModule(pay,    "id3c", inputData = dt)
  # callModule(roles,  "id3d", inputData = dt)

  # #-----------------------------------------------------------------------
  # #   4.  Time Series
  # 
  # callModule(timeSeriesOverall, "id4a", inputData = month)
  # 
  # callModule(timeSeriesJob, "id4b", inputData = month_job_type)
  # 
  # callModule(timeSeriesTools, "id4c", inputData = month_tools)
} 



