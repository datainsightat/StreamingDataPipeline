# Streaming Data Pipeline

This project provides an WebIDE to interact with Spark and Hadoop/Hive.

# Cluster

## Architecture

![cluster Architectue](resources/img/Architecture.drawio.svg)

## Setup

Build the docker containers using the Dockerfiles provided in the subfolders of this repo.

    $ docker build -t stream_hive stream_hive/.
    $ docker build -t stream_spark stream_spark/.
    $ docker build -t stream_kafka stream_kafka/.

Create external volume

    $ docker volume create --name=stream_workspace

## Run Cluster

    $ docker-compose rm -svf
    $ docker-compose up

    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS           PORTS                                                                                                                                              NAMES
49664c1e8d3e        stream_kafka        "/opt/kafka/bin/kafk…"   16 minutes ago      Up 16 minutes       0.0.0.0:9092->9092/tcp                                                                                                                             broker_0
a754c6c6ac4f        stream_kafka        "/opt/kafka/bin/zook…"   16 minutes ago      Up 16 minutes       0.0.0.0:2181->2181/tcp, 9092/tcp                                                                                                                   zookeeper
395a411b500b        stream_hive         "bin/bash docker_sta…"   16 minutes ago      Up 16 minutes       0.0.0.0:5249->5249/tcp, 5259/tcp, 0.0.0.0:5349->5349/tcp, 9083/tcp, 0.0.0.0:9870->9870/tcp, 0.0.0.0:54310-54311->54310-54311/tcp, 9999-10000/tcp   hdfs

# Operation

## Receive Datastream

    $ docker container exec -it broker_0 /bin/bash
    broker_0$ cd /home/
    broker_0$ git clone https://github.com/datainsightat/StreamingDataPipeline_Code.git
    broker_0$ cd /StreamingDataPipeline_Code/dna_spaces
    broker_0$ python3 python3 dna_spaces_producer.py

    $ docker container exec -it broker_0 /bin/bash
    broker_0$ cd /home/StreamingDataPipeline_Code/dna_spaces
    broker_0$ python3 python3 dna_spaces_consumer.py


















## Access the Tools

### service Ports
|Container|Tool|URL|User|Password|
|-|-|-|-|-|
|hadoop|Default FS|http://hive:54310|||
|pg_container|Postgres DB|http://pg_container:5432|root|root|
|spark|Spark Master|http://spark:7077|||

### Web GUI Ports
|Container|Tool|URL|User|Password|
|-|-|-|-|-|
|theia|Theia IDE|http://localhost:3000|||
|jupyter|Jupyter Lab|http://localhost:8888|||
|jupyter|sparkr-notebook application UI|http://localhost:4040|||
|hadoop|NameNode|http://localhost:9870|||
|hadoop|Yarn RM web application|http://localhost:5349|||
|spark|Spark Master GUI|http://localhost:8080|||
|spark|Spark Worker GUI|http://localhost:8081|||
|pgadmin4_container|Postgres GUI|http://localhost:5050|admin@admin.com|root|

## Shut down Cluster

    $ docker-compose down

## Examples

Get some usage examples from [this](https://github.com/datainsightat/scala_examples.git) git repo.

# Postgres

## Create Server

[Postgres GUI](http://localhost:5432) > Add New Server:

    General:
        Name: newserver
    Connection:
        Host: pg_container
        Username: root
        Password: root

# Hadoop

## Browse hdfs

    $ docker container exec hadoop hdfs dfs -ls /

## Create directory

    $ docker container exec hadoop hdfs dfs -mkdir /data

## Upload file to hdfs

    $ docker cp file.csv hadoop:/
    $ docker container exec hadoop hdfs dfs -put file.csv /data/
    $ docker container exec hadoop rm file.csv

# Hive

## Create hive Table

    $ docker container exec -it hive bash
    hive$ hive
    hive> create table if not exists employee (id string, name string, dept string);
    hive> show tables;
    hive> insert into employee values("1","Allen","IT");
    hive> select * from employee;

# Examples

You can find some templates [here](https://github.com/datainsightat/scala_examples)

# 2DO

* Create Postgres Docker
* Split Spark, Theia, Jupyter > Base / Service
* Hadoop GUI cannot upload csv
* Environment file
<<<<<<< HEAD
=======
* Theia: R extension for visual studio code, r debugger, code runner
* Mongo
>>>>>>> 3847c4b571dae4934773cdce81e8fd9da782bbb3
