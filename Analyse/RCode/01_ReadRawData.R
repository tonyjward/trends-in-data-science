# 01_ReadRawData.R
# Author: Tony Ward
# Date:  

# Purpose: Read raw data *only*.  No other data manipulation.

# ----------------------------------------------------------
# 1. Read raw data 

# identify files

# search_for = "data_scien|machine|artificial|statistic"

search_for = "data_scientist"

filesToRead <- list.files(path = "/home/rstudio/ROutput",
          pattern = search_for)

pathsToRead <- paste0('/home/rstudio/ROutput/',filesToRead)

result <- lapply(pathsToRead, fread)

dt_Staging <- rbindlist(result, fill = TRUE)

# only keep unique job descriptions
# otherwise if we have multiple entries of the same job description, topic
# modelling try and fit a topic to a specific job. Instead we would rather
# the topic modelling identify general trends
dt_all <- unique(dt_Staging, by = 'skills') 

#--------------------------------------------------------------
# DONE. Save results and gc()

saveRDS(dt_all, file = "/home/rstudio/RData/01_dt_all.RData")

cleanUp(functionNames)
gc()











