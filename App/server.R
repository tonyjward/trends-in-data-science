# options(shiny.reactlog=TRUE) 
# options(shiny.error = browser)
# options(shiny.sanitize.errors = TRUE)

#-----------------------------------------------------------------------
#   .  Load Data

  outputData <- readRDS(file = "RData/05i_OutputData.RData")
  
  # DEBUGGING
  # outputData <- readRDS(file = "/home/rstudio/App/RData/05i_OutputData.RData")


server <- function(input, output, session) {
  
  #-----------------------------------------------------------------------
  #   0.  Create reactive elements  
  
  # Users selects number of topic sizes K
  selectedK <- callModule(topicNum, "id2a", 
                          inputData = optimalSettings)
  
  # Json required for LDAvis
  jsonviz <- reactive({
    selectedK() # we insert this to ensure reactive dependency on selectedK (shouldn't need it though?)
    outputData[[selectedK()]][[2]]
  })
  
  # Data.table containing topic propabilities
  dt <- reactive({
    force(selectedK()) # we insert this to ensure reactive dependency on selectedK (shouldn't need it though?)
    outputData[[selectedK()]][[1]]
  })
  
  # Words with highest probability for each topic
  topWords <- reactive({
    force(selectedK()) # we insert this to ensure reactive dependency on selectedK (shouldn't need it though?)
    outputData[[selectedK()]][[3]]
  })
  
  # Earth model for Permanent
  earthModels <- reactive({
    force(selectedK()) # we insert this to ensure reactive dependency on selectedK (shouldn't need it though?)
    outputData[[selectedK()]][[4]]
  })
  
  # earthModels <- outputData[["15"]][[4]]

  #-----------------------------------------------------------------------
  #   1.  Inspect Data
  
  callModule(inspectData, "id1", jobData = dt)
  

  #-----------------------------------------------------------------------
  #   2.  Topic Modelling
  
  callModule(topicViz, "id2b", json = jsonviz)
  
  callModule(topicProb, "id2c", inputData = dt)
  
  callModule(topicWords, "id2d", inputData = topWords)
  
  #-----------------------------------------------------------------------
  #   3.  Contract vs Perm
  
  callModule(tools, "id3a", inputData = dt)
  
  callModule(topics, "id3b", inputData = dt)
  
  callModule(pay, "id3c", inputData = dt)
  
  callModule(roles, "id3d", inputData = dt)
  
  callModule(lucrative, "id3e", inputData = earthModels)
  
  #-----------------------------------------------------------------------
  #   4.  Time Series
  
  callModule(timeSeries, "id4", inputData = dt)

} 



