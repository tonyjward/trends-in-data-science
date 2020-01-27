# 06_Shiny_InspectData.R

# Purpose: Provide data to be used in Shiny App (Inspect Data and Contract vs Perm tabs)


#---------------------------------------------------------------------
#   1. Load data required

load(file = file.path(dirRData,'03_dt_all.RData'))

#---------------------------------------------------------------------
#   2. Specify variables to include in Inspect Data tab

include <- c("doc_id",
             "Title",
             "job_type",
             "text",
             "Salary",
             "salaryMax",
             "Location",
             "PostedDate",
             "Tools",
             "London")

#---------------------------------------------------------------------
#   3. Save for use in shiny app

dt_all[, doc_id := as.character(doc_id)]

saveRDS(dt_all[, include, with = FALSE][order(-PostedDate)],
        file = file.path(dirShiny, '06_dt_all.RData')) 

cleanUp(functionNames)
gc()





