#!/bin/sh
sudo docker stop $(sudo docker ps -aq)
sudo docker run -p 443:3838 -d -v $(pwd)/App:/srv/shiny-server/ tonyjward/rstudio:shiny 

