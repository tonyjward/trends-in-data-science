FROM rocker/tidyverse:3.5

RUN R -e "install.packages(c('XML'))"

RUN R -e 'devtools::install_version("binman", version = "0.1.0", repos = "https://cran.uni-muenster.de/")'

RUN R -e 'devtools::install_version("wdman", version = "0.2.2", repos = "https://cran.uni-muenster.de/")'

RUN R -e 'devtools::install_version("RSelenium", version = "1.7.1", repos = "https://cran.uni-muenster.de/")'

RUN apt-get update && apt-get install -y nano
