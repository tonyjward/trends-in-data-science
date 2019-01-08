


outputData <- readRDS(file = "/home/rstudio/App/RData/05i_OutputData.RData")

dt_all <- outputData[[1]][[1]]

# Split between Python/R

split <- table(dt_all$Python, dt_all$R)
proportions <- (prop.table(split) * 100) %>% round()
colnames(proportions) <- c("NO R", "R")
rownames(proportions) <- c("NO Python", "Python")
proportions


# compare character vs numeric
dt_all[job_type == "Permanent" & !is.na(salaryMax) ,.(Salary, salaryMax)]

dt_all[job_type == "Permanent" & salaryMax >500 ,.(Salary, salaryMax)]

# calculate salary averages
dt_all[,.(jobs = .N,
          salaryDataAvailable = sum(!is.na(salaryMax)), 
          averageMaxSalary = mean(salaryMax, na.rm = TRUE)), 
       by = Tools]


ggplot(data = dt_all, aes(x = Tools)) + geom_bar()

ggplot(data = dt_all[job_type == "Contract"], aes(x = Tools, y = salaryMax, fill = Tools)) + geom_boxplot()
ggplot(data = dt_all[job_type == "Permanent"], aes(x = Tools, y = salaryMax, fill = Tools)) + geom_boxplot()
