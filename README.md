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
The data source for this project is the [jobserve website](https://www.jobserve.com/gb/en/Job-Search/). Each day we scrape the website using the search term 'Data Scientist'. Once we have imported and cleaned the data, several visualisations and topic models are produced. These are then presented in here http://apps.statcore.co.uk/

## Project Struture

There are three distinct tasks. Each task has its own folder and docker image.

* Scraping - collects the data
* Analyse - data processing, visualisation and machine learning
* Shiny - web application 

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





