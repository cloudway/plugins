#!/bin/bash -e

# look specifically for PG_VERSION, as it is expected in the DB dir
if [ ! -s "$PGDATA/PG_VERSION" ]; then
  mkdir -p "$PGDATA"
  chmod 700 "$PGDATA"
  chown -R postgres "$PGDATA"

  chmod g+s /run/postgresql
  chown -R postgres /run/postgresql

  ln -s $PGDATA/postgres.log $CLOUDWAY_POSTGRES_LOG_DIR/postgres.log

  dbuser=$CLOUDWAY_POSTGRES_DB_USERNAME
  dbpass=$CLOUDWAY_POSTGRES_DB_PASSWORD
  dbname=$CLOUDWAY_APP_NAME

  eval "gosu postgres initdb $POSTGRES_INITDB_ARGS"

  { echo; echo "host all all 0.0.0.0/0 md5"; } >> "$PGDATA/pg_hba.conf"

  # internal start of server in order to allow set-up using psql-client
  # does not listen on external TCP/IP and waits until start finishes
  gosu postgres pg_ctl -D "$PGDATA" \
          -o "-c listen_addresses='localhost'" \
          -w start

  psql=( psql -v ON_ERROR_STOP=1 )

  "${psql[@]}" --username postgres <<-EOSQL
      CREATE DATABASE "$dbname";
      CREATE USER "$dbuser" WITH SUPERUSER PASSWORD '$dbpass';
EOSQL

  gosu postgres pg_ctl -D "$PGDATA" -m fast -w stop
fi
