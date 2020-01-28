# 04_HypterparamterTuning.R

# Purpose: Random search finding optimal values for Alpha, Delta
#          We use a reduced number of iterations here, since the optional choice of alpha and delta is pretty much the same
#          if we chose iter = 400 vs iter = 10000

# Contents:
#   0. Settings
#   1. Load data
#   2. Hyperparemter Tuning
#   3. Suggest number of topics
#   4. save output

# ----------------------------------------------------------
#  0. Settings

seed=2017

# hyperparameter tuning
folds <- 5
candidateK <- c(10,20,30,40,50,60) # candidateK <- c(4,5) 
candidateBurnin <- c(50)
candidateIter <- c(600)
candidateAlpha <- runif(30, 0.001, 0.2)
candidateDelta <- runif(30, 0.001, 0.2)
keep = 50

#---------------------------------------------------------------------
#  1.. Load data 

load(file = file.path(dirRData,'03_txtDtm.RData'))
load(file = file.path(dirRData,'03_settings.RData'))

full_data  <- txtDtm
n <- nrow(full_data)
rm(txtDtm)
gc()

#---------------------------------------------------------------------
#   2. Hyperparemter Tuning

# set up a cluster for parallel processing

# parallel processing using snow and for each - initiate cores
library(parallel)
workers <- parallel::detectCores() 

library(doSNOW)
cluster <- parallel::makeCluster(workers)
registerDoSNOW(cluster) 

# send data and packages to multicores 
clusterEvalQ(cluster, library(topicmodels)) 

splitfolds <- sample(1:folds, n, replace = TRUE)

hyperparams <- data.table(k = candidateK,
                          alpha = rep(candidateAlpha, each = length(candidateK)),
                          delta = rep(candidateDelta, each = length(candidateK)),
                          burnin = candidateBurnin,
                          iter = candidateIter)

setorder(hyperparams, k)

# export all the needed R objects to the parallel sessions
clusterExport(cluster, c("full_data", 
                         "seed",
                         "keep",
                         "splitfolds", 
                         "folds", 
                         "hyperparams",
                         "dirRData"))

# we parallelize by the different number of topics.  A processor is allocated a value
# of k, and does the cross-validation serially.  This is because it is assumed there
# are more candidate values of k than there are cross-validation folds, hence it
# will be more efficient to parallelise
timePerplexity<- system.time({
  results   <- foreach(j = 1:nrow(hyperparams), .combine = rbind) %dopar%{
    print(paste(j, " iteration of", nrow(hyperparams)))
    hp_alpha  <-hyperparams[j,"alpha"]
    hp_delta  <-hyperparams[j,"delta"]
    hp_burnin <- hyperparams[j,"burnin"]
    hp_iter   <- hyperparams[j,"iter"]
    k         <-hyperparams[j,"k"]
    
    results_1k <- matrix(0, nrow = folds, ncol = 6)
    
    colnames(results_1k) <- c("k", "alpha", "delta", "burnin", "iter", "perplexity")
    
    control_LDA_Gibbs = list(seed=seed,burnin = hp_burnin, iter = hp_iter, keep = keep, alpha=hp_alpha, delta = hp_delta)
    
    for(i in 1:folds){
      train_set <- full_data[splitfolds != i , ]
      valid_set <- full_data[splitfolds == i, ]
      
      fitted <- LDA(train_set, k = k, method = "Gibbs",
                    control = control_LDA_Gibbs)
      
      results_1k[i,] <- c(k, hp_alpha, hp_delta, hp_burnin, hp_iter, perplexity(fitted, newdata = valid_set))
      
    }
    return(results_1k)
  }
})
stopCluster(cluster)

results_df <- as.data.frame(results)

# selecting optimal settings per topic size
results_dt <- as.data.table(results_df)

optimalSettings <- results_dt[, .SD[which.min(perplexity)], by = k]


ggplot(optimalSettings, aes(x = k, y = perplexity)) + geom_line() + labs(title = "Number of Topics vs Perplexity",
                                                                         x = "No. Topics",
                                                                         y = "Perplexity")
#---------------------------------------------------------------------
#   3. Suggest number of topics

# calculate acceleration as per
# https://pdfs.semanticscholar.org/8353/09966a880c656d59fe29664ae03db09d56ab.pdf
optimalSettings[, perplexityLag := shift(perplexity, type = "lag")]
optimalSettings[, perplexityLead := shift(perplexity, type = "lead")]
optimalSettings[, acceleration := round((perplexityLead - perplexity) - (perplexity - perplexityLag),2)]

# identify optimal topic size
optimalK <- optimalSettings[which.max(acceleration), k]

#---------------------------------------------------------------------
#   4. save output

identifier <- paste(text_field, sep = "_") %>% gsub(" ", "_", .)

write.table(optimalSettings,
            file = file.path(dirROutput, paste0('04_', 'optimalSettings_', identifier,'.csv')),
            row.names = FALSE,
            sep = ",")

# save for 05_FinalModelTraining.R
save(optimalSettings,
     file = file.path(dirRData,'04_optimalSettings.RData'))

# save for use in shiny app
saveRDS(optimalSettings,
     file = file.path(dirShiny, '04_optimalSettings.RData'))

saveRDS(optimalK,
     file = file.path(dirShiny, '04_optimalK.RData'))

save(results_df,
     timePerplexity,
     file = file.path(dirRData,'04_tuning_extra.RData'))

write.table(results_df,
            file = file.path(dirROutput, '04_tuning_extra.csv'),
            row.names = FALSE,
            sep = ",")

cleanUp(functionNames)
gc()
