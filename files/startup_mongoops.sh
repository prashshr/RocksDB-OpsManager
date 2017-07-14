#!/bin/bash

sudo mkdir -p ${MONGO_OPS_SERVER_DB_DIR} ${MONGO_OPS_SERVER_BACKUP_DIR}
sudo chown -R ${ROCKSDBUSER}:${ROCKSDBUSER} ${MONGO_OPS_SERVER_DIR}

sudo /etc/init.d/postfix start
mongod --storageEngine=rocksdb --port 27017 --dbpath ${MONGO_OPS_SERVER_DB_DIR} --logpath ${MONGO_OPS_SERVER_DB_DIR}/mongoopsdb.log --fork
mongod --storageEngine=rocksdb --port 27018 --dbpath ${MONGO_OPS_SERVER_BACKUP_DIR} --logpath ${MONGO_OPS_SERVER_BACKUP_DIR}/mongoopsdb.log --fork
sudo /opt/mongodb/mms/bin/mongodb-mms start
sleep infinity
