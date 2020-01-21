#-----------------------------------------------------------------------
#   1. Clear Workspace 

rm(list=ls())
gc()

#-----------------------------------------------------------------------
#   2. Start Logging
# https://stackoverflow.com/a/48173272/6351353

zz <- file(paste0("/home/rstudio/Analyse/Logs/",format(Sys.time(), "%Y-%m-%d"),"_analyse.txt"), open = "wt")
sink(zz , append = TRUE, type = "output")
sink(zz, append = TRUE, type = "message")
sessionInfo()

#-----------------------------------------------------------------------
#   3. Run Scripts

path <- "/home/rstudio/Analyse/RCode/"

codes <- c("00_LibrariesAndPackages.R",
           "01_ReadRawData.R",
           "02_ManipulateData.R",
           "03_DocumentTermMatrix.R",
           "04_HyperparameterTuning.R",
           "05_FinalModelTraining.R",
           "06_SalaryPrediction.R",
           "07_Visualisation.R")

runCode <- function(path, codeName){
  print(codeName)
  source(file.path(path, codeName))
}

sapply(codes, runCode, path = path)

#-----------------------------------------------------------------------
#   4. Stop  Logging
sink()

           
         
