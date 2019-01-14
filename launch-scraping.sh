#!/bin/sh
sudo docker stop $(sudo docker ps -aq) && \
sudo docker-compose up --force-recreate -d
