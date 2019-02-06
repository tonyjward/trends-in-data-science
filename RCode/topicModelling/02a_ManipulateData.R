# 02a_ManipulateData.R
# Author: Tony Ward
# Date: 21 June 2016

# Purpose: Manipulate data as needed

# Contents:
#   1. Intial Review of Variable Types
#   2. Ensure Column Nammes are Valid
#   3. Add Fold for partitioning 
#   4. Add 'YYYYQq' e.g. (e.g. '2010Q1' for quarterly data) for googleVis plot 
#   5. remove 2016Q3 as we only have 96 surveys
#   6. Create uniuqe string identifier for each row
#   7. Create overall text field and delete row if they don't tell us anything

#---------------------------------------------------------------------
#   _. Load data required

dt_all <- readRDS(dt, file = "/home/rstudio/RData/01_dt_all.RData")


#---------------------------------------------------------------------
#  2. Ensure Column Nammes are Valid
#   Change Column Names
#   https://stackoverflow.com/questions/9283171/named-columns-renaming



setnames(dt_all,
         old = c("jobResultsTitle",
                 "jobResultsSalary",
                 "jobResultsLoc",
                 "jobResultsType",
                 "jobpositionlink",
                 "skills",
                 "posted_date"),
         new = c("Title",
                 "Salary",
                 "Location",
                 "Type",
                 "Link",
                 "Skills",
                 "Posted Date"))

#---------------------------------------------------------------------
#  3. Add Fold for partitioning 

set.seed(2017)

dt_all[,fold := sample(10, size = nrow(dt_all), replace = TRUE)]

#---------------------------------------------------------------------
#  4. Add 'YYYYQq' e.g. (e.g. '2010Q1' for quarterly data) for googleVis plot 

# change date_time variable to datetime format
# https://stackoverflow.com/questions/21571703/format-date-as-year-quarter

dt_all[ ,`Posted Date` :=  as.POSIXct(dt_all$`Posted Date`, format="%d/%m/%Y %T", 'GMT')]

# Year Qtr
yq <- as.yearqtr(dt_all$`Posted Date`, format = "%Y Q%q")
dt_all[,yearQtr := gsub(" ", "", yq)]
table(dt_all$yearQtr)

# Year Mon
dt_all[,yearMon := as.yearmon(`Posted Date`)]
table(dt_all$yearMon)

# Daily
dt_all[,yearMonDay := `Posted Date` %>% as.Date()]

#---------------------------------------------------------------------
#  6. Create uniuqe string identifier for each row

dt_all[,doc_id := 1:nrow(dt_all)]

#---------------------------------------------------------------------
#  7. Clean up data

dt_all[, Salary := gsub('Â','',Salary)]


#---------------------------------------------------------------------
#  8. Tools

dt_all[, Python := grepl("[P|p]ython", Skills)]
dt_all[, R := grepl("R[ [:punct:]]", Skills)]
dt_all[,Python_R := paste(Python, R, sep = "_")]

dt_all[, Tools := ifelse(Python_R == "TRUE_TRUE", "Python or R",
                            ifelse(Python_R == "TRUE_FALSE", "Python but not R",
                                   ifelse(Python_R == "FALSE_TRUE", "R but not Python","Neither Language")))]

#---------------------------------------------------------------------
#  9. Grab Max Salary

# remove comma's so that 31,850 is treated as 31850 and can be detected as a whole word

dt_all[, Salary := gsub(',','',Salary)]

g <- gregexpr('[0-9]+',dt_all$Salary)

m <- regmatches(dt_all$Salary,g)

maxFun <- function(x){
  if (length(x)==0)
    return(NA)
  else 
    x %>% as.numeric() %>% max()
}

dt_all[,salaryMax := sapply(m, maxFun)] 

# convert all jobs to units of 1000
dt_all[, salaryMax:= ifelse(nchar(salaryMax)>=5, salaryMax/1000, salaryMax)]

# change job type to Contract if salary mentions a day rate
dt_all[grepl('[p|P]er [d|D]ay', dt_all$Salary) & job_type == "Permanent", job_type := "Contract"]

#---------------------------------------------------------------------
#  7. Prototype Charts

############# line graph

# ggplot(data = dt_all, aes_string(x = "yearMonDay", fill = "Python_R")) + "geom_bar"()


#--------------------------------------------------------------
# DONE. Save results and gc()


saveRDS(dt_all, file = "/home/rstudio/RData/02a_dt_all.RData")

cleanUp(functionNames)
gc()
