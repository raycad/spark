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