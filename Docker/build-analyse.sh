#!/bin/sh
sudo docker build -f DockerfileAnalyseInteractive -t tonyjward/rstudio:analyseinteractive . && \
sudo docker build -f DockerfileAnalyse -t tonyjward/rstudio:analyse .
