library(Rcpp)
# ----------------------------------------------------------
# Step 2 - ICE Calculation

# Inputs : Vectors : Ambient Temperature, K2, Dt, k11, 
#        : Scalars : Initial top oil temp, Thermal coefficients (tao_o, R, x, DT_or)
# Output : Vector of Top Oil Temperature

cppFunction('NumericVector IEC_train(double T_o1,
                                    NumericVector Amb_temp, 
                                    NumericVector K2,
                                    NumericVector Dt,
                                    NumericVector k_11,
                                    double tao_o,
                                    double R,
                                    double x,
                                    double dT_or
){ 
            
            int n = Amb_temp.size();
            NumericVector T_o(n);
            NumericVector DT_o(n);
            
            for(int i = 0; i<n; ++i){
              if (i == 0) {
                DT_o[i] = Dt[i]/k_11[i]/tao_o*((pow((1+R*K2[i])/(1+R),x)) *dT_or-(T_o1-Amb_temp[i]));
                T_o[i] = T_o1 + DT_o[i];
              }
            
              else {
                DT_o[i] = Dt[i]/k_11[i]/tao_o*((pow((1+R*K2[i])/(1+R),x))*dT_or-(T_o[i-1]-Amb_temp[i]));
                T_o[i] = T_o[i-1] + DT_o[i];
            }
            
}

return T_o;
}')