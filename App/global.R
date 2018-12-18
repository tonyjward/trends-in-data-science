# run all Modules
sapply( list.files("modules", full.names=TRUE), source )

# run all functions
# sapply( list.files("functions", full.names=TRUE), source )