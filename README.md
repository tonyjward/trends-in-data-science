# trends-in-data-science
The objective of this project is to monitor the trends in data science job opportunities. We achieve this through scraping of the jobserve website. 

# Build Dockerfile with R and required libraries installed

'''bash
docker build -f DockerfileR -t tonyjward/rstudio .
'''

We only need to do this once

# Start Selenium

'''bash
docker run -d -p 4445:4444 selenium/standalone-firefox-debug:3.14
'''

# Launch R session

Since we will do this many times I have written a shell script. We first need to make this file 
executable. You only need to run that once.
Run 

'''bash
$chmod +x launch-R.sh 
'''

which makes the file executable.
Then everytime you want to launch an R Studio Server session you can run ./launch-R.sh
Then navigate to localhost:8787


