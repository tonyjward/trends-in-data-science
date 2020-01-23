load(file = file.path(dirRData,paste0('07_OutputData.RData')))

outputAll[, month:= as.Date(cut(`Posted Date`, breaks = "month"))]

length(outputData)



month_job_type_tools <- outputAll[`Posted Date` > "2019-01-01",.N, .(month, job_type, Tools)]

month_job_type <- outputAll[`Posted Date` > "2019-01-01",.N, .(month, job_type)]

month <- outputAll[`Posted Date` > "2019-01-01",.N, .(month)]


ggplot(data = month_job_type_tools[job_type == 'Permanent'],
       aes(x = month, y = N, group = Tools)) + geom_line(aes(colour = Tools)) + scale_x_date(labels = scales::date_format("%Y-%m"),
                                                                                             breaks = "1 month")

ggplot(data = month_job_type[job_type == 'Contract'],
       aes(x = month, y = N)) + geom_line(aes(colour = "blue")) + scale_x_date(labels = scales::date_format("%Y-%m"),
                                                                                             breaks = "1 month")

ggplot(data = month,
       aes(x = month, y = N)) + geom_line(aes(colour = "blue")) + scale_x_date(labels = scales::date_format("%Y-%m"),
                                                                               breaks = "1 month")

# testing reading in data
month <- readRDS(file = file.path(dirShiny, '08_month.RData'))
month_job_type <- readRDS(file = file.path(dirShiny, '08_month_job_type.RData'))
month_job_type_tools <- readRDS(file = file.path(dirShiny, '08_month_job_type_tools.RData'))


