#!/bin/sh
sudo docker stop $(sudo docker ps -aq)
sudo docker run -p 80:3838 -d -v $(pwd)/Shiny:/srv/shiny-server/ tonyjward/rstudio:shiny 

