# especifica a imagem do ubuntu de base 
FROM ubuntu:latest 
# instala ferramentas
# apt-utils (para o apt-get)  para iputils (para o ping) net-tolls (para ping)
RUN apt-get update && apt-get install -y \ 
    apt-utils \
    iputils-ping \
    net-tools \
    vim \
    fprobe 
# para o servico do fprobe
#:RUN service fprobe stop
# apaga arquivo de config. do coletor
RUN rm -f /etc/default/fprobe
# substitui arquivo de config. do coletor pelo predefinido fprobe ~/netflow/fprobe
COPY fprobe /etc/default/
# inicial fprobe
#RUN fprobe -ieth0 172.17.0.1:2055
RUN service fprobe stop \
    service fprobe start \
    service fprobe --full-restart 
	

