library(data.table)

# identify files

filesToRead <- list.files(path = paste0(getwd(),"/ROutput"),
          pattern = "data_scientist")

pathsToRead <- paste0('ROutput/',filesToRead)

result <- lapply(pathsToRead, fread)

dt_Staging <- rbindlist(result, fill = TRUE)

dt <- unique(dt_Staging, by = setdiff(colnames(dt_Staging),
                                           "last_view"))

# clean up
dt[, rate := gsub('Â','',rate)]

saveRDS(dt, file = "App/RData/data_scientist.RData")

data_scientist <- readRDS(file = "App/RData/data_scientist.RData")




dt <- readRDS(file = "App/RData/data_scientist.RData")



