# Download ubuntu base image 18.10
FROM ubuntu:18.10
LABEL Nguyen Truong Duong<seedotech@gmail.com>

WORKDIR /root

# Version
ENV SPARK_VERSION=2.4.0
ENV HADOOP_VERSION=2.7

# Set Spark Home
ENV SPARK_HOME=/usr/local/spark-$SPARK_VERSION
ENV PATH=$PATH:$SPARK_HOME/bin

# Set IS_SPARK_MASTER is YES if the container is master, otherwise, set it to be NO
ENV IS_SPARK_MASTER NO
# Set the SPARK_MASTER_IP to the IP of the host machine of the Spark Master docker container. Default is localhost
ENV SPARK_MASTER_IP localhost

# Install dependencies
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
  apt-get install -y openssh-server openjdk-8-jdk scala python python3 wget nano iputils-ping net-tools netcat telnet

# Install Spark
RUN wget https://www-us.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz && \
    tar -xzvf spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz && \
    mv spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION $SPARK_HOME && \
    rm spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz

# ADD bootstrap/spark-env.sh $SPARK_HOME/conf/spark-env.sh

# Copy start script
ADD bootstrap/start_spark.sh /root/start_spark.sh

# Ports
EXPOSE 6066 7077 8080 8081

# Set environment variables for other users
RUN echo -e "export SPARK_HOME=$SPARK_HOME\nexport PATH=$PATH:$SPARK_HOME/bin" >> /etc/bash.bashrc

# Start services
CMD [ "sh", "-c", "service ssh start; /root/start_spark.sh; /bin/bash"]