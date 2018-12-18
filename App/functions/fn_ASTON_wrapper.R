
ASTON <- function(param, Data) {
  
  if (is.vector(param)){
    param <- matrix(param, nrow = 4, ncol = 1)
  }
  
  # IEC Calculation. Preds is a matrix with dimensions [n , length(param)]
  preds <- apply(param, 2, function(x){
    IEC_train( T_o1     = Data$T_o1,
               Amb_temp = Data$Amb_temp, 
               K2       = Data$K2,
               Dt       = Data$Dt,
               k_11     = Data$k_11,
               tao_o    = x[1],
               dT_or    = x[2],
               R        = x[3],
               x        = x[4]
    )
  })
  
  # Calculate Error (only take relevant contribution to error by using currentyOptimising)
  score <- ASTON_CALC(y                   = Data$y,
                      dayOfYear           = Data$dayOfYear,
                      preds               = preds,
                      COOLINGSTAGENUM     = Data$COOLINGSTAGENUM,
                      currentlyOptimising = Data$currentlyOptimising)
  return(score) 
  
} 

# testing ASTON

# param <- c(210,52,6,0.8)

# # matrix param
# param <- matrix(c(210,52,6,0.8,220,52,6,0.8,230,52,6,0.8), nrow = 4, ncol = 3)
# ASTON(param, Data)
