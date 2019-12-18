# 04 Tuning Hyperparameters using perplexity.R
# Author: Tony Ward
# Date: 21 June 2016

# Purpose: Grid search finding optimal values for Alpha, Delta and also testing effect of K, Burnin and Iterations
#          We use a reduced number of iterations here, since the optional choice of alpha and delta is pretty much the same
#          if we chose iter = 400 vs iter = 10000

# Contents:
#   1. Topic Model Parameters
#   2. 5-fold cross-validation, different numbers of topics
#   3. save output

#---------------------------------------------------------------------
#   _. Load data required

load(file = file.path(dirRData,'03_txtDtm.RData'))
load(file = file.path(dirRData,'03_settings.RData'))


# rename document term matrix for ease

full_data  <- txtDtm
n <- nrow(full_data)
rm(txtDtm)
gc()
#---------------------------------------------------------------------
#   1. Topic Model Parameters

seed=2018
keep = 50

#---------------------------------------------------------------------
#   2. 5-fold cross-validation, different numbers of topics

# set up a cluster for parallel processing

# parallel processing using snow and for each - initiate cores
library(parallel)
workers <- parallel::detectCores() 

library(doSNOW)
cluster <- parallel::makeCluster(workers)
registerDoSNOW(cluster) 

# send data and packages to multicores 
clusterEvalQ(cluster, library(topicmodels)) 

folds <- 5
splitfolds <- sample(1:folds, n, replace = TRUE)


# candidateAlpha <- c(0.001, 0.005, 0.01, 0.05,	0.1, 0.15, 0.2,0.25, 0.3, 0.35, 0.4)
# candidateDelta <- c(0.001,	0.005, 0.01, 0.05, 0.1, 0.2)
# candidateK <- c(5)

candidateK <- c(10, 25)

candidateBurnin <- c(50)
candidateIter <- c(200)

candidateAlpha <- c(0.1)
candidateDelta <- c(0.05)

hyperparams1 <- expand.grid(alpha = candidateAlpha,
                           delta = candidateDelta,
                           k = candidateK,
                           burnin = candidateBurnin,
                           iter = candidateIter)
candidateK <- c(40)
candidateAlpha <- c(0.1,0.2,0.3)
candidateDelta <- c(0.05, 0.1, 0.2)

hyperparams2 <- expand.grid(alpha = candidateAlpha,
                            delta = candidateDelta,
                            k = candidateK,
                            burnin = candidateBurnin,
                            iter = candidateIter)

hyperparams <- rbind(hyperparams1, hyperparams2)

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
#   4. Find optimal number of topics

# calculate acceleration as per https://pdfs.semanticscholar.org/8353/09966a880c656d59fe29664ae03db09d56ab.pdf
optimalSettings[, perplexityLag := shift(perplexity, type = "lag")]
optimalSettings[, perplexityLead := shift(perplexity, type = "lead")]
optimalSettings[, acceleration := round((perplexityLead - perplexity) - (perplexity - perplexityLag),2)]

# identify optimal topic size
optimalK <- optimalSettings[which.max(acceleration), k]

#---------------------------------------------------------------------
#   3. save output

identifier <- paste(field_name, sep = "_") %>% gsub(" ", "_", .)


write.table(optimalSettings,
            file = file.path(dirROutput, paste0('04_', 'optimalSettings_', identifier,'.csv')),
            row.names = FALSE,
            sep = ",")

# save for use in shiny app
saveRDS(optimalSettings,
     file = '/home/rstudio/Shiny/RData/04_optimalSettings.RData')

saveRDS(optimalK,
     file = '/home/rstudio/Shiny/RData/04_optimalK.RData')

save(results_df,
     timePerplexity,
     file = file.path(dirRData,'04_tuning_extra.RData'))

write.table(results_df,
            file = file.path(dirROutput, '04_tuning_extra.csv'),
            row.names = FALSE,
            sep = ",")

cleanUp(functionNames)
gc()
