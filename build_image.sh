#!/bin/bash

echo -e "\nBuilding Spark 2.4.0 cluster docker image...\n"
sudo docker build -t seedotech/spark:2.4.0 .