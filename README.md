# RocksDB-OpsManager

A RocksDB engine (Using Persona binary) based implementation of MongoDB Ops Manager.

Operating System: Ubuntu:16.0
RockDb Version: 3.2.13-3.3

Features:
- A much faster user experience on webportal.
- Easy to manager a cluster running mongodb instance with RocksDB storage engine.

Note:
- Default password for root and nginxuser is "rocksdbuser". CHANGE IT!
- Default listening port for Ops Managera portal is 8080.

Steps:
- Run, "docker-compose up -d" to start the environment. Once the services are up, Ops Manager will be accessible on "http://<Hostame_or_IP>:8080"
