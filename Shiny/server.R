# options(shiny.reactlog=TRUE) 
# options(shiny.error = browser)
# options(shiny.sanitize.errors = TRUE)

#-----------------------------------------------------------------------
#   .  Load Data
  
  # Data
  dt <- readRDS(file = "RData/06_dt_all.RData")

  # Topic Modelling
  outputData <- readRDS(file = "RData/07_OutputData.RData")
   
  # Location
  job_type_Location <- dt[, .N, .(job_type,London)]
  
  # Trends
  month <- readRDS(file = 'RData/08_month.RData')
  month_job_type <- readRDS(file = 'RData/08_month_job_type.RData')
  month_tools <- readRDS(file = 'RData/08_month_tools.RData')
  
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
  callModule(topicWords, "id2c", inputData = topWords)
  callModule(topicProb,  "id2d", inputData = topicProbs)
  
  
  #-----------------------------------------------------------------------
  #   3.  Contract vs Perm

  callModule(overall,  "id3a", inputData = dt)
  callModule(pay,      "id3b", inputData = dt)
  callModule(roles,    "id3c", inputData = dt)
  
  #-----------------------------------------------------------------------
  #   4.  Location
  
  callModule(locationSplit, "id4a", inputData = dt, aggData = job_type_Location)

  #-----------------------------------------------------------------------
  #   5.  Trends

  callModule(timeSeriesOverall, "id5a", inputData = month)
  callModule(timeSeriesJob,     "id5b", inputData = month_job_type)
  callModule(timeSeriesTools,   "id5c", inputData = month_tools)
} 



