#!/bin/bash

# The default spark cluster has 3 nodes includes 1 master and 2 workers

# Set the default spark worker number is 2
SPARK_WORKER_NUMBER=${1:-2}
echo "SPARK_WORKER_NUMBER =" $SPARK_WORKER_NUMBER

# Set the default spark master ip is localhost
SPARK_MASTER_IP=${1:-localhost}
echo "SPARK_MASTER_IP =" $SPARK_MASTER_IP

# Start spark-master container
sudo docker rm -f spark-master &> /dev/null
echo "Start spark-master container in the spark network..."
sudo docker run -itd \
                --net=spark \
                --name spark-master \
                --hostname spark-master \
                seedotech/spark:2.4.0 &> /dev/null

# Start spark-worker container
i=1
while [ $i -lt $((SPARK_WORKER_NUMBER+1)) ]
do
	sudo docker rm -f spark-worker$i &> /dev/null
	echo "Start spark-worker$i container..."
	sudo docker run -itd \
	                --net=spark \
					-e SPARK_MASTER_IP=$SPARK_MASTER_IP \
	                --name spark-worker$i \
	                --hostname spark-worker$i \
	                seedotech/spark:2.4.0 &> /dev/null
	i=$(($i+1))
done 

# Get into the spark master container
sudo docker exec -it spark-master bash