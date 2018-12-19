cleanUp <- function(functionNames){
  
  # define objects to be removed
  allObjects <- ls(envir = .GlobalEnv)
  pathObjects <- c("dirRawData", "dirRCode", "dirRData", "dirROutput", "functionNames")
  functionObjects <- gsub("fn_|.R", "", functionNames)
  removeObjects <- setdiff(allObjects, c(pathObjects, functionObjects))
  
  # removes objects from global environment
  rm(list = removeObjects, envir = .GlobalEnv)
  
  # provides message
  return(glue::collapse(c("The following objects have been removed from the global environment", removeObjects), sep = " "))
}