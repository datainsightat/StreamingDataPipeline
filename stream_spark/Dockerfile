#https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md#prerequisites
#https://github.com/theia-ide/theia-apps
#https://hadooptutorials.info/2020/10/11/part-4-install-spark-2/

FROM ubuntu:18.04 as common

#Spark
EXPOSE 8080 7077 8081 7000 8888

ENV DEBIAN_FRONTEND noninteractive

ENV JAVA_VERSION=8
ENV JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:${PATH}"

ENV SCALA_VERSION="2.12.14"
ENV SPARK_VERSION="3.2.0"
ENV SPARK_HADOOP_VERSION="3.2"
ENV POSTGRES_JDBC_VERSION="42.3.1"

ENV SPARK_HOME /opt/spark
ENV PATH="$SPARK_HOME/bin:${PATH}"
ENV PATH="$SPARK_HOME/sbin:${PATH}"
ENV PYSPARK_PYTHON=/usr/bin/python3

ENV SPARK_MASTER_HOST=spark
ENV SPARK_MASTER_PORT=7077
ENV SPARK_MASTER_WEBUI_PORT=8080
ENV SPARK_WORKER_PORT=7000
ENV SPARK_WORKLOAD="master"

ENV SSH_USER="root"

ENV JUPYTERLAB_VERSION="3.2.1"

###########
# GENERAL #
###########

RUN apt-get update && \
    apt-get install -y wget openssh-server openssh-client net-tools

########
# JAVA #
########

RUN apt-get update && \
    apt-get -y install openjdk-$JAVA_VERSION-jdk openjdk-$JAVA_VERSION-jdk-headless

#########
# SCALA #
#########

RUN wget https://scala-lang.org/files/archive/scala-${SCALA_VERSION}.deb && \
    apt-get install -y ./scala-${SCALA_VERSION}.deb && \
    rm -rf scala-${SCALA_VERSION}.deb /var/lib/apt/lists/*

#########
# SPARK #
#########

#https://phoenixnap.com/kb/install-spark-on-ubuntu
RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz && \
    tar xvf spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz && \
    mv spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION/ $SPARK_HOME && \
    rm spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz

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

RUN pip3 install pyspark==${SPARK_VERSION} hdfs python-dotenv

############
# POSTGRES #
############

RUN wget https://jdbc.postgresql.org/download/postgresql-$POSTGRES_JDBC_VERSION.jar && \
    mv postgresql-$POSTGRES_JDBC_VERSION.jar $SPARK_HOME/jars

###################
# Jupyter Kernels #
###################

# -- Layer: JupyterLab + Python kernel for PySpark

RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev && \
    pip3 install --upgrade pip && \
    pip3 install wget==3.2 pyspark==${SPARK_VERSION} jupyterlab==${JUPYTERLAB_VERSION}

##########
# FINISH #
##########

# Create SSH key

RUN /etc/init.d/ssh start

ADD ssh/config root/.ssh/config

RUN ssh-keygen -q -t rsa -P '' -f $SSH_USER/.ssh/id_rsa && \
    cat $SSH_USER/.ssh/id_rsa.pub >> $SSH_USER/.ssh/authorized_keys && \
    chmod 0600 $SSH_USER/.ssh/authorized_keys

ADD docker_start.sh /

#Run at container start
CMD ["bin/bash","docker_start.sh"]