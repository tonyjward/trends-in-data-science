# 06_Shiny_InspectData.R

# Purpose: Provide data to be used in Shiny App (Inspect Data and Contract vs Perm tabs)

# Contents:
#   1. Define Macro Variables

# TODO - IF THERE ARE NO DOCUS REMOVED THEN THE SAVE DOESN'T WORK
#---------------------------------------------------------------------
#   _. Load data required

load(file = file.path(dirRData,'03_dt_all.RData'))

#---------------------------------------------------------------------
#   1. Specify variables to include in Inspect Data tab

include <- c("doc_id",
             "Title",
             "job_type",
             "text",
             "Salary",
             "salaryMax",
             "Location",
             "Posted Date")

#---------------------------------------------------------------------
#   2. Save for use in shiny app

saveRDS(dt_all[, include, with = FALSE][order(-`Posted Date`)],
        file = file.path(dirShiny, '06_dt_all.RData')) 

cleanUp(functionNames)
gc()





