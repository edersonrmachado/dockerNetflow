## netflowDataExport

1. Download and extract the files from git repository
2. Enter in the main dir and build an image:
```
$  docker build -t <YOUR_USERNAME>/myfirstapp .
``` 
  * Ex.:
```
$  docker build -t aqualtune/netflow_data_export_v1 .

```

3. Creates two containers from the image, named *a* and *b*.
   * In a fisrt terminal type :
```
$ docker run --name a -it aqualtune/netflow_data_export_v1 bash
```
 * In a second terminal type :
```
$ docker run --name b -it aqualtune/netflow_data_export_v1  bash
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


4. IP collector and port is sets in *fprobe* file. This file replaces original fprobe installation file, and sets the IP collector to 172.17.0.1 and port 2055.
(it can be changed modilfying fprobe values). The collector machine (or container)  needs *nfdump* to catch netflow traffic. So we must to install and launch *nfdump* service in to analyse if some netflow traffic is available :

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


Installing:

```
$ sudo wireshark

```
And filtering with "cflow" *Docker0* interface (172.17.0.1) in my case.
