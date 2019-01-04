


outputData <- readRDS(file = "App/RData/05i_OutputData.RData")

dt <- outputData[[1]]

# Split between Python/R

split <- table(dt$Python, dt$R)
proportions <- (prop.table(split) * 100) %>% round()
colnames(proportions) <- c("NO R", "R")
rownames(proportions) <- c("NO Python", "Python")
proportions


# compare character vs numeric
dt_all[job_type == "Permanent" & !is.na(salaryMax) ,.(Salary, salaryMax)]

# calculate salary averages
dt_all[,.(jobs = .N,
          salaryDataAvailable = sum(!is.na(salaryMax)), 
          averageMaxSalary = mean(salaryMax, na.rm = TRUE)), 
       by = job_type]


