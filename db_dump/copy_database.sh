#!/bin/bash

FILENAME='pg-dump.psql'
REMOTE='kaya.cosiso.nl'
DATABASE='dsa'

pg_dump --format=c --oids --dbname="$DATABASE" --file="$FILENAME"
scp "$FILENAME" $REMOTE:

ssh $REMOTE "pg_restore --format=c --clean --dbname=\"$DATABASE\" \"$FILENAME\"; rm \"$FILENAME\" "

rm "$FILENAME"