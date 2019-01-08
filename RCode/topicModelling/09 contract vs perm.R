# Difference between contract & perm

cleanUp(functionNames)

outputData <- readRDS(file = "RData/05i_OutputData.RData")
optimalSettings <- readRDS(file = "RData/05f_optimalSettings.RData")
optimalK <- readRDS(file = "RData/05f_optimalK.RData")  %>% as.character()

dt <- outputData[[optimalK]][[1]]
jsonviz <- outputData[[optimalK]][[2]]
topWords <- outputData[[optimalK]][[3]]

#-----------------------------------------------------------------------
#   1.  Topics

topicNames <- grep("Topic", colnames(dt), value = TRUE)

newNames <- paste0(topWords$topWords," (", topicNames, ")")

setnames(dt,
         old = topicNames,
         new = newNames)

moltenData <- melt(data = dt,
                   id.vars = "job_type",
                   measure.vars = newNames)

ggplot(data = moltenData,
       aes(x = variable , y = value, fill = job_type)) + geom_bar(stat = "identity") + coord_flip() + labs(x = "Topic", y = "Sum of Topic Probabilities")

#-----------------------------------------------------------------------
#   2.  Tools

colnames(dt)

dt[, Tools := ifelse(Python_R == "TRUE_TRUE", "Python or R",
                     ifelse(Python_R == "TRUE_FALSE", "Python but not R",
                            ifelse(Python_R == "FALSE_TRUE", "R but not Python","Neither Language")))]

table(dt$Tools, dt$Python_R)

plotData <- dt[,.N, .(Tools, job_type)]

ggplot(data = plotData,
       aes(x = Tools, y = N, fill = job_type))  + geom_bar(stat = "identity") + coord_flip() + labs(y = "Job Count")
