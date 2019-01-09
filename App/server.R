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
  selectedK <- callModule(topicNum, "id2d", 
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
  
  #-----------------------------------------------------------------------
  #   2.  Load Data
  
  callModule(loadData, "id1", jobData = dt)
  

  #-----------------------------------------------------------------------
  #   3.  LDA Vis
  
  callModule(topicViz, "id2a", json = jsonviz)
  
  callModule(topicProb, "id2b", inputData = dt)
  
  callModule(topicWords, "id2c", inputData = topWords)
  
  #-----------------------------------------------------------------------
  #   4.  Contract vs Perm
  
  callModule(tools, "id4a", inputData = dt)
  
  callModule(topics, "id4b", inputData = dt)
  
  callModule(pay, "id4c", inputData = dt)
  
  callModule(roles, "id4d", inputData = dt)
  
  #-----------------------------------------------------------------------
  #   5.  Tools
  
  callModule(timeSeries, "id5", inputData = dt)

} 



