#-----------------------------------------------------------------------
#   1. Libraries

source("/home/rstudio/RCode/topicModelling/00_LibrariesAndPackages.R")

#-----------------------------------------------------------------------
#   2. Web Scrape Jobs from Jobserve

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

#-----------------------------------------------------------------------
#   3. Process Data (topic modelling)

source("/home/rstudio/RCode/topicModelling/01_ReadRawData.R")
source("/home/rstudio/RCode/topicModelling/02a_ManipulateData.R")
source("/home/rstudio/RCode/topicModelling/05a DocumentTermMatrix.R")
source("/home/rstudio/RCode/topicModelling/05f Tuning Hyperparameters using perplexity.R")
source("/home/rstudio/RCode/topicModelling/05g Fitting Models with Optimal Settings.R")
source("/home/rstudio/RCode/topicModelling/05i Visualisation.R")
