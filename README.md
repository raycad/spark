# Apache Spark

### 1. Pull the image
```
$ sudo docker pull seedotech/spark:2.4.0
```

### 2. Create a hadoop network
```
$ sudo docker network create --driver=bridge spark
```

### 3. Custom commands

This image contains a script named `start_spark.sh` (included in the PATH). This script is used to initialize the master and the workers.

#### 4. Start a spark master

To start a master run the following command:

```sh
$ start_spark.sh master
```

#### 5. Start a spark worker

To start a worker run the following command:

```sh
$ start_spark.sh worker [MASTER]
```

sudo docker build -t seedotech/spark:2.4.0 .