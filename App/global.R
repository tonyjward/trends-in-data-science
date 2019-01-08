library(shiny)
library(reshape2)
library(dplyr)
library(data.table)
library(ggplot2)
library(DT)
library(LDAvis)

# run all Modules
sapply( list.files("modules", full.names=TRUE), source )

# run all functions
# sapply( list.files("functions", full.names=TRUE), source )