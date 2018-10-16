# trends-in-data-science
The objective of this project is to monitor the trends in data science job opportunities. We achieve this through scraping of the jobserve website. 

# Build Dockerfile with R and required libraries installed

```bash
docker build -t tonyjward/rstudio .
```

We only need to do this once

# Docker Compose

We use docker compose to launch our two services (Selenium and RStudio Server)

```bash
docker-compose up -d
```

Then navigate to 
* localhost:80 to view RStudio or
* localhost:4445 to view Selenium Browser





