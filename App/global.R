library(shiny)
library(reshape2)
library(dplyr)
library(data.table)
library(ggplot2)
library(DT)
library(LDAvis)
library(earth)

# run all Modules
sapply( list.files("modules", full.names=TRUE), source )

# run all functions
# sapply( list.files("functions", full.names=TRUE), source )


optimalSettings <- readRDS(file = "RData/04_optimalSettings.RData")
optimalK <- readRDS(file = "RData/04_optimalK.RData")  %>% as.character() 

# DEBUGGING
# optimalSettings <- readRDS(file = "/home/rstudio/App/RData/05f_optimalSettings.RData")
# optimalK <- readRDS(file = "/home/rstudio/App/RData/05f_optimalK.RData")  %>% as.character()



