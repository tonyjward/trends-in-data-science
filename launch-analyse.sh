#!/bin/sh
rm -rf /home/d14xj1/repos/trends-in-data-science/.rstudio && \ # clear Rstudio cache
sudo docker run --rm -d -v $(pwd):/home/rstudio tonyjward/rstudio:analyse

