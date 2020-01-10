# 01_ReadRawData.R
# Author: Tony Ward
# Date:  

# Purpose: Read raw data *only*.  No other data manipulation.

# ----------------------------------------------------------
# 1. Read raw data 

# identify files

# search_for = "data_scien|machine|artificial|statistic"

# search_for = "actuary|actuarial"
search_for = "data_scientist"

filesToRead <- list.files(path = dirScraping,
          pattern = search_for)

pathsToRead <- file.path(dirScraping, filesToRead)

result <- lapply(pathsToRead, fread)

dt_Staging <- rbindlist(result, fill = TRUE)

# only keep unique job descriptions
# otherwise if we have multiple entries of the same job description, topic
# modelling try and fit a topic to a specific job. Instead we would rather
# the topic modelling identify general trends
dt_all <- unique(dt_Staging, by = 'skills') 

dt_all <- dt_all[1:500]

#--------------------------------------------------------------
# DONE. Save results and gc()

saveRDS(dt_all, file = file.path(dirRData, "01_dt_all.RData"))

cleanUp(functionNames)
gc()











