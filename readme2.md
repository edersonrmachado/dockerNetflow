### 
#### 1. Build and Run application
``` 
docker-compose up  -d
``` 
#### 2. Generates collector image
```
 docker build -t netflow_collector -f Dockerfile.collector .
```
#### 3. Run collector image 
```
docker run -d -p 2055:2055 --name containerc netflow_collector
```

#### 4. Collect collector IP 
```
collectorIp=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' containerc)
```
##### Generates Data Export containers

#### 5. Build probes Image
```
docker build  --build-arg collectorIpArg=collectorIp  -t netflow_data_export -f Dockerfile.dataExport . 
```
##### Generates probes taking PID of application
#### 6. Netflow Data Export 1: Wordpress probe
```
docker run --rm -it -d --privileged --pid="container:dockernetflow_wordpress_1"   --name containera  netflow_data_export  \bin\bash
``` 
#### 7. Netflow Data Export 1: MySql (db) probe
```
docker run --rm -it -d --privileged --pid="container:dockernetflow_db_1"   --name containerb  netflow_data_export  \bin\bash
``` 
#### 8. Trasnfering Netflow data to an output folder
``` 
while true; do docker cp containerc:/var/cache/nfdump ~/Docker/dockerNetflow/nes; sleep 300; done &
``` 
### ALL COMMANDS
```
docker-compose up  -d
docker build -t netflow_collector -f Dockerfile.collector .
docker run -d -p 2055:2055 --name containerc netflow_collector
collectorIp=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' containerc)
docker build  --build-arg collectorIpArg=collectorIp  -t netflow_data_export -f Dockerfile.dataExport . 
docker run  -it -d --privileged --pid="container:dockernetflow_wordpress_1" --network=container:dockernetflow_wordpress_1  --name containera  netflow_data_export  \bin\bash
docker run -it -d --privileged --pid="container:dockernetflow_db_1" --network=container:dockernetflow_db_1  --name containerb  netflow_data_export  \bin\bash
```

##sem o compartilhamento de rede
```
docker-compose up  -d
docker build -t netflow_collector -f Dockerfile.collector .
docker run -d -p 2055:2055 --name containerc netflow_collector
collectorIp=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' containerc)
docker build  --build-arg collectorIpArg=collectorIp  -t netflow_data_export -f Dockerfile.dataExport . 
docker run  -it -d --privileged --pid="container:dockernetflow_wordpress_1"  --name containera  netflow_data_export  \bin\bash
docker run -it -d --privileged --pid="container:dockernetflow_db_1" --name containerb  netflow_data_export  \bin\bash
```


#### Netflow  traffic output folder
``` 
while true; do docker cp containerc:/var/cache/nfdump ~/Docker/dockerNetflow/nes; sleep 300; done &
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
docker image rm netflow_collector netflow_data_export
```

#### DELETING ALL 

```
docker kill dockernetflow_wordpress_1  dockernetflow_db_1 containera containerb containerc
docker rm dockernetflow_wordpress_1  dockernetflow_db_1 containera containerb containerc -f
docker image rm netflow_collector netflow_data_export
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
#### Namespaces and PIDs
```
PID1=$(docker inspect --format '{{.State.Pid}}' dockernetflow_wordpress_1)
PID2=$(docker inspect --format '{{.State.Pid}}' dockernetflow_db_1)
PID3=$(docker inspect --format '{{.State.Pid}}' containera)
PID4=$(docker inspect --format '{{.State.Pid}}' containerb)
PID5=$(docker inspect --format '{{.State.Pid}}' containerc)
:
```
##### All namespaces
```
sudo ls /proc/$PID1/ns -la
sudo ls /proc/$PID2/ns -la
sudo ls /proc/$PID3/ns -la
sudo ls /proc/$PID4/ns -la
sudo ls /proc/$PID5/ns -la
```

##### All interfaces
```
sudo nsenter -t $PID1 -n ip a
sudo nsenter -t $PID2 -n ip a
sudo nsenter -t $PID3 -n ip a
sudo nsenter -t $PID4 -n ip a
sudo nsenter -t $PID5 -n ip a
```
#### salvar com o nhup
```
nohup bash -c 'while true; do docker cp containerc:/var/cache/nfdump ~/Docker/dockerNetflow/nes; sleep 20; done' < /dev/null &
```
#### passar dado para um arquivo

```
 docker inspect -f '{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' containera > file.txt
```
#### acessar a pasta do nfdump do coletor
```
docker exec --privileged containerc nfdump -o line -R /var/cache/nfdump
```

#### First, you’d create the veth pair:
```
ip link add veth0 type veth peer name veth1
```




```

```

```

```

```

```
