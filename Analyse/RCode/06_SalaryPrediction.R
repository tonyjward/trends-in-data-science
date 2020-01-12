# 99a_DocumentTermMatrix.R

# Purpose: Prototype glmnet model

# Contents:
#   1. Define Macro Variables



# TODO - IF THERE ARE NO DOCUS REMOVED THEN THE SAVE DOESN'T WORK
#---------------------------------------------------------------------
#   _. Load data required

load(file = file.path(dirRData, '03_txtDtm.RData'))
load(file = file.path(dirRData,'03_dt_all.RData'))

mat <-  sparseMatrix(i=txtDtm$i,
                    j=txtDtm$j,
                    x=txtDtm$v,
                    dims=c(txtDtm$nrow, txtDtm$ncol))

colnames(mat) <- colnames(txtDtm)


# to create validation set we want the last 30 days worth of jobs

#use
Sys.time()
# and subtract number of seconds

idx_train <- dt_all$`Posted Date` %>% class()

60*60*24



salaryMax

x_train
y_train
x_test
y_test

