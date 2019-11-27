## Docker Netflow Containers 
This repository  present two docker images that  could be used to capture netflow traffic of applications.
  * *** netflow_data_export ***: uses *fprobe* to export netflow data that is sent or arrives in an interface.
  * *** neflow_collector *** : receives netflow data and extracts it with *nfdump*.  
 

1. Download and extract the files from git repository

2. Make shure if your docker is started, with `service docker status. If it isn't started yet type `service docker start`. 

3. Enter in the /dockerNetflow dir and build a *** netflow_collector *** image, from Dockerfile, in this case  *Dockerfile.collector*:

One entry to build the image can be in the form:

```
$  docker build -t <YOUR_USERNAME>/myfirstapp .
```
  * In our case we put:
```
$  docker build -t aqualtune/netflow_collector -f Dockerfile.collector .
``` 
4. Build the *** neflow_data_export *** image:
```
$  docker build -t aqualtune/netflow_data_export  -f Dockerfile.dataExport .
```
5. Creates a collector container, named *containerc*, that will receives and store netflow data, open shell terminal:
```
$ docker run --name containerc -it aqualtune/netflow_collector bash
```
 * verify IP from collector 
```

```

 
6. Creates two containers from the image, named *containera* and *containerb*.
 * In a fisrt terminal type :
```
$ docker run --name containera -it aqualtune/netflow_data_export bash
```
 * In a second terminal type :
```
$ docker run --name containerb -it aqualtune/netflow_data_export  bash
```
It will opens two bash shell terminals. So see the net config to identify the IP of the machine:

```
root@fc90d64d95a0:/# ifconfig

```
With produces something like that:

```

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.17.0.2  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:ac:11:00:02  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

``` 
and:

```
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.17.0.3  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:ac:11:00:03  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```
And than, once the IPs where identified, in order to generates netflow traffic, *ping*  *containera* in  *containerb* and vice-versa:

In one terminal:

```
root@7e89ebf3504b:/# ping 172.17.0.2
PING 172.17.0.2 (172.17.0.2) 56(84) bytes of data.
64 bytes from 172.17.0.2: icmp_seq=1 ttl=64 time=0.202 ms
64 bytes from 172.17.0.2: icmp_seq=2 ttl=64 time=0.106 ms
64 bytes from 172.17.0.2: icmp_seq=3 ttl=64 time=0.088 ms
64 bytes from 172.17.0.2: icmp_seq=4 ttl=64 time=0.094 ms
64 bytes from 172.17.0.2: icmp_seq=5 ttl=64 time=0.140 ms
```

Other terminal:
```
root@fc90d64d95a0:/# ping 172.17.0.3
PING 172.17.0.3 (172.17.0.3) 56(84) bytes of data.
64 bytes from 172.17.0.3: icmp_seq=1 ttl=64 time=0.121 ms
64 bytes from 172.17.0.3: icmp_seq=2 ttl=64 time=0.099 ms
64 bytes from 172.17.0.3: icmp_seq=3 ttl=64 time=0.093 ms
64 bytes from 172.17.0.3: icmp_seq=4 ttl=64 time=0.099 ms
64 bytes from 172.17.0.3: icmp_seq=5 ttl=64 time=0.088 ms
```


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
