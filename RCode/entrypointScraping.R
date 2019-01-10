
#-----------------------------------------------------------------------
#   1. Web Scrape Jobs from Jobserve

rm(list=ls())
gc()

library(RSelenium)	
library(rvest)	
library(dplyr)	
library(data.table)

source('/home/rstudio/RCode/fn_webscrape.R')

searchTerms <- c('"data scientist"',
                 '"digital project manager"',
                 '"data science"',
                 '"machine learning"',
                 '"artificial intelligence"',
                 'statistician OR statistics',
                 'actuary OR actuarial',
                 'physiotherapist',
                 'teacher',
                 '"c developer"')

sapply(searchTerms, fn_webScrape)
