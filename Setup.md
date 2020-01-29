# Set up
These set up instructions assume an Ubuntu linux distribution, and have been tested on 18.04.

## Clone Repo

Clone the repos
```
git clone https://github.com/tonyjward/trends-in-data-science.git
```
Then creates some directories in the folder
```
cd trends-in-data-science
mkdir Analyse/Logs Analyse/RData Analyse/ROutput Scraping/Logs Scraping/ROutput Shiny/Logs Shiny/RData
```
## Pull Docker Images
Install docker as per https://docs.docker.com/install/linux/docker-ce/ubuntu/.

Install docker-compose as per https://docs.docker.com/compose/install/

It is important to install docker-compose using the official instructions above rather than sudo apt-get install to avoid conflicts when logging into docker hub.

Log in to docker hub. If you haven't got a dockerhub account create one here first https://hub.docker.com/
```
sudo docker login --username=<your_username>
```
Pull images for dockerhub
```
sudo docker pull tonyjward/trends-in-data-science:scraping
sudo docker pull tonyjward/trends-in-data-science:analyseinteractive
sudo docker pull tonyjward/trends-in-data-science:analyse
sudo docker pull tonyjward/trends-in-data-science:shiny
```
## Task Scheduling

Bring up the crontab for users with root permissions (so we don't have to prefix commands with sudo)

```bash
sudo crontab -e
```

Then add the following line to the file, making sure to point to the correct path 

```bash
01 00 * * * cd /home/<your_username>/repos/trends-in-data-science && ./launch-scraping.sh
30 01 * * * cd /home/<your_username>/repos/trends-in-data-science && ./launch-analyse.sh
00 08 * * * cd /home/<your_username>/repos/trends-in-data-science && ./launch-shiny.sh
```
The above configuration will start three processes at 12:01am (launch-scraping.sh), 01:30am (launch-analyse.sh) and 08:00am (launch-shiny.sh). The timings have been chosen to allow sufficient time for each process to finish before the next is started 

### launch-scraping.sh
This starts two services 
1) A selenium server
2) An RStudio server with web-scraping libraries installed

The RStudio image has an entry point set to 'Scraping/entrypointScraping.R' - i.e this is the code that gets run upon startup of the service. What 'Scraping/entrypointScraping.R' does is send a number of search terms to a web scraping function Scraping/fn_webscrape.R which then scrapes the data from jobserve and stores the resulting text file in Scraping/ROutput. 

### launch-analyse.sh
This starts one service - an RStudio server with several data analysis and topic modelling libraries installed. The RStudio image has an entry point set to 'Analyse/entrypointAnalyse.R'- i.e this is the code that gets run upon startup of the service. What 'Analyse/entrypointAnalyse.R' does is the following



Modifying file R script "Analyse/entrypointAnalyse.r" controls which aspects of the data analysis pipelines are run. Typically the user might want to comment out "04_HyperparameterTuning.R" since it is not necessary to tune the hyperparemeters every day.

### launch-shiny.sh



# Analyse Job Data

## Build Dockerfile
```bash
./launch-analysis.sh
```

or we can do it interactively as well, by first launching the image

```bash
./launch-analysis-interactive.sh
```

then navigating to the Rserver at the relevant ip address and running the code manually

## Logging

## Debugging
This all happens automatically, but sometimes to debug it is useful to run the code ourselves interactively. To do this we instead run


```bash
sudo docker-compose -f docker-compose-interactive.yml up --force-recreate -d
```
Then navigate to 
* localhost:80 to view RStudio or
* localhost:4445 to view Selenium Browser


Then at 12:10 AM the job will run. The job first changes directory to the location of the docker file, and then runs docker-compose.
It was necessary to use the --force-recreate option, otherwise somethings the rstudio container doesn't always start.

