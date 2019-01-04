# 01_ReadRawData.R
# Author: Tony Ward
# Date:  

# Purpose: Read raw data *only*.  No other data manipulation.



# ----------------------------------------------------------
# 1. Read raw data 

# identify files

filesToRead <- list.files(path = paste0(getwd(),"/ROutput"),
          pattern = "data_scientist")

pathsToRead <- paste0('ROutput/',filesToRead)

result <- lapply(pathsToRead, fread)

dt_Staging <- rbindlist(result, fill = TRUE)

dt_all <- unique(dt_Staging, by = setdiff(colnames(dt_Staging),
                                           "last_view"))

#--------------------------------------------------------------
# DONE. Save results and gc()

saveRDS(dt_all, file = "RData/01_dt_all.RData")

cleanUp(functionNames)
gc()











