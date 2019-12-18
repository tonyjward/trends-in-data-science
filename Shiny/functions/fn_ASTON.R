
















# INPUTS
# y           : actuals (n x 1 vector)
# dayOfYear   : day of the year 
# preds       : model predictions (n x p matrix)

# OUTPUTS
# score       : Aston Score

ASTON_CALC <- function(y, dayOfYear, preds, COOLINGSTAGENUM, currentlyOptimising = NULL) {
  
  # TO DO - INCLUDE ERROR HANDLING HERE ****************************************************
  # subset input data by cooling type
  
  if (!is.null(currentlyOptimising)){
    
    # indicator variable isolating cooling type of interest
    idx <- currentlyOptimising == COOLINGSTAGENUM
 
    # filter the data - only keeping data relevant to specific cooling type
    y <- y[idx]
    dayOfYear <- dayOfYear[idx]
    preds <- preds[idx,,drop = FALSE]
    
  }
  
  # calculate error
  
  aux <- y - preds
  aux <- aux * aux
  RMSE <- sqrt(apply(aux, 2L, sum)/length(y))
  
  # Percentiles
  
  # works for matrix of predictions but answer if provided as list
  
  noParams <- ncol(preds)
  noDays <- length(unique(dayOfYear))
  
  # quantiles for predictions
  quant_preds_list <- apply(preds, 2, function(x){
    tapply(x, dayOfYear, quantile, probs = c(0.1,0.9,1))
  })
  quant_preds_vec <- unlist(quant_preds_list, use.names = FALSE)
  
  quant_preds_matrix <- matrix(quant_preds_vec,ncol = noParams)
  
  # quantiles for actuals
  quant_actual_list <- tapply(y, dayOfYear, quantile, probs = c(0.1,0.9,1))
  quant_actual_vec <- unlist(quant_actual_list, use.names = FALSE)
  
  diff_quantiles <- quant_actual_vec - quant_preds_matrix
  diff_quantiles_abs <- abs(diff_quantiles)
  
  idx_B10  <- rep(c(TRUE, FALSE, FALSE), noDays)
  idx_T10  <- rep(c(FALSE, TRUE, FALSE), noDays)
  idx_max <- rep(c(FALSE, FALSE, TRUE), noDays)
  
  if (noParams == 1){
    AvgB10  <- mean(diff_quantiles[idx_B10,])
    AvgT10  <- mean(diff_quantiles[idx_T10,])
    AvgMax  <- mean(diff_quantiles[idx_max,])
    
    MaxB10  <- max(diff_quantiles[idx_B10,])
    MaxT10  <- max(diff_quantiles[idx_T10,])
    MaxMax  <- max(diff_quantiles[idx_max,])
  } else {
    AvgB10  <- apply(diff_quantiles[idx_B10,],2,mean)
    AvgT10  <- apply(diff_quantiles[idx_T10,],2,mean)
    AvgMax <- apply(diff_quantiles[idx_max,],2,mean)
    
    MaxB10  <- apply(diff_quantiles[idx_B10,],2,max)
    MaxT10  <- apply(diff_quantiles[idx_T10,],2,max)
    MaxMax <- apply(diff_quantiles[idx_max,],2,max)
  }
  
  
  # Weights
  weightRMSE    <- 5
  weightAvgB10  <- 1
  weightAvgT10  <- 1
  weightAvgMax  <- 6
  weightMaxB10  <- 0.25
  weightMaxT10  <- 0.25
  weightMaxMax  <- 1.5
  
  # Optimum Values
  optimumRMSE    <- 0
  optimumAvgB10  <- 0
  optimumAvgT10  <- -0.5
  optimumAvgMax  <- -1
  optimumMaxB10  <- 0
  optimumMaxT10  <- -0.5
  optimumMaxMax  <- -1
  
  # Scores
  scoreRMSE    <- abs(RMSE - optimumRMSE) * weightRMSE
  scoreAvgB10  <- abs(AvgB10 - optimumAvgB10) * weightAvgB10
  scoreAvgT10  <- abs(AvgT10 - optimumAvgT10) * weightAvgT10
  scoreAvgMax  <- abs(AvgMax - optimumAvgMax) * weightAvgMax
  scoreMaxB10  <- abs(MaxB10 - optimumMaxB10) * weightMaxB10
  scoreMaxT10  <- abs(MaxT10 - optimumMaxT10) * weightMaxT10
  scoreMaxMax  <- abs(MaxMax - optimumMaxMax) * weightMaxMax
  
  score <- scoreRMSE + scoreAvgB10 + scoreAvgT10 + scoreAvgMax + scoreMaxB10 + scoreMaxT10 + scoreMaxMax
  
  return(score)
}
