#!/bin/sh
rm -rf /home/d14xj1/repos/trends-in-data-science/.rstudio && \ # clear Rstudio cache
sudo docker-compose -f docker-compose-scraping.yml up --force-recreate -d
