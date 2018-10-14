#!/bin/sh
docker run -d --rm -e PASSWORD=letmein -p 8787:8787 -v /$(pwd)/RCode:/home/rstudio/RCode --link=mychromeserver:mychromeserver tonyjward/rstudio


