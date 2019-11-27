## Docker Netflow Containers 
This repository  present two docker images that  could be used to capture netflow traffic of applications.
  * ***netflow_data_export***: uses *fprobe* to export netflow data that is sent or arrives in an interface.
  * ***neflow_collector*** : receives netflow data and extracts it with *nfdump*.  
 

1. Download and extract the files from git repository

2. Make shure if your docker is started, with `service docker status`. If it isn't started yet type `service docker start`. 

3. Enter in the /dockerNetflow dir and build a ***netflow_collector*** image, from Dockerfile, in this case  *Dockerfile.collector*:

One entry to build the image can be in the form:

```
$  docker build -t <YOUR_USERNAME>/myfirstapp .
```
   In our case we put:
```
$  docker build -t aqualtune/netflow_collector -f Dockerfile.collector .
``` 
4. Build the ***neflow_data_export*** image:
```
$  docker build -t aqualtune/netflow_data_export  -f Dockerfile.dataExport .
```
5. Creates a collector container, named *containerc*, that will receives and store netflow data. The port using to receive netflow data, (collector port 2055), is connected to  the host 2055 port.

```
$ docker run -d -p 2055:2055  name containerc aqualtune/netflow_collector
```
 * verify IP collector 
```
$ docker exec containerc ifconfg
```
With returns
```
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.17.0.2  netmask 255.255.0.0  broadcast 172.17.255.255
        ...
```
So collector IP is 172.17.0.2
 * verify if *nfdump* is running
```
docker exec containerc ps -ax | grep nfcapd
```   
So the *containera* has IP 172.17.0.2 and it is listen for netflow traffic in port2055.  
 
6. Creates two containers from the image, named *containera* and *containerb*.
 * First container
```
$ docker run -d --name containera  aqualtune/netflow_data_export 
```
 * Second :
```
$ docker run -d --name containerb  aqualtune/netflow_data_export 
```
See the process to know if fprobe is running :
```
$ docker exec containera ps
```

```

```
```
$ docker exec containerb ps
```


See the net config to identify the IP of the machine:

```
$ docker exec containtera ifconfig

```
With produces:

```
and:
```
$ docker exec containterb ifconfig
``` 
# fiz ate aqui falta ajustar a imagem do netflow_data_export que tah com
# problema na sintaxe do entrypoint
# o comando que temos que passar eh *fprobe -ieth0 172.17.0.2:2055* 
# nao rolou como no nfdump  


#desconsiderar o que esta abaixo
And than, once the IPs where identified, in order to generates netflow traffic, *ping*  *containera* in  *containerb* and vice-versa:

In one terminal

4. IP collector and port are set in *fprobe* file. This file replaces original fprobe installation file, and sets the IP collector to 172.17.0.1 and port 2055.
(it can be changed modilfying fprobe values). The collector machine (or container)  needs *nfdump* to catch netflow traffic. So we must to install and launch *nfdump* service to analyse if some netflow traffic is available :

Installing:
```
$ sudo apt install nfdump
```
Start service:

Starting service:

```
 $ service  nfdump start
```
 
5. To see netflow traffic with * wireshark*,  open it  in a terminal in collector machine:

```
$ sudo wireshark

```
* And than visualise  the netfflow data using "cflow" filtering string, in *Docker0* interface (172.17.0.1) in my case.

6. Creating a third container, *containerc*, to collect netflow data from netflow data export containers, * containera* and *containerb*.

Go to *netflowCollector* dir and creates an collector  image:

```
docker build -t aqualtune/netflow_collector -f Dockerfile.collector .

``` 
7. Creates a collector container named *containerc* and enter in bash shell:

```
$ docker run --name containerc -it aqualtune/netflow_collector  bash
```

8. Test collector container ping other containers, sets *fprobe* file to new ip address and port of collector.
To remove containers type:
```
$ docker rm containera containerb 
```
or,

```
$ docker rm containera containerb -f
`` 


This project is in test phase...




#dockerNetflow
