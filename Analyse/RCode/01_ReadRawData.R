# 01_ReadRawData.R

# Purpose: Read raw data and remove duplicate job descriptions

# Jobs last on the site for 7 days - since we are scraping every night we will have duplicates
# We therefore remove all duplicates using the job description as the unique key
# This does mean that jobs advertised over many weeks, or those that get re-advertised will be removed
# This is actually what we want, since we don't want the topic modelling algorithm to identify
# this quirk and lump all of those jobs into a single topic

# Contents:
#   0. Settings
#   1. Read raw data
#   2. Save data

# ----------------------------------------------------------
# 0. Settings

job_regex = "data_scientist" # other choices  "actuary|actuarial", "data_scien|machine|artificial|statistic"

# ----------------------------------------------------------
# 1. Read raw data 

filesToRead <- list.files(path = dirScraping,
          pattern = job_regex)

pathsToRead <- file.path(dirScraping, filesToRead)

result <- lapply(pathsToRead, fread, encoding = 'UTF-8')

dt_Staging <- rbindlist(result, fill = TRUE)

dt_all <- unique(dt_Staging, by = 'skills') 

#--------------------------------------------------------------
# DONE. Save results and gc()

saveRDS(dt_all, file = file.path(dirRData, "01_dt_all.RData"))

cleanUp(functionNames)
gc()











