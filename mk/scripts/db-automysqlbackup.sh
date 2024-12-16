#!/usr/bin/env bash

# Include all variables from .env file.
[ -f app/etc/.env ] && source app/etc/.env
[ -f .env ] && source .env
[ -f app/etc/.env.${APP_ENV} ] && source app/etc/.env.${APP_ENV}
[ -f .env.${APP_ENV} ] && source .env.${APP_ENV}
[ -f ${ENVFILE} ] && source ${ENVFILE}

# Verify required values are available.
required_values=(DB_DATABASE DB_USERNAME REMOTE_SERVER_IP REMOTE_SERVER_DATABASE)
for required_value in ${required_values[@]}; do
    [ -z ${!required_value} ] && echo "${required_value} is missing!" && exit
done

# Set default value if env variables do not exist
DB_PORT="${DB_PORT:-3306}"
DB_HOST="${DB_HOST:-127.0.0.1}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/anonymizer.sh"

# Retrieve dump
latest_dump=$(ssh root@${REMOTE_SERVER_IP} "cd /var/lib/automysqlbackup/daily/${REMOTE_SERVER_DATABASE}/ && printf '%s\n' ${REMOTE_SERVER_DATABASE}*.sql.gz | tail -1")
echo "Downloading latest dump ${latest_dump}..."
scp root@${REMOTE_SERVER_IP}:/var/lib/automysqlbackup/daily/${REMOTE_SERVER_DATABASE}/${latest_dump} ./

[ -f ${latest_dump} ] || echo "Could not download dump!"

# OSX uses gzcat, unix uses zcat.
command -v gzcat &> /dev/null && zcat='gzcat' || zcat='zcat'
# Use PV if available to display progress bar.
command -v pv &> /dev/null && pv='pv' || pv='cat'

# Import database.
echo "Importing..."
${pv} ${latest_dump} \
| ${zcat} \
| ${anonymizer} \
| LC_ALL=C sed 's/DEFINER=[^*]*\*/\*/g' \
| mysql --user="${DB_USERNAME}" --password="${DB_PASSWORD}" --port=${DB_PORT} --host=${DB_HOST} ${DB_DATABASE}

rm ${latest_dump}
echo -e "\033[0;32mImport finished!\033[0m"