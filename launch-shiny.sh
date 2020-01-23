#!/bin/sh
sudo docker-compose -f docker-compose-shiny-nginx.yml down
sudo docker-compose -f docker-compose-shiny-nginx.yml up --force-recreate -d
