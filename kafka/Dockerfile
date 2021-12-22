#https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md#prerequisites
#https://github.com/theia-ide/theia-apps
#https://hadooptutorials.info/2020/10/11/part-4-install-spark-2/

FROM ubuntu:20.04 as common

#Spark
EXPOSE 8080 7077 8081 7000

ENV DEBIAN_FRONTEND noninteractive

ENV JAVA_VERSION=8
ENV JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:${PATH}"

ENV SCALA_VERSION="2.12.14"
#ENV KAFKA_MAJOR_VERSION="3.0.0"
ENV KAFKA_MAJOR_VERSION="2.8.1"
ENV KAFKA_MINOR_VERSION="2.12"
ENV KAFKA_HOME=/opt/kafka
ENV PATH="$KAFKA_HOME/bin:${PATH}"
ENV PATH="$KAFKA_HOME/sbin:${PATH}"

ENV ZOOKEEPER_HOME $KAFKA_HOME/data/zookeeper

# ENV FLUME_VERSION="1.9.0"
# ENV FLUME_HOME=/opt/flume
# ENV PATH="$FLUME_HOME/bin:${PATH}"

# ENV SPARK_VERSION="3.2.0"
# ENV SPARK_HADOOP_VERSION="3.2"
# ENV POSTGRES_JDBC_VERSION="42.3.1"

# ENV SPARK_HOME /opt/spark
# ENV PATH="$SPARK_HOME/bin:${PATH}"
# ENV PATH="$SPARK_HOME/sbin:${PATH}"
# ENV PYSPARK_PYTHON=/usr/bin/python3

# ENV SPARK_MASTER_HOST=spark
# ENV SPARK_MASTER_PORT=7077
# ENV SPARK_MASTER_WEBUI_PORT=8080
# ENV SPARK_WORKER_PORT=7000
# ENV SPARK_WORKLOAD="master"

# ENV SSH_USER="root"

###########
# GENERAL #
###########

RUN apt-get update && \
    apt-get install -y wget openssh-server openssh-client net-tools maven nano curl git

########
# JAVA #
########

RUN apt-get update && \
    apt-get -y install openjdk-$JAVA_VERSION-jdk openjdk-$JAVA_VERSION-jdk-headless

##########
# PYTHON #
##########

RUN apt-get update -y \
    && apt-get install -y software-properties-common \
    #&& add-apt-repository -y ppa:deadsnakes/ppa \
    #&& apt-get install -y python-dev python-pip \
    && apt-get install -y python3.8 python3-dev python3-pip libpq-dev \
    #&& apt-get remove -y software-properties-common \
    #&& python -m pip install --upgrade pip --user \
    && python3.8 -m pip install --upgrade pip --user
    #&& pip3 install python-language-server flake8 autopep8 pyspark==${SPARK_VERSION} pandas psycopg2
    #python3-psycopg2 libpq-dev 

#########
# KAFKA #
#########

#https://phoenixnap.com/kb/install-spark-on-ubuntu
RUN wget https://dlcdn.apache.org/kafka/$KAFKA_MAJOR_VERSION/kafka_$KAFKA_MINOR_VERSION-$KAFKA_MAJOR_VERSION.tgz && \
    tar xvf kafka_$KAFKA_MINOR_VERSION-$KAFKA_MAJOR_VERSION.tgz && \
    mv kafka_$KAFKA_MINOR_VERSION-$KAFKA_MAJOR_VERSION/ $KAFKA_HOME && \
    rm kafka_$KAFKA_MINOR_VERSION-$KAFKA_MAJOR_VERSION.tgz

ADD kafka/server.properties $KAFKA_HOME/config/server.properties

#############
# ZOOKEEPER #
#############

ADD zookeeper/zookeeper.properties $KAFKA_HOME/config/zookeeper.properties

####################
# KAFKA Connectors #
####################

ADD kafka/server.properties $KAFKA_HOME/config/connect-standalone.properties

#########
# FLUME #
#########

# #https://towardsdatascience.com/apache-kafka-and-flume-installation-guide-import-data-from-kafka-to-hdfs-c908b0df034c
# RUN wget https://dlcdn.apache.org/flume/$FLUME_VERSION/apache-flume-$FLUME_VERSION-bin.tar.gz && \
#     tar xvf apache-flume-$FLUME_VERSION-bin.tar.gz && \
#     mv apache-flume-$FLUME_VERSION-bin/ $FLUME_HOME && \
#     rm apache-flume-$FLUME_VERSION-bin.tar.gz

# ADD flume/flume.conf $FLUME_HOME/conf/flume.conf

##########
# FINISH #
##########

RUN mkdir $KAFKA_HOME/data && \
    mkdir $KAFKA_HOME/data/kafka && \
    mkdir $KAFKA_HOME/data/zookeeper && \
    mkdir /opt/connectors

# Create SSH key

# RUN /etc/init.d/ssh start

# ADD ssh/config root/.ssh/config

# RUN ssh-keygen -q -t rsa -P '' -f $SSH_USER/.ssh/id_rsa && \
#     cat $SSH_USER/.ssh/id_rsa.pub >> $SSH_USER/.ssh/authorized_keys && \
#     chmod 0600 $SSH_USER/.ssh/authorized_keys

ADD docker_start.sh /

#Run at container start
CMD ["bin/bash","docker_start.sh"]