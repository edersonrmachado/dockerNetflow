#!/bin/sh

# Arguments list (must be provided)

# $1  = APP_CONTAINER_NAME_1
# $2  = APP_CONTAINER_NAME_2
# $3  = APP_NETWORK_NAME
# $4  = HOST_PORT
# $5  = probeInterface
# $6  = collectorPort
# $7  = CONTAINER_NAME_A
# $8  = CONTAINER_NAME_B
# $9  = CONTAINER_NAME_C
# $10 = reserved to collectorIp 

# run application containers
docker-compose up  -d

# run collector container
docker run -d -p $4:2055 --network=$3 --name "${9}"  aqualtune/netflow_collector

# take collector IP
collectorIp=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "${9}")

#run data export containers
docker run -e FLOW_COLLECTOR=$collectorIp -e INTERFACE=$5 -e COLLECTOR_PORT=$6 -d -it --network=container:$1 --name $7 aqualtune/netflow_data_export 
docker run -e FLOW_COLLECTOR=$collectorIp -e INTERFACE=$5 -e COLLECTOR_PORT=$6 -d -it --network=container:$2 --name $8 aqualtune/netflow_data_export 

