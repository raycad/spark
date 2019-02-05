# Apache Spark Cluster

### 1. Pull the image
```
$ sudo docker pull seedotech/spark:2.4.0
```

### 2. Create a spark network
```
$ sudo docker network create --driver=bridge spark
```

### 3. Create and run docker containers

```sh
# The 1st argument (CREATE_SPARK_MASTER) is set to YES if you want to create a spark master, the default is YES
# The 2nd argument (SPARK_MASTER_IP) is the spark master ip (the ip of the host machine of the spark master docker container), the default is spark-master
# The 3rd argument (SPARK_WORKER_NUMBER) is the number of workers you want to create, the default is 2

# The default spark cluster has 3 nodes includes 1 master and 2 workers
$ start_containers.sh

# If you want to create 1 spark worker in other machine (assume that the ip of the spark master is 192.168.1.10), you can do like that:
$ start_containers.sh NO 192.168.1.10 1
```

### 4. Get into the spark master container
```
$ sudo docker exec -it spark-master bash
```

### 5. Monitor spark cluster

Access to the http://spark-master:8080 to monitor the spark cluster.

### 6. Run spark application with hadoop
#### 6.1. Create a shared network for hadoop cluster and spark cluster be able to connect together
```
$ sudo docker network create --driver=bridge spark-hadoop
``` 

#### 6.2. Create a hadoop cluster and use the spark-hadoop network
```
e.g
$ sudo docker run -itd \
					--net=spark-hadoop \
					-p 50070:50070 \
					-p 8088:8088 \
					-e HADOOP_SLAVE_NUMBER=$HADOOP_SLAVE_NUMBER \
					--name hadoop-master \
					--hostname hadoop-master \
					seedotech/hadoop:2.9.2 &> /dev/null
```

#### 6.3. Create a spark cluster and use the spark-hadoop network
```
e.g
$ sudo docker run -itd \
					--net=spark-hadoop \
					-p 6066:6066 -p 7077:7077 -p 8080:8080 \
					-e IS_SPARK_MASTER=YES \
					--name spark-master \
					--hostname spark-master \
					seedotech/spark:2.4.0 &> /dev/null
```

#### 6.4. Execute spark application in other machine
```
$ spark-submit --class com.seedotech.spark.SparkJavaApp --master spark://spark-master:7077 --deploy-mode cluster hdfs://hadoop-master:9000/apps/spark/spark-java-1.0.jar hdfs://hadoop-master:9000/apps/spark/demo.txt hdfs://hadoop-master:9000/apps/spark/out
```

#### 6.5. Debug spark application

Use logs to trace bugs/issues
```
$ sudo docker logs -f spark-master
$ sudo docker logs -f spark-worker1
```

**NOTE**: you might run failed in the second time, it's because of the folder **hdfs://hadoop-master:9000/apps/spark/out** has been created. To run successfully please remove it before running (use http://localhost:50070/explorer.html to upload/delete folders/files).
