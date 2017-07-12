#!/bin/bash

sudo /etc/init.d/postfix start
mongod --storageEngine=rocksdb --port 27017 --dbpath /data/mongoopsdb --logpath /data/mongoopsdb/mongoopsdb.log --fork
mongod --storageEngine=rocksdb --port 27018 --dbpath /data/mongoopsdb_backup/ --logpath /data/mongoopsdb_backup/mongoopsdb.log --fork
sudo /opt/mongodb/mms/bin/mongodb-mms start
sleep infinity
