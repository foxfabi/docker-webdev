#!/bin/bash

# If you start the mariadb container instance with a data directory that already
# contains a database (specifically, a mysql subdirectory), this script will be ignored

set -eo pipefail

_create_database() {
  # Database creation
  mysql -u root --password=${MARIADB_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS ${1} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
  mysql -u root --password=${MARIADB_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${1}.* TO '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';"
  mysql -u root --password=${MARIADB_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${1}.* TO '${MARIADB_USER}'@'localhost' IDENTIFIED BY '${MARIADB_PASSWORD}';"
}

echo "Creating user"
# User creation
mysql -u root --password=${MARIADB_PASSWORD} -e "CREATE USER IF NOT EXISTS '${MARIADB_USER}' IDENTIFIED BY '${MARIADB_PASSWORD}';"

echo "Creating databases"
for DATABASE_NAME in $DATABASE_APP $DATABASE_GITEA; do
  echo "  -> Creating ${DATABASE_NAME}"
  _create_database $DATABASE_NAME
done

echo "Grant permissions"
# Grant permissions to access and use the MySQL server
mysql -u root --password=${MARIADB_PASSWORD} -e "GRANT ALL PRIVILEGES ON *.* TO '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';"
mysql -u root --password=${MARIADB_PASSWORD} -e "GRANT ALL PRIVILEGES ON *.* TO '${MARIADB_USER}'@'localhost' IDENTIFIED BY '${MARIADB_PASSWORD}';"

echo "Adding grafana user with restricted permissions"
mysql -u root --password=${MARIADB_PASSWORD} -e "CREATE USER IF NOT EXISTS 'grafanaReader' IDENTIFIED BY 'grafana';"
mysql -u root --password=${MARIADB_PASSWORD} -e "GRANT SELECT ON *.* TO 'grafanaReader'@'%' IDENTIFIED BY 'grafana';"
mysql -u root --password=${MARIADB_PASSWORD} -e "GRANT SELECT ON *.* TO 'grafanaReader'@'localhost' IDENTIFIED BY 'grafana';"
