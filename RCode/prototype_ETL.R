library(data.table)

# identify files

filesToRead <- list.files(path = paste0(getwd(),"/ROutput"),
          pattern = "actuary_OR_actuarial")

pathsToRead <- paste0('ROutput/',filesToRead)

result <- lapply(pathsToRead, fread)

dataAll <- rbindlist(result, fill = TRUE)

dataunique <- unique(dataAll, by = setdiff(colnames(dataAll),
                                           "last_view"))



