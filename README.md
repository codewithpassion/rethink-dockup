dockup-mongo
============

RETHINKDB_PASSWORD

[![Docker Hub Badge](https://img.shields.io/badge/Docker-Hub%20Hosted-blue.svg)](https://hub.docker.com/r/wetransform/dockup-mongo/)

Docker image to backup/restore your MongoDB to AWS S3.
Builds upon [dockup](https://github.com/wetransform-os/dockup).

Configuration
-------------

This Docker image uses `mongodump` to create a MongoDB database dump and backup or restore it with [dockup](https://github.com/wetransform-os/dockup).
Please see the [dockup](https://github.com/wetransform-os/dockup) repository for extended information on configuration options, for instance on how to configure encryption with GnuPG.

The following MongoDB specific configuration options have been added:

* **MONGODB_HOST** - the host/ip of your mongodb database (defaults to `mongodb`)
* **MONGODB_PORT** - the port number of your mongodb database (defaults to `27017`)
* **MONGODB_USER** - the username of your mongodb database. If MONGODB_USER is empty while MONGODB_PASS is not, the image will use admin as the default username
* **MONGODB_PASS** - the password of your mongodb database
* **MONGODB_AUTH_DB** - the authentication database to use, if any
* **MONGODB_DB** - the database name to dump. If not specified, it will dump all the databases
* **MONGODB_DUMP_EXTRA_OPTS** - the extra options to pass to mongodump command

Usually you will link your MongoDB container to the *dockup* container, if you use `mongodb` as the link name you don't need to configure the host.

For an example runnning backup and restore, see the `./test-backup.sh` script.
Before running it, ensure there is a file `test-env.txt` with configuration options as in `test-env.txt.sample`.

The following *dockup* environment variables should **not be overriden** if using the specialised MongoDB image:

* **BEFORE_BACKUP_CMD**
* **AFTER_BACKUP_CMD**
* **AFTER_RESTORE_CMD**
* **PATHS_TO_BACKUP**
