# 99a_DocumentTermMatrix.R

# Purpose: Prototype glmnet model

# Contents:
#   1. Define Macro Variables



# TODO - IF THERE ARE NO DOCUS REMOVED THEN THE SAVE DOESN'T WORK
#---------------------------------------------------------------------
#   _. Load data required

load(file = file.path(dirRData, '03_txtDtm.RData'))
load(file = file.path(dirRData,'03_dt_all.RData'))


#---------------------------------------------------------------------
#   1. Pre-process data 

# Create target vector and input matrix
y_orig <- dt_all$salaryMax

x_orig <- sparseMatrix(i=txtDtm$i,
                       j=txtDtm$j,
                       x=txtDtm$v,
                       dims=c(txtDtm$nrow, txtDtm$ncol))

# remove NA's (jobs with no salary)
idx_NA <- is.na(y_orig)
y <- y_orig[!idx_NA]
x <- x_orig[!idx_NA,]

colnames(x) <- colnames(txtDtm)

#---------------------------------------------------------------------
#   2. Partition data

# We will test the model using the last 2 months worth of jobs, and train using everything prior
test_start <- Sys.time() - 60*60*24*30*2
idx_test <- dt_all[!idx_NA, `Posted Date`] > test_start 
idx_train <- !idx_test 
idx_train[is.na(idx_train)] <- FALSE # catch NA's resulting from when is.na(dt_all$`Posted Date`) == TRUE



glmnet_fit <- 
  cv.glmnet(x = x[idx_train,],
            y = y[idx_train],
            family = 'gaussian',
            standardize = FALSE, # FALSE since we only have categorical variables
            parallel = FALSE,
            alpha = 1,
            #foldid = foldid
            )

plot(glmnet_fit)

summary(glmnet_fit)

glmnet_coef <- coef(glmnet_fit,s = glmnet_fit$lambda.min) %>% as.matrix() %>% as.data.table(keep.rownames = TRUE)

setnames(glmnet_coef,
         old = c("rn","1"),
         new = c("rn", "coef"))

setorder(glmnet_coef, coef)

