# 08_Shiny_TimeSeries.R

# Purpose: 

#---------------------------------------------------------------------
#   1. Load data required

load(file = file.path(dirRData,'03_dt_all.RData'))

#---------------------------------------------------------------------
#   2. Aggregate Data

month <- dt_all[PostedDate > "2019-01-01",.N, .(month)]
month_job_type <- dt_all[PostedDate > "2019-01-01",.N, .(month, job_type)]
month_tools <- dt_all[PostedDate > "2019-01-01",.N, .(month, Tools)]

#---------------------------------------------------------------------
#   3. Save for use in shiny app

saveRDS(month,
        file = file.path(dirShiny, '08_month.RData'))

saveRDS(month_job_type,
        file = file.path(dirShiny, '08_month_job_type.RData'))

saveRDS(month_tools,
        file = file.path(dirShiny, '08_month_tools.RData'))

cleanUp(functionNames)
gc()





