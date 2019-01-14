#!/bin/sh
sudo docker stop $(sudo docker ps -aq) && \
sudo docker-compose -f docker-compose-interactive.yml up --force-recreate -d
