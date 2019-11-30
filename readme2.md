## COMMANDS SUMMARY
# Comandos

#### Build and Run application
``` 
docker-compose up  -d
``` 
#### Generates collector image
```
docker build -t netflow_collector -f Dockerfile.collector .
```
#### Run collector image 
```
docker run -d -p 2055:2055 --name containerc netflow_collector
```

#### Collect collector IP 
```
collectorIp=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' containerc)
```
#### Generates Data Export containers

#### Build probes Image
```
docker build  --build-arg collectorIpArg=collectorIp  -t netflow_data_export -f Dockerfile.dataExport . 
```

#### Take PID of application container
```
PID1=$(docker inspect --format '{{.State.Pid}}' dockernetflow_wordpress_1)
```
```
PID2=$(docker inspect --format '{{.State.Pid}}' dockernetflow_db_1)
```
####Generates probe1 taking PID of wordpress
##### Wordpress probe
```
docker run --rm -it -d --privileged --pid="container:dockernetflow_wordpress_1"   --name containera  netflow_data_export  \bin\bash
``` 
##### MySql (db) probe
```
docker run --rm -it -d --privileged --pid="container:dockernetflow_db_1"   --name containerb  netflow_data_export  \bin\bash
``` 

### ALL COMMANDS
```
docker-compose up  -d
docker build -t netflow_collector -f Dockerfile.collector .
docker run -d -p 2055:2055 --name containerc netflow_collector
collectorIp=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' containerc)
docker build  --build-arg collectorIpArg=collectorIp  -t netflow_data_export -f Dockerfile.dataExport . 
docker run --rm -it -d --privileged --pid="container:dockernetflow_wordpress_1"   --name containera  netflow_data_export  \bin\bash
docker run --rm -it -d --privileged --pid="container:dockernetflow_db_1"   --name containerb  netflow_data_export  \bin\bash
```

#### DELETING containers and Images


##### Kill containers
```
docker kill dockernetflow_wordpress_1  dockernetflow_db_1 containera containerb containerc
```
##### Remove containers
```
docker rm dockernetflow_wordpress_1  dockernetflow_db_1 containera containerb containerc -f
```
##### Remove images
```
docker image rm netflow_collector netflow_dataExport
```

#### DELETING ALL 

```
docker kill dockernetflow_wordpress_1  dockernetflow_db_1 containera containerb containerc
docker rm dockernetflow_wordpress_1  dockernetflow_db_1 containera containerb containerc -f
docker image rm netflow_collector netflow_dataExport
```


#### Dockerfile.dataExport
```
#ARG variavel
# especifica a imagem do ubuntu de base 
FROM ubuntu:latest
#declara uma variavel que vai vir do prompt
ARG collectorIpArg="default Value"
# instala ferramentas
# apt-utils (para o apt-get)  para iputils (para o ping) net-tolls (para ping)

ENV COLLECTOR_IP=${collectorIpArg}

RUN apt-get update && apt-get install -y \
    apt-utils \
    iputils-ping \
    net-tools \
    fprobe
# apaga arquivo de config. do coletor
RUN rm -f /etc/default/fprobe
# substitui arquivo de config. do coletor pelo predefinido fprobe ~/netflow/fprobe
COPY fprobe /etc/default/
#entrypoint
ENTRYPOINT service fprobe start && /bin/bash
#RUN nsenter -t ${variavel} -n service fprobe start &&  tail -F /var/log/fprobe/*.log
#CMD fprobe -ieth0 172.17.0.2:2055  
#172.17.0.2:2055
```
#### Dockerfile.colllector
```
# base image is ubuntu latest version
FROM ubuntu:latest
# install nfdump and some tools: apt-utils for  apt-get,  iputils for ifconfig,  net-tools for ping
RUN apt-get update && apt-get install -y \
    apt-utils \
    iputils-ping \
    net-tools \
    nfdump
# expose port
EXPOSE 2055
#
ENTRYPOINT ["/usr/bin/nfcapd","-l","/var/cache/nfdump","-p","2055"]


```
```