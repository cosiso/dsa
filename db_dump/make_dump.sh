#!/bin/bash

PATH='/var/www/nginx/dsa/db_dump'
FILENAME="dsa.dump.$(/usr/bin/date '+%Y%m%d').sql"

cd "$PATH"
/usr/bin/pg_dump --no-owner --format c --oids -d dsa > "$FILENAME"

count=$(/usr/bin/ls -1 *.dump.*.sql | /usr/bin/wc -l)
if [[ $count > 2 ]]; then
   remove=$(/usr/bin/ls -t *.dump.*.sql|/usr/bin/tail -n1)
   /usr/bin/rm "$remove"
fi