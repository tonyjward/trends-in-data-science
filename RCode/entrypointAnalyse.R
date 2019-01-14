#-----------------------------------------------------------------------
#   1. Clear Workspace 

rm(list=ls())
gc()


#-----------------------------------------------------------------------
#   2. Start Logging

# https://stackoverflow.com/a/48173272/6351353

zz <- file(paste0("/home/rstudio/Logs/log_",format(Sys.time(), "%d%b%Y"),".txt"), open = "wt")
sink(zz , append = TRUE, type = "output")
sink(zz, append = TRUE, type = "message")

#-----------------------------------------------------------------------
#   3. Run Scripts

path <- "/home/rstudio/RCode/topicModelling"

codes <- c("00_LibrariesAndPackages.R",
           "01_ReadRawData.R",
           "02a_ManipulateData.R",
           "05a DocumentTermMatrix.R",
           "05f Tuning Hyperparameters using perplexity.R",
           "05g Fitting Models with Optimal Settings.R",
           "05i Visualisation.R")

runCode <- function(path, codeName){
  print(codeName)
  source(file.path(path, codeName))
}

sapply(codes, runCode, path = path)

#-----------------------------------------------------------------------
#   4. Stop  Logging
sink()

           
         