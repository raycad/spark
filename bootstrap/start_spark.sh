#!/usr/bin/env bash

# Start SSH service
service ssh start

# Set IS_SPARK_MASTER with the value of the 1st parameter to the script. If the 1st parameter is not entered, set it to NO
IS_SPARK_MASTER=${IS_SPARK_MASTER:-NO}
echo "IS_SPARK_MASTER =" $IS_SPARK_MASTER

# Set the default spark master ip is localhost
SPARK_MASTER_IP=${SPARK_MASTER_IP:-localhost}
echo "SPARK_MASTER_IP =" $SPARK_MASTER_IP

if [[ "${IS_SPARK_MASTER}" = 'YES' ]]; then
  # Start Spark Master
  echo "Starting Spark Master..."
  spark-class org.apache.spark.deploy.master.Master -h $(hostname)
else [[ "${IS_SPARK_MASTER}" = 'NO' ]]; then
  # Wait for the Spark Master to start
  while ! nc -z $SPARK_MASTER_IP 7077 ; do
    echo "Waiting for the Spark Master to start..."
    sleep 2;
  done;
  # Start Spark Worker
  echo "Starting Spark Worker..."
  spark-class org.apache.spark.deploy.worker.Worker spark://$SPARK_MASTER_IP:7077
fi