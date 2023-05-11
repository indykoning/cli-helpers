#!/usr/bin/env bash

# Include all variables from .env file.
[ -f app/etc/.env ] && source app/etc/.env
[ -f .env ] && source .env
[ -f app/etc/.env.${APP_ENV} ] && source app/etc/.env.${APP_ENV}
[ -f .env.${APP_ENV} ] && source .env.${APP_ENV}

# Verify required values are available.
required_values=(DB_DATABASE DB_USERNAME REMOTE_SERVER_IP REMOTE_SERVER_DATABASE REMOTE_DB_USERNAME)
for required_value in ${required_values[@]}; do
    [ -z ${!required_value} ] && echo "${required_value} is missing!" && exit
done

EXCLUDE_TABLES=($EXCLUDE_TABLES)
EXCLUDE_TABLES="${EXCLUDE_TABLES[@]/#/--ignore-table=${REMOTE_SERVER_DATABASE}.}"

# Set default value if env variables do not exist
DB_PORT="${DB_PORT:-3306}"
DB_HOST="${DB_HOST:-127.0.0.1}"
REMOTE_SERVER_PORT="${REMOTE_SERVER_PORT:-22}"
REMOTE_SERVER_USER="${REMOTE_SERVER_USER:-root}"

# Use PV if available to display progress bar.
command -v pv &> /dev/null && pv='pv' || pv='cat'

# Import database.
echo "Importing"
ssh -p $REMOTE_SERVER_PORT $REMOTE_SERVER_USER@$REMOTE_SERVER_IP "mysqldump --user=\"${REMOTE_DB_USERNAME}\" --password=\"${REMOTE_DB_PASSWORD}\" ${REMOTE_SERVER_DATABASE} ${INCLUDE_TABLES} ${EXCLUDE_TABLES}" \
| ${pv} \
| mysql --user="${DB_USERNAME}" --password="${DB_PASSWORD}" --port=${DB_PORT} --host=${DB_HOST} ${DB_DATABASE}
