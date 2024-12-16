#!/usr/bin/env bash

# Include all variables from .env file.
[ -f app/etc/.env ] && source app/etc/.env
[ -f .env ] && source .env
[ -f app/etc/.env.${APP_ENV} ] && source app/etc/.env.${APP_ENV}
[ -f .env.${APP_ENV} ] && source .env.${APP_ENV}
[ -f ${ENVFILE} ] && source ${ENVFILE}

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
SINGLE_TRANSACTION="${SINGLE_TRANSACTION:-TRUE}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/anonymizer.sh"

# Use PV if available to display progress bar.
command -v pv &> /dev/null && pv='pv' || pv='cat'

# Import database.
echo -e "SSH connection info: \033[1;33mssh -p $REMOTE_SERVER_PORT $REMOTE_SERVER_USER@$REMOTE_SERVER_IP\033[0m"
echo -e "Exporting database with \033[1;33mmysqldump --single-transaction=${SINGLE_TRANSACTION} ${REMOTE_SERVER_DATABASE} ${INCLUDE_TABLES} ${EXCLUDE_TABLES}\033[0m and importing..."
ssh -p $REMOTE_SERVER_PORT $REMOTE_SERVER_USER@$REMOTE_SERVER_IP "mysqldump --single-transaction=${SINGLE_TRANSACTION} --user=\"${REMOTE_DB_USERNAME}\" --password=\"${REMOTE_DB_PASSWORD}\" ${REMOTE_SERVER_DATABASE} ${INCLUDE_TABLES} ${EXCLUDE_TABLES}" \
| ${pv} \
| LC_ALL=C sed 's/DEFINER=[^*]*\*/\*/g' \
| ${anonymizer} \
| mysql --user="${DB_USERNAME}" --password="${DB_PASSWORD}" --port=${DB_PORT} --host=${DB_HOST} ${DB_DATABASE}
echo -e "\033[0;32mImport finished!\033[0m"
