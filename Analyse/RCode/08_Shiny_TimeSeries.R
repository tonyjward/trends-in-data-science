# 08_Shiny_TimeSeries.R

# Purpose: Prototype glmnet model

# Contents:
#   1. Define Macro Variables


#---------------------------------------------------------------------
#   _. Load data required

load(file = file.path(dirRData,'03_dt_all.RData'))

#---------------------------------------------------------------------
#   1. Aggregate Data

month <- dt_all[`Posted Date` > "2019-01-01",.N, .(month)]
month_job_type <- dt_all[`Posted Date` > "2019-01-01",.N, .(month, job_type)]
month_tools <- dt_all[`Posted Date` > "2019-01-01",.N, .(month, Tools)]

#---------------------------------------------------------------------
#   2. Save for use in shiny app

saveRDS(month,
        file = file.path(dirShiny, '08_month.RData'))

saveRDS(month_job_type,
        file = file.path(dirShiny, '08_month_job_type.RData'))

saveRDS(month_tools,
        file = file.path(dirShiny, '08_month_tools.RData'))

cleanUp(functionNames)
gc()





