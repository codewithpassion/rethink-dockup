#!/bin/bash

source ./mongoconfig.sh

MONGO_RESTORE_CMD="mongorestore --host ${MONGODB_HOST} --port ${MONGODB_PORT} ${USER_STR}${PASS_STR} /dockup/${MONGO_BACKUP_NAME}"

echo "Restoring MongoDB database dump..."
eval "time $MONGO_RESTORE_CMD"
rc=$?
./mongoclean.sh

if [ $rc -ne 0 ]; then
  echo "ERROR: Failed to restore MongoDB dump"
  exit $rc
else
  echo "Successfully restored database dump"
fi




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

if [ -n "$RETHINKDB_PASSWORD" ]; then
  rm /tmp/pwd
fi

if [ $rc -ne 0 ]; then
  echo "ERROR: Failed to restore RethinkDB dump"
  exit $rc
else
  echo "Successfully restored database dump"
fi
