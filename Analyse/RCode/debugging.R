
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


# london charts
dt<- readRDS(file = file.path(dirShiny, '06_dt_all.RData'))

  
# overall jobs
plotData <- dt[,.N, .(job_type,London)]
ggplot(data = plotData[job_type == "Contract"],
       aes(x = London, y = N))  + geom_bar(stat = "identity") + labs(y = "Job Count")

ggplot(data = dt[job_type == "Permanent"], aes(x = London, y = salaryMax, fill = London)) + geom_boxplot() +
  scale_y_continuous(limits = c(0, NA),
                     breaks = scales::pretty_breaks(n = 10)) 





