# options(shiny.reactlog=TRUE) 
# options(shiny.error = browser)
# options(shiny.sanitize.errors = TRUE)

#-----------------------------------------------------------------------
#   .  Load Data
  
  # Data
  dt <- readRDS(file = "RData/06_dt_all.RData")

  # Topic Modelling
  # outputData <- readRDS(file = "RData/07_OutputData.RData")
  # 
  # # Time Series plots
  # month <- readRDS(file = 'RData/08_month.RData')
  # month_job_type <- readRDS(file = 'RData/08_month_job_type.RData')
  # month_tools <- readRDS(file = 'RData/08_month_tools.RData')
  
  # DEBUGGING
  # outputData <- readRDS(file = file.path(dirShiny, '07_OutputData.RData'))
 

server <- function(input, output, session) {
  
  #-----------------------------------------------------------------------
  #   1.  Home
  
  #-----------------------------------------------------------------------
  #   2.  Data
  
  callModule(inspectData, "id1", jobData = dt)
  
  #-----------------------------------------------------------------------
  #   0.  Create reactive elements  
  
  # Users selects number of topic sizes K
  # selectedK <- callModule(topicNum, "id2a", 
  #                         inputData = optimalSettings)
  
  # dt <- reactive({
  #   #selectedK() # we insert this to ensure reactive dependency on selectedK (shouldn't need it though?)
  #   dt_all
  # })
  
  # # Json required for LDAvis
  # jsonviz <- reactive({
  #   selectedK() # we insert this to ensure reactive dependency on selectedK (shouldn't need it though?)
  #   outputData[[selectedK()]][['jsonviz']]
  # })
  # 
  # # Words with highest probability for each topic
  # topWords <- reactive({
  #   force(selectedK()) # we insert this to ensure reactive dependency on selectedK (shouldn't need it though?)
  #   outputData[[selectedK()]][['top_words']]
  # })
  # 
  # # Topic Probabilities in long format
  # topicProbs <- reactive({
  #   force(selectedK()) # we insert this to ensure reactive dependency on selectedK (shouldn't need it though?)
  #   outputData[[selectedK()]][['outputMolten']]
  # })
  # 


  

  #-----------------------------------------------------------------------
  #   2.  Topic Modelling
  
  # callModule(topicViz, "id2b", json = jsonviz)
  # 
  # callModule(topicProb, "id2c", inputData = topicProbs)
  # 
  # callModule(topicWords, "id2d", inputData = topWords)
  # 
  # #-----------------------------------------------------------------------
  # #   3.  Contract vs Perm
  # 
  # callModule(tools, "id3a", inputData = dt)
  # 
  # callModule(topics, "id3b", inputData = dt)
  # 
  # callModule(pay, "id3c", inputData = dt)
  # 
  # callModule(roles, "id3d", inputData = dt)
  # 
  # #-----------------------------------------------------------------------
  # #   4.  Time Series
  # 
  # callModule(timeSeriesOverall, "id4a", inputData = month)
  # 
  # callModule(timeSeriesJob, "id4b", inputData = month_job_type)
  # 
  # callModule(timeSeriesTools, "id4c", inputData = month_tools)
} 



