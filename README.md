# Trends in Data Science
The main goal of this project is to monitor the trends in the UK data science job market. I originally started this project in 2018 to help me decide whether to learn Python or not. I now use it as motiviation too keep learning Python! 

#### -- Project Status: Completed

### Methods Used
* Web Scraping
* Data Visualization
* Topic Modelling (LDA)
* Web Application Development & Hosting
* Task Scheduling

### Technologies
* R 
* Shiny
* Selenium
* Docker
* Linux
* Azure

## Project Description
The data source for this project is the [jobserve website](https://www.jobserve.com/gb/en/Job-Search/). On a schedule (daily) we perform the following
1. Scrape all 'Data Scientist' jobs from jobserve
2. Pre-process data, produce visualisations and build topic models on the job description
3. Present output using an [interactive web application](http://apps.statcore.co.uk/)

The three distinct tasks each have their own folder 

* Scraping 
* Analyse 
* Shiny

Each task has its own docker image, and is launched on a schedule using cron.

For the Shiny App we use Nginx as a reverse proxy and to encrypt all traffic using SSL. The Nginx folder contains the required config file.

Lastly there are a number of helper shell scripts in the root directory which automate some of the repetitive tasks (docker run, docker compose up etc).

## Getting Started

Follow setup [instructions](https://github.com/tonyjward/trends-in-data-science/blob/master/Setup.md)

## Featured Write-up
* Medium Article (TBC)

## Contact
* tony@statcore.co.uk





