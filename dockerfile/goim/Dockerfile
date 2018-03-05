#第一行必须指令基于的基础镜像
# From centos

# #维护者信息
# MAINTAINER arafat5549 arafat5549@mail.com

# #镜像的操作指令
# #apt/sourcelist.list

# RUN yum -y install java-1.7.0-openjdk
# #RUN echo "\ndaemon off;">>/etc/ngnix/nignix.conf



# #容器启动时执行指令
# CMD /bin/bash


From ubuntu

MAINTAINER arafat5549 arafat5549@mail.com

#镜像的操作指令
#apt/sourcelist.list
# RUN apt-get update && apt-get install -y ngnix 
# RUN echo "\ndaemon off;">>/etc/ngnix/nignix.conf
# #容器启动时执行指令
# CMD /usr/sbin/ngnix

#运行kafka
RUN mkdir /usr/goim/ && cd /usr/goim/
RUN mkdir kafka && cd kafka
RUN wget http://mirror.bit.edu.cn/apache/kafka/1.0.0/kafka_2.11-1.0.0.tgz
RUN tar -zxvf kafka_2.11-1.0.0.tgz
RUN cd kafka_2.11-1.0.0



#RUN apt-get update &&  apt-get install openjdk-7-jre


CMD /bin/bash