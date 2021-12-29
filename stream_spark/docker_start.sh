#!/bin/sh

/etc/init.d/ssh start

#Spark
#$SPARK_HOME/sbin/start-master.sh
#$SPARK_HOME/sbin/start-slave.sh spark://localhost:7077
$SPARK_HOME/sbin/start-all.sh

# #Jupyter
# jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=

#Keep Container alive Test
tail -f /dev/null