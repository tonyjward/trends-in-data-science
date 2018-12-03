
# first make sure you run 
# docker run -d -p 4445:4444 selenium/standalone-firefox:2.53.0
# in a docker container

# to do
# 1) do error handling - what happens when there is an error. use a try catch
# 2) add a check to see if all the downloads happeneded, and then if not try them again
# 3) automate the job to run every day, or every time you log onto the pc
# 4) push to

rm(list=ls())

source('RCode/fn_webscrape.R')

                   
searchTerms <- c('"data scientist"',
                 '"digital project manager"',
                 '"data science"',
                 '"machine learning"',
                 '"artificial intelligence"',
                 'statistician OR statistics',
                 'actuary OR actuarial',
                 'physiotherapist',
                 'teacher',
                 '"c developer"')
                 
sapply(searchTerms, fn_webScrape)

