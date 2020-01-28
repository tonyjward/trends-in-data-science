#!/bin/sh
sudo docker build -f DockerfileAnalyseInteractive -t tonyjward/trends-in-data-science:analyseinteractive . && \
sudo docker build -f DockerfileAnalyse -t tonyjward/trends-in-data-science:analyse .
