# 01_ReadRawData.R
# Author: Tony Ward
# Date:  

# Purpose: Read raw data *only*.  No other data manipulation.

# ----------------------------------------------------------
# 1. Read raw data 

# identify files

filesToRead <- list.files(path = "/home/rstudio/ROutput",
          pattern = "data_scientist")

pathsToRead <- paste0('/home/rstudio/ROutput/',filesToRead)

result <- lapply(pathsToRead, fread)

dt_Staging <- rbindlist(result, fill = TRUE)

dt_all <- unique(dt_Staging, by = setdiff(colnames(dt_Staging),
                                           c("last_view", "posted_date","permalink")))

#--------------------------------------------------------------
# DONE. Save results and gc()

saveRDS(dt_all, file = "/home/rstudio/RData/01_dt_all.RData")

cleanUp(functionNames)
gc()











