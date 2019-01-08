# MARS

outputData <- readRDS(file = "App/RData/05i_OutputData.RData")
optimalSettings <- readRDS(file = "App/RData/05f_optimalSettings.RData")
optimalK <- readRDS(file = "App/RData/05f_optimalK.RData")  %>% as.character()

dt <- outputData[[optimalK]][[1]]
jsonviz <- outputData[[optimalK]][[2]]
topWords <- outputData[[optimalK]][[3]]


library(earth)

topicFormula <- paste0( "salaryMax ~ ", grep("Topic", colnames(dt), value = TRUE) %>% glue_collapse(sep = " + "))


earthModel <- earth(topicFormula %>% as.formula(),
                      data = dt[!is.na(salaryMax) & job_type == "Permanent"],
                      degree = 1,
                      trace = 2,
                      nfold = 5)

summary(earthModel)

plotmo(earthModel)


earthModel <- earth(topicFormula %>% as.formula(),
                    data = dt[!is.na(salaryMax) & job_type == "Contract"],
                    degree = 1,
                    trace = 2,
                    nfold = 5)

summary(earthModel)

plotmo(earthModel)