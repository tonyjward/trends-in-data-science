# Trends in data science
The main goal of this project is to monitor the trends in the UK data science job market. I originally started this project in 2018 to help me decide whether to learn Python or not. I now use it as motiviation too keep learning Python! 

#### -- Project Status: Completed

### Methods Used
* Web Scraping
* Data Visualization
* Topic Modelling (LDA)
* Web Application (Development/Hosting)
* Task Scheduling

### Technologies
* R 
* Shiny
* Selenium
* Docker
* Linux

## Project Description
(Provide more detailed overview of the project.  Talk a bit about your data sources and what questions and hypothesis you are exploring. What specific data analysis/visualization and modelling work are you using to solve the problem? What blockers and challenges are you facing?  Feel free to number or bullet point things here)

## Needs of this project

- frontend developers
- data exploration/descriptive statistics
- data processing/cleaning
- statistical modeling
- writeup/reporting
- etc. (be as specific as possible)

## Getting Started

1. Clone this repo (for help see this [tutorial](https://help.github.com/articles/cloning-a-repository/)).
2. Raw Data is being kept [here](Repo folder containing raw data) within this repo.

    *If using offline data mention that and how they may obtain the data from the froup)*
    
3. Data processing/transformation scripts are being kept [here](Repo folder containing data processing scripts/notebooks)
4. etc...

*If your project is well underway and setup is fairly complicated (ie. requires installation of many packages) create another "setup.md" file and link to it here*  

5. Follow setup [instructions](Link to file)

## Featured Notebooks/Analysis/Deliverables
* Medium Article (TBC)




#### Other Members:

|Name     |  Slack Handle   | 
|---------|-----------------|
|[Full Name](https://github.com/[github handle])| @johnDoe        |
|[Full Name](https://github.com/[github handle]) |     @janeDoe    |

## Contact
* If you haven't joined the SF Brigade Slack, [you can do that here](http://c4sf.me/slack).  
* Our slack channel is `#datasci-projectname`
* Feel free to contact team leads with any questions or if you are interested in contributing!

# trends-in-data-science
The objective of this project is to monitor the trends in data science job opportunities. We achieve this in three stages

1) Scraping jobserve.com 
2) Analyse job data 
3) Visualisation output

and present the results as a shiny app here https://apps.statcore.co.uk/

# Set up Linux machine

First install docker and docker-compose if they are not already installed

```bash
sudo apt-get update
sudo apt-get install docker
sudo apt-get install docker-compose
```

Then clone the repos
```
git clone https://github.com/tonyjward/trends-in-data-science.git
```

Then creates some directories in the folder
```
cd trends-in-data-science
mkdir Logs RData App/RData
```

And build the containers
```
./build-scraping.sh && ./build-analyse.sh && ./build-shiny.sh
```

# Scraping jobserve.com

# First Build Dockerfile with R and required libraries installed (RSelenium). 

This shell script builds the Dockerfile called DockerfileAnalyse, which creates an image with R installed together with the required libraries 

```bash
./build-analyse.sh
```

Then in order to do the web-scraping we run

```bash
sudo docker-compose up --force-recreate -d
```

This starts two services 
1) A selenium server
2) Our R image created above

The above code has an entry point set to be 'entrypointScraping.R' which is found in the RCode directory. 
Setting the code as an entry point means that it gets run automatically when the service starts. 
Modifying "entrypointScraping.r" controls which search terms are send to the jobserve website.

This all happens automatically, but sometimes to debug it is useful to run the code ourselves interactively. To do this we instead run

```bash
sudo docker-compose -f docker-compose-interactive.yml up --force-recreate -d
```
Then navigate to 
* localhost:80 to view RStudio or
* localhost:4445 to view Selenium Browser

# Analyse Job Data

## Build Dockerfile

```bash
./build-analyse.sh
```

This builds an image with R configured with the necessary machine learning libraries to analyse the data

We then run the analysis automatically using

```bash
./launch-analysis.sh
```

or we can do it interactively as well, by first launching the image

```bash
./launch-analysis-interactive.sh
```

then navigating to the Rserver at the relevant ip address and running the code manually

# Visualising Output
TCS

# Required steps for Automation
In order to automate the web scraping process we do the following

1) Schedule Virtual Machine start up /shutdown 
2) Configure a cron job on linux host

## Schedule Virtual Machine start up/ shutdown
Follow instructures here
https://docs.microsoft.com/en-us/azure/automation/automation-solution-vm-management#modify-the-startup-and-shutdown-schedules

Set the machine to start at 12:00 AM and shutdown at 01:00 AM

## Configure a cron job on linux host

Bring up the crontab for users with root permissions (so we don't have to prefix commands with sudo)

```bash
sudo crontab -e
```

Then add the following line to the file.

```bash
10 00 * * * docker stop $(docker ps -aq) && rm -rf /home/d14xj1/repos/trends-in-data-science/.rstudio && cd /home/d14xj1/repos/trends-in-data-science && docker-compose up -d --force-recreate
30 01 * * * docker stop $(docker ps -aq) && rm -rf /home/d14xj1/repos/trends-in-data-science/.rstudio && cd /home/d14xj1/repos/trends-in-data-science && ./launch-analyse.sh
```

Then at 12:10 AM the job will run. The job first changes directory to the location of the docker file, and then runs docker-compose.
It was necessary to use the --force-recreate option, otherwise somethings the rstudio container doesn't always start.




