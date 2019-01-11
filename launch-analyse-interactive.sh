#!/bin/sh
sudo docker stop $(sudo docker ps -aq) && \
sudo docker run --rm -d -p 80:8787 -e PASSWORD=letmein -v $(pwd):/home/rstudio tonyjward/rstudio:analyseinteractive

