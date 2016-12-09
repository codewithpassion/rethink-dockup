#!/bin/bash

source ./rethinkconfig.sh

CONNECT="-c ${RETHINKDB_HOST}:${RETHINKDB_PORT}"

if [ -n "$RETHINKDB_PASSWORD" ]; then
  echo $RETHINKDB_PASSWORD > /tmp/pwd
  readonly DUMP_PWD="--password-file /tmp/pwd"
fi

BACKUP_FILE="--file /dockup/${RETHINK_BACKUP_NAME}"

RETHINK_RESTORE_CMD="rethinkdb restore ${CONNECT} ${DUMP_PWD} ${BACKUP_FILE} ${RETHINKDB_DUMP_EXTRA_OPTS}"


echo "Restoring RethinkDB dump..."
eval "time $RETHINK_RESTORE_CMD"

rc=$?
./rethinkclean.sh

if [ -n "$RETHINKDB_PASSWORD" ]; then
  rm /tmp/pwd
fi

if [ $rc -ne 0 ]; then
  echo "ERROR: Failed to restore RethinkDB dump"
  exit $rc
else
  echo "Successfully restored database dump"
fi
