FROM wetransform/dockup:latest
MAINTAINER Dominik Fretz <dominik@openrov.com>

# install RethinkDB and drivers
RUN apt-get install -y wget && \
    echo "deb http://download.rethinkdb.com/apt trusty main" | tee /etc/apt/sources.list.d/rethinkdb.list && \
    wget -qO- https://download.rethinkdb.com/apt/pubkey.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y rethinkdb && \
    pip install rethinkdb

ADD /scripts /dockup/
RUN chmod 755 /dockup/*.sh

ENV PATHS_TO_BACKUP /dockup/rethink-dump.tar.gz
ENV RETHINK_BACKUP_NAME rethink-dump.tar.gz
ENV BEFORE_BACKUP_CMD ./rethinkdump.sh
ENV AFTER_BACKUP_CMD ./rethinkclean.sh
ENV AFTER_RESTORE_CMD ./rethinkrestore.sh
ENV RETHINKDB_HOST localhost
ENV RETHINKDB_PORT 28015
