# 99a_DocumentTermMatrix.R

# Purpose: Prototype glmnet model

# Contents:
#   1. Define Macro Variables



# TODO - IF THERE ARE NO DOCUS REMOVED THEN THE SAVE DOESN'T WORK
#---------------------------------------------------------------------
#   _. Load data required

load(file = file.path(dirRData,'03_dt_all.RData'))

#---------------------------------------------------------------------
#   1. Aggregate Data


# aggregated data for time series plots
month <- dt_all[`Posted Date` > "2019-01-01",.N, .(month)]
month_job_type <- dt_all[`Posted Date` > "2019-01-01",.N, .(month, job_type)]
month_job_type_tools <- dt_all[`Posted Date` > "2019-01-01",.N, .(month, job_type, Tools)]

#---------------------------------------------------------------------
#   2. Save for use in shiny app

saveRDS(month,
        file = file.path(dirShiny, '08_month.RData'))

saveRDS(month_job_type,
        file = file.path(dirShiny, '08_month_job_type.RData'))

saveRDS(month_job_type_tools,
        file = file.path(dirShiny, '08_month_job_type_tools.RData'))

cleanUp(functionNames)
gc()





