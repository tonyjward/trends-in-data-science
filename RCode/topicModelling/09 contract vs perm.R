# Difference between contract & perm

cleanUp(functionNames)

outputData <- readRDS(file = "RData/05i_OutputData.RData")
optimalSettings <- readRDS(file = "RData/05f_optimalSettings.RData")
optimalK <- readRDS(file = "RData/05f_optimalK.RData")  %>% as.character()

dt <- outputData[[optimalK]][[1]]
jsonviz <- outputData[[optimalK]][[2]]
topWords <- outputData[[optimalK]][[3]]


topicNames <- grep("Topic", colnames(dt), value = TRUE)

newNames <- paste0(topWords$topWords," (", topicNames, ")")

setnames(dt,
         old = topicNames,
         new = newNames)

moltenData <- melt(data = dt,
                   id.vars = "job_type",
                   measure.vars = newNames)

ggplot(data = moltenData,
       aes(x = variable , y = value, fill = job_type)) + geom_bar(stat = "identity") + coord_flip()