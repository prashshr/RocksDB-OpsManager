FROM ubuntu:16.04

MAINTAINER ROCKSDB Docker "prash.shr@gmail.com"

ENV SHELL /bin/bash
ENV TERM xterm

ENV TIMEZONE Europe/Berlin

ENV ROCKSDB_VERSION 3.2.13-3.3-percona

ENV ROCKSDBUSER rocksdbuser
ENV ROCKSDBUSERID 754
ENV ROCKSDBGRPID 754

ENV ROCKSDB_INSTALL_DIR /data/db

ENV MONGO_OPS_SERVER_DB /data/mongoopsdb
ENV MONGO_OPS_SERVER_BACKUPDB /data/mongoopsdb_backup

RUN apt-get update
RUN apt-get install sudo wget tar zip net-tools git vim telnet inetutils-ping dnsutils curl logrotate -y

RUN groupadd -g ${ROCKSDBUSERID} ${ROCKSDBUSER} && useradd -r -s /bin/bash -d /home/${ROCKSDBUSER}  -u ${ROCKSDBGRPID}  -g ${ROCKSDBUSER}  -m ${ROCKSDBUSER} 
RUN echo "${ROCKSDBUSER}:saj6MTmDUNxac" | chpasswd && echo "root:saj6MTmDUNxac" | chpasswd

RUN echo "${ROCKSDBUSER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "Defaults:${ROCKSDBUSER} !requiretty" >> /etc/sudoers

RUN apt-get install tzdata -y
RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/${TIMEZONE}/etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

USER ${ROCKSDBUSERID}

RUN cd /tmp
RUN wget https://downloads.mongodb.com/on-prem-mms/deb/mongodb-mms_3.4.3.402-1_x86_64.deb?_ga=1.213155796.1730354285.1485356528 -O /tmp/mongodb-mms_3.4.3.402-1_x86_64.deb

RUN sudo mkdir -p ${MONGO_OPS_SERVER_DB} ${MONGO_OPS_SERVER_BACKUPDB} 
RUN sudo chown -R rocksdbuser:rocksdbuser ${MONGO_OPS_SERVER_DB} ${MONGO_OPS_SERVER_BACKUPDB} 

RUN sudo dpkg --install /tmp/mongodb-mms_3.4.3.402-1_x86_64.deb

RUN sudo mkdir -p ${ROCKSDB_INSTALL_DIR} && cd /home/${ROCKSDBUSER}
RUN sudo apt-get install lsb-release -y
RUN sudo wget https://repo.percona.com/apt/percona-release_0.1-4.$(lsb_release -sc)_all.deb
RUN sudo dpkg -i percona-release_0.1-4.$(lsb_release -sc)_all.deb
RUN sudo apt-get update && sudo apt-get install percona-server-mongodb-32 -y
RUN sudo chown -R ${ROCKSDBUSER}:${ROCKSDBUSER} ${ROCKSDB_INSTALL_DIR}

RUN sudo apt-get update && sudo dpkg --configure -a
RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install postfix mailutils -y

COPY files/startup_mongoops.sh /home/${ROCKSDBUSER}/

EXPOSE 27017

WORKDIR /home/${ROCKSDBUSER}

RUN sudo chmod +x ./startup_mongoops.sh

CMD ["./startup_mongoops.sh"]

