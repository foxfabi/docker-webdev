#!/bin/bash

set -eo pipefail

_create_database() {
  docker_process_sql --database=mysql <<-EOSQL
    CREATE DATABASE \`$1\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES ON \`$1\`.* TO '$DATABASE_USERNAME'@'%';
EOSQL
}

mysql_note "Creating user ${DATABASE_USERNAME}"
docker_process_sql --database=mysql <<<"CREATE USER '$DATABASE_USERNAME'@'%' IDENTIFIED BY '$DATABASE_PASSWORD';"

mysql_note "Creating databases"
for DATABASE_NAME in $DATABASE_APP $DATABASE_GITEA; do
  mysql_note "Creating ${DATABASE_NAME}"
  _create_database $DATABASE_NAME
done
