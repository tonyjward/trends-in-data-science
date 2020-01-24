#-----------------------------------------------------------------------
#   1. Clear Workspace 

rm(list=ls())
gc()

#-----------------------------------------------------------------------
#   2.  Define file paths for directories
# On windows we use the getwd() since we are using an R project.
# On linux we specify a path on the host.

if (.Platform$OS.type == "windows") {
  dirRoot <- getwd() 
} else { 
  dirRoot <- "/home/rstudio"
}

dirRData        <- file.path(dirRoot, 'Analyse', 'RData') 
dirROutput      <- file.path(dirRoot, 'Analyse', 'ROutput')
dirRCode        <- file.path(dirRoot, 'Analyse', 'RCode')
dirLogs         <- file.path(dirRoot, 'Analyse', 'Logs')
dirScraping     <- file.path(dirRoot, 'Scraping', 'ROutput')
dirScrapingLogs <- file.path(dirRoot, 'Scraping', 'Logs')
dirShiny        <- file.path(dirRoot, 'Shiny', 'RData')

#-----------------------------------------------------------------------
#   2. Start Logging
# https://stackoverflow.com/a/48173272/6351353
# On the linux server we want all R logs saved to file, so we can inspect what happened in the event of a failur
# On the development windows machine we are happy for the logs to be displayed in the IDE

if (.Platform$OS.type == "unix") {
  zz <- file(file.path(dirLogs,paste0(format(Sys.time(), "%Y-%m-%d"),"_analyse.txt")), open = "wt")
  sink(zz , append = TRUE, type = "output")
  sink(zz, append = TRUE, type = "message")
  sessionInfo()
} 

#-----------------------------------------------------------------------
#   3. Run Scripts

codes <- c("00_LibrariesAndPackages.R",
           "01_ReadRawData.R",
           "02_ManipulateData.R",
           "03_DocumentTermMatrix.R",
           "04_HyperparameterTuning.R",
           "05_FinalModelTraining.R",
           "06_Shiny_InspectData.R",
           "07_Shiny_TopicModelling.R")
           #06 is placeholder for glmnet
           #"07_Visualisation.R",
           #"08_TimeSeries.R")

runCode <- function(path, codeName){
  print(codeName)
  source(file.path(path, codeName))
}

sapply(codes, runCode, path = dirRCode)

#-----------------------------------------------------------------------
#   4. Stop  Logging

if (.Platform$OS.type == "unix") {
  sink()
} 


           
         
