#!/bin/sh
rm -rf /home/d14xj1/repos/trends-in-data-science/.rstudio && \ # clear Rstudio cache
sudo docker run --rm -d -p 80:8787 -e PASSWORD=letmein  -v $(pwd):/home/rstudio tonyjward/rstudio:analyse

