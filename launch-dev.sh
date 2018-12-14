#!/bin/sh
#sudo docker run -d \
#-p 443:8787 \
#-v $(pwd):/home/rstudio/ \
#-e PASSWORD=letmein \
#tonyjward/rstudio:latestbuild

sudo docker run --rm -d -p 80:8787 -e PASSWORD=letmein -v $(pwd):/home/rstudio tonyjward/rstudio:latestbuild

