# 05 fitting models with optimal settings.R
# Author: Tony Ward
# Date: 21 June 2016

# Purpose:
# Here we train the topic model on the whole dataset
# This is becaues we are not so interested in proving that the model generalises well
# We want to just show how the model performs on the whole data
# this is especially important when we don't have much data
# we take the optimal settings for alpha and delta for each k from code 05f

# Contents:
#   1. Topic Model Parameters
#   2. Prepare hyperparameters object
#   3. Run topic models with optimal settings and save LDA models

#---------------------------------------------------------------------
#   _. Load data required

load(file = file.path(dirRData,'03_dt_all.RData'))
load(file = file.path(dirRData,'03_txtDtm.RData'))
load(file = file.path(dirRData,'04_optimalSettings.RData'))
load(file = file.path(dirRData,'03_settings.RData'))

# rename document term matrix for ease

full_data  <- txtDtm
n <- nrow(full_data)
rm(txtDtm)
gc()

#---------------------------------------------------------------------
#   1. Topic Model Parameters

seed <- 2018
keep <- 50
burninFit <- 50
iterFit <- 2000


#---------------------------------------------------------------------
#   2. Prepare hyperparameters object

optimalSettings[, perplexity := NULL]
optimalSettings[, burnin := burninFit]
optimalSettings[, iter := iterFit]
hyperparams <- optimalSettings

#---------------------------------------------------------------------
#   3. Run topic models with optimal settings and save LDA models

# set up a cluster for parallel processing
# parallel processing using snow and for each - initiate cores
library(parallel)
workers <- parallel::detectCores()

library(doSNOW)
# cluster <- makeCluster(workers, type = "SOCK")
cluster <- parallel::makeCluster(workers)
registerDoSNOW(cluster) 

# send data and packages to multicores 
clusterEvalQ(cluster, library(topicmodels)) 

# export all the needed R objects to the parallel sessions
clusterExport(cluster, c("full_data", 
                         "seed",
                         "keep",
                         "hyperparams",
                         "dirRData"))

# we parallelize by the different number of topics.  A processor is allocated a value
# of k, and does the cross-validation serially.  This is because it is assumed there
# are more candidate values of k than there are cross-validation folds, hence it
# will be more efficient to parallelise
timePerplexity2<- system.time({
  fitted_many_p   <- foreach(j = 1:nrow(hyperparams)) %dopar%{
    print(paste(j, " iteration of", nrow(hyperparams)))
    hp_alpha  <-hyperparams[j,"alpha"]
    hp_delta  <-hyperparams[j,"delta"]
    hp_burnin <- hyperparams[j,"burnin"]
    hp_iter   <- hyperparams[j,"iter"]
    k         <-hyperparams[j,"k"]
    
    control_LDA_Gibbs = list(seed=seed,burnin = hp_burnin, iter = hp_iter, keep = keep, alpha=hp_alpha, delta = hp_delta)
    
    fitted <- LDA(full_data, k = k, method = "Gibbs",
                  control = control_LDA_Gibbs)
    
    return(fitted)
  }
})
stopCluster(cluster)

names(fitted_many_p) <- hyperparams$k

# save results
identifier <- paste(field_name, "iterations", iterFit, sep = "_") %>% gsub(" ", "_", .)

# save for future use
save(fitted_many_p,
     identifier,
     optimalSettings,
     hyperparams,
     dt_all,
     file = file.path(dirRData,paste0('05_',identifier,'.RData')))

# save for immediate use
save(fitted_many_p,
     identifier,
     optimalSettings,
     hyperparams,
     dt_all,
     file = file.path(dirRData,paste0('05_models.RData')))

cleanUp(functionNames)
gc()
