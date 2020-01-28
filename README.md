# Trends in data science
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

## Project Description
The data source for this project is the [jobserve website](https://www.jobserve.com/gb/en/Job-Search/). On a schedule (daily) we perform the following
1. Scrape all 'Data Scientist' jobs from jobserve
2. Pre-process data, produce visualisations and build topic models on the job description
3. Present output at http://apps.statcore.co.uk/

The three distinct tasks each have their own folder 

* Scraping - collects the data
* Analyse - data processing, visualisation and machine learning
* Shiny - web application 

Each task has its own docker image, and is launched on a schedule using cron.

We containerise the three tasks using separate docker images. 

In addition we have
* Docker - used to build docker images
* Nginx - configuration file for reverse proxy

Lastly there are a number of helper shell scripts in the root directory which automate some of the repetitive tasks (docker run, docker compose up etc)

## Getting Started

Follow setup [instructions](Link to file)

## Featured Notebooks/Analysis/Deliverables
* Medium Article (TBC)

## Contact
* tony@statcore.co.uk





