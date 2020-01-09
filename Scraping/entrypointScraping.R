
#-----------------------------------------------------------------------
#   1. Clear Workspace 

rm(list=ls())
gc()

#-----------------------------------------------------------------------
#   2. Start Logging

# https://stackoverflow.com/a/48173272/6351353

zz <- file(paste0("/home/rstudio/Scraping/Logs/",format(Sys.time(), "%Y-%m-%d"),"_scraping.txt"), open = "wt")
sink(zz , append = TRUE, type = "output")
sink(zz, append = TRUE, type = "message")
sessionInfo()

#-----------------------------------------------------------------------
#   3. Load Libraries

library(RSelenium)	
library(rvest)	
library(dplyr)	
library(data.table)

#-----------------------------------------------------------------------
#   4. Web Scrape Jobs from Jobserve

source('/home/rstudio/Scraping/fn_webscrape.R')

searchTerms <- c('"data scientist"',
                  '"data science"',
                  '"machine learning"',
                  '"artificial intelligence"',
                  'statistician OR statistics',
                  'actuary OR actuarial',
                  'physiotherapist')

# searchTerms <- 'teacher'

# Wait until selenium server is ready
# This is a hack - could do it properly https://docs.docker.com/compose/startup-order/
Sys.sleep(15)

sapply(searchTerms, fn_webScrape)

#-----------------------------------------------------------------------
#   5. Stop  Logging
sink()
