#https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md#prerequisites
#https://github.com/theia-ide/theia-apps
#https://hadooptutorials.info/2020/10/11/part-4-install-spark-2/

FROM ubuntu:18.04 as common

#Spark
#EXPOSE 8888 8080 7077 8081 7000

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV DEBIAN_FRONTEND noninteractive

ENV JAVA_VERSION=8
ENV JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:${PATH}"

#ENV SCALA_VERSION="2.12.14"
#ENV KAFKA_MAJOR_VERSION="3.0.0"
#Kafka Python is compatible Kafka 2.4
#https://kafka-python.readthedocs.io/en/master/
ENV KAFKA_MAJOR_VERSION="2.4.1"
ENV KAFKA_MINOR_VERSION="2.12"
ENV KAFKA_HOME=/opt/kafka
ENV PATH="$KAFKA_HOME/bin:${PATH}"
ENV PATH="$KAFKA_HOME/sbin:${PATH}"

#Python Path
ENV PATH="/usr/bin/python3:${PATH}"

ENV ZOOKEEPER_HOME $KAFKA_HOME/data/zookeeper

ENV SCALA_VERSION="2.12.14"
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
    apt-get install -y wget curl openssh-server openssh-client git net-tools

########
# JAVA #
########

RUN apt-get update && \
    apt-get -y install openjdk-$JAVA_VERSION-jdk openjdk-$JAVA_VERSION-jdk-headless && \
    ln -s /lib64/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2

#########
# SCALA #
#########

RUN wget https://scala-lang.org/files/archive/scala-${SCALA_VERSION}.deb && \
    apt-get install -y ./scala-${SCALA_VERSION}.deb && \
    rm -rf scala-${SCALA_VERSION}.deb /var/lib/apt/lists/*

##########
# PYTHON #
##########

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get install -y python python-dev python-pip \
    && apt-get install -y python3.8 python3-dev python3-pip python3-pycurl\
    && apt-get remove -y software-properties-common \
    && python -m pip install --upgrade pip --user \
    && python3.8 -m pip install --upgrade pip --user \
    && pip3 install python-language-server flake8 autopep8

RUN pip3 install kafka-python pyspark==${SPARK_VERSION} hdfs python-dotenv

#########
# KAFKA #
#########

#https://phoenixnap.com/kb/install-spark-on-ubuntu
RUN wget https://archive.apache.org/dist/kafka/$KAFKA_MAJOR_VERSION/kafka_$KAFKA_MINOR_VERSION-$KAFKA_MAJOR_VERSION.tgz && \
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

##########
# FINISH #
##########

RUN mkdir $KAFKA_HOME/data && \
    mkdir $KAFKA_HOME/data/kafka && \
    mkdir $KAFKA_HOME/data/zookeeper && \
    mkdir /opt/connectors

# Create SSH key

RUN /etc/init.d/ssh start

ADD ssh/config root/.ssh/config

RUN ssh-keygen -q -t rsa -P '' -f $SSH_USER/.ssh/id_rsa && \
    cat $SSH_USER/.ssh/id_rsa.pub >> $SSH_USER/.ssh/authorized_keys && \
    chmod 0600 $SSH_USER/.ssh/authorized_keys

ADD docker_start.sh /

#Run at container start
CMD ["bin/bash","docker_start.sh"]