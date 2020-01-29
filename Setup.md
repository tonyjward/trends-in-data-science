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
This starts one service - an RStudio server with several data analysis and topic modelling libraries installed. The RStudio image has an entry point set to 'Analyse/entrypointAnalyse.R'- i.e this is the code that gets run upon startup of the service. What 'Analyse/entrypointAnalyse.R' does is to run the following codes stores in Analyse/RCode
* 00_LibrariesAndPackages.R
* 01_ReadRawData.R
* 02_ManipulateData.R
* 03_DocumentTermMatrix.R
* 04_HyperparameterTuning.R
* 05_FinalModelTraining.R
* 06_Shiny_InspectData.R
* 07_Shiny_TopicModelling.R
* 08_Shiny_TimeSeries.R

Documentation of the individual scripts are provided at the top of each script. At a high level the process reads in the data from Scraping/ROutput, cleans the data and trains a number of topic models. The output is saved in Shiny/RData which is then picked up by the shiny application

Modifying file R script "Analyse/entrypointAnalyse.r" controls which aspects of the data analysis pipelines are run. Typically the user might want to comment out "04_HyperparameterTuning.R" since it is not necessary to tune the hyperparemeters every day.

### launch-shiny.sh
This starts two services 
1) A Nginx reverse proxy
2) A Shiny application

The nginx service acts as a reverse proxy, and allows us to encrpyt traffic to the shiny application. You will need to place your ssl certificate (.pem and .key files) here /home/ubuntu/ssl:/ssl/. Excellent instructions can be found here https://business-science.github.io/shiny-production-with-aws-book/https-nginx-docker-compose.html

The shiny application files can be found here in the Shiny directory. Since this is a big app, we use shiny modules to separate our code into manageable chunks - these can be found in Shiny/modules.

## Logging
Logs from the three processes can be found in 
* Scraping/Logs
* Analyse/Logs
* Shiny/Logs

By default Shiny deletes the logs automatically. If you want to change this behaviour modify Shiny/shiny-server.conf and uncomment out 

```
preserve_logs true;
```
Periodically you should clear out these log folders.

## Debugging/Development
If you wanted to debug or develop the code using an Rstudio Server session this is possible by running

```
./launch-scraping-interactive.sh
```
or 
```
./launch-analyse-interactive.sh
```
Then navigate to <ip-address>:3838 and log on to the Rstudio server instance. I highly recommend configuring the firewall so that only your ip address can access port 3838. Also please note that I haven't set up SSL encrptyion on the RStudio Server and so you may compromise the security of your sever by doing this. A much better approach would be to clone the repo to a local machine and run RStudio locally. Then when you have finished development push your changes to the repo and pick up the changes on the remote host.
