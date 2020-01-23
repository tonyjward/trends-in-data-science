#!/bin/sh
# sudo docker stop trendsindatascience_selenium_1
sudo docker-compose -f docker-compose-scraping.yml down
rm -rf /home/d14xj1/repos/trends-in-data-science/.rstudio && \ # clear Rstudio cache
sudo docker run --rm -d --name rstudio_analyse -v $(pwd):/home/rstudio tonyjward/rstudio:analyse

