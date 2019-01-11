# 00_LibrariesAndPackages.R
# Author: Alan Chalk / Tony Ward
# Date: 17 January 2017

# Purpose: Clear environments.  Set directory strings for later use.  
#          Install and / or load libraries

# Contents:
#   1. Clear workspace
#   2. Define directories
#   3. Installs and Loads Standard Packages
#   4. Installs and Loads Packages from specific repos
#   5. Save session info and garbage collect

# Notes:
#   1. This is TEMPLATE code.  However we do not expect any changes or choices to be made
#      other than the package to be loaded      


#-----------------------------------------------------------------------
#   1.  Clear all working variables and most packages
#       From http://stackoverflow.com/questions/7505547/detach-all-packages-while-working-in-r

pkgs = names(sessionInfo()$otherPkgs)
if (!is.null(pkgs)){
  pkgs = paste('package:', pkgs, sep = "")
  lapply(pkgs, detach, character.only = TRUE, unload = TRUE, force = TRUE)
}
rm(list = ls(all = TRUE))

#-----------------------------------------------------------------------
#   2.  Define directories


  
dirRoot <- "/home/rstudio"

dirRData   <- file.path(dirRoot, 'RData') 
dirROutput <- file.path(dirRoot, 'ROutput')
dirRCode   <- file.path(dirRoot, 'RCode')

rm(dirRootData, dirRootCode)

#-----------------------------------------------------------------------
#   3. LOAD PACKAGES
#   If needed install packages first
# http://stackoverflow.com/questions/9341635/check-for-installed-packages-before-running-install-packages

pkgInstall <- function(x)
{ 
  if (!(x %in% rownames(installed.packages())))
  {
    install.packages(x,dep=TRUE)
  }
  
} 

packagesToLoad <- c(
  # DATA MANIPULATION
  # "readxl",
  "data.table",
  'plyr', 
  'dplyr', 
  'reshape2',
  #'Matrix',
  #'MatrixModels', 
  #'SparseM',
  #"tidyr",
  'slam',
  'zoo',
  'glue',
  
  # VISUALISATION AND EDA
  'ggplot2' ,
  # 'RColorBrewer',
  # 'corrplot',
  # 'e1071',
  
  # LEARNING STRUCTURE
  # "caret",
  
  # UNIVARIATE SCREENING
  # "Information",
  
  # SUPERVISED LEARNING
  # "rpart", 
  # "rpart.plot",
  # "glmnet",
  "earth",
  # "ranger",
  
  # PERFORMANCE MEASUREMENT
  # "ROCR",
  
  # PARALLEL PROCESSING
  'parallel',
  'doSNOW',
  
  
  #'doParallel',
  
  # OTHER
  #'testthat',
  
  # TEXT ANALYTICS
  'tm', # Framework for text mining.
  # 'SnowballC', # Provides wordStem(', for stemming.
  'topicmodels',
  'jsonlite',
  # 'wordcloud',
  #'ldatuning',
  'LDAvis',
  'servr',
  # 'lda',
  "tidytext"
  
  # WEB SCRAPING
  # 'RSelenium',
  # 'rvest'
  
  # OPTIMISATION
  #'NMOF'
  
)

# Installs packages if they are not installed
sapply(packagesToLoad, pkgInstall)

# Loads packages
sapply(packagesToLoad, require, character.only = TRUE, quietly = TRUE,
       warn.conflicts = FALSE)

# 4. Special Packages
# special treatment for drat, Xgboost, since these are installed from a different repos

# sapply("drat", pkgInstall)
# drat:::addRepo("dmlc")
# 
# if (!("xgboost" %in% rownames(installed.packages())))
# {
#   install.packages("xgboost", repos="http://dmlc.ml/drat/", type = "source")
# }

#-----------------------------------------------------------------------
#   5. Load Functions

# identify all scripts containing functions stored in code directory
functionNames <- list.files(dirRCode,
                            pattern = "^fn")
functionPaths <- paste(dirRCode, functionNames, sep = "/")
# 
# # source functions
sapply(functionPaths, source)
#-----------------------------------------------------------------------
#   6. Save session information

# Set time zone
Sys.setenv(TZ = "Europe/London")
Sys.getenv("TZ")

fileOut <- paste(c('Rsession_', format(Sys.time(), "%d%b%Y"), '.txt'), sep="", collapse="")
sink(file = file.path(dirROutput, fileOut))
sessionInfo()
sink()

rm(fileOut, pkgInstall, packagesToLoad, functionPaths)

gc()