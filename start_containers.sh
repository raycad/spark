#!/bin/bash

# The 1st argument (CREATE_SPARK_MASTER) is set to YES if you want to create a spark master, the default is YES
# The 2nd argument (SPARK_MASTER_IP) is the spark master ip (the ip of the host machine of the spark master docker container), the default is spark-master
# The 3rd argument (SPARK_WORKER_NUMBER) is the number of workers you want to create, the default is 2

# The default spark cluster has 3 nodes includes 1 master and 2 workers

# Set the default CREATE_HADOOP_MASTER is NO
CREATE_SPARK_MASTER=${1:-YES}
echo "CREATE_SPARK_MASTER =" $CREATE_SPARK_MASTER

# Set the default spark master ip is spark-master in the spark network
SPARK_MASTER_IP=${2:-spark-master}
echo "SPARK_MASTER_IP =" $SPARK_MASTER_IP

# Set the default spark worker number is 2
SPARK_WORKER_NUMBER=${3:-2}
echo "SPARK_WORKER_NUMBER =" $SPARK_WORKER_NUMBER

if [[ ${CREATE_SPARK_MASTER} == "YES" ]]; then
	# Start spark-master container
	sudo docker rm -f spark-master &> /dev/null
	echo "Start spark-master container in the spark network..."
	sudo docker run -itd \
					--net=spark \
					-p 6066:6066 -p 7077:7077 -p 8080:8080 \
					-e IS_SPARK_MASTER=YES \
					--name spark-master \
					--hostname spark-master \
					seedotech/spark:2.4.0 &> /dev/null
fi

# Start spark-worker containers
i=1
while [ $i -lt $((SPARK_WORKER_NUMBER+1)) ]
do
	sudo docker rm -f spark-worker$i &> /dev/null
	echo "Start spark-worker$i container..."

	# To avoid port conflict in the same host machine, the 1st hadoop slave port is mapped to 50075. From the other slaves the port is mapped to 2007$i
	if [[ $i == 1 ]]; then
		sudo docker run -itd \
						--net=spark \
						-p 8081:8081 \
						-e IS_SPARK_MASTER=NO \
						-e SPARK_MASTER_IP=$SPARK_MASTER_IP \
						--name spark-worker$i \
						--hostname spark-worker$i \
						seedotech/spark:2.4.0 &> /dev/null
	else
		sudo docker run -itd \
						--net=spark \
						-p 4008$i:8081 \
						-e IS_SPARK_MASTER=NO \
						-e SPARK_MASTER_IP=$SPARK_MASTER_IP \
						--name spark-worker$i \
						--hostname spark-worker$i \
						seedotech/spark:2.4.0 &> /dev/null
	fi
						
	i=$(($i+1))
done 