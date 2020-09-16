#!/bin/bash
# this script should be copied to the postgresql image at /docker-entrypoint-initdb.d/
# and have eXecute permission. This way, it will run when the database volume is created

set -e # quit if errors occur anywhere

# create the user and database for keycloak. It must exist for Keycloak to start!
# User keycloak has no defined password as the PostgreSQL database is not exposed
# outside of Docker's internal network. You may want to CHANGE this!
# POSTGRES_USER and POSTGRES_DB come from docker-compose.yml.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE USER keycloak;
  CREATE DATABASE keycloak;
  GRANT ALL PRIVILEGES ON DATABASE keycloak TO keycloak;
EOSQL
