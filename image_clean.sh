#!/bin/bash

docker builder prune -f
docker container prune -f 
docker image prune -f 
docker system prune -a --volumes 
