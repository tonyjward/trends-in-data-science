# Used to select the "optimal" number of topics
# http://stackoverflow.com/questions/21355156/topic-models-cross-validation-with-loglikelihood-or-perplexity
# http://epub.wu.ac.at/3558/1/main.pdf

harmonicMean <- function(logLikelihoods, precision=2000L) {
  library("Rmpfr")
  llMed <- median(logLikelihoods)
  as.double(llMed - log(mean(exp(-mpfr(logLikelihoods,
                                       prec = precision) + llMed))))
}