
# Data
dt <- readRDS(file = "RData/06_dt_all.RData")

# Topic Modelling
outputData <- readRDS(file = "RData/07_OutputData.RData")

# Time Series plots
month <- readRDS(file = 'RData/08_month.RData')
month_job_type <- readRDS(file = 'RData/08_month_job_type.RData')
month_tools <- readRDS(file = 'RData/08_month_tools.RData')

# DEBUGGING
dt<- readRDS(file = file.path(dirShiny, '06_dt_all.RData'))


outputData <- readRDS(file = file.path(dirShiny, '07_OutputData.RData'))
