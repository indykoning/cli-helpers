#!/usr/bin/env bash

# Include all variables from .env file.
[ -f app/etc/.env ] && source app/etc/.env
[ -f .env ] && source .env
[ -f app/etc/.env.${APP_ENV} ] && source app/etc/.env.${APP_ENV}
[ -f .env.${APP_ENV} ] && source .env.${APP_ENV}
[ -n "$ENVFILE" ] && [ -f ${ENVFILE} ] && source ${ENVFILE}

# Verify required values are available.
required_values=(REMOTE_SERVER_IP REMOTE_SERVER_USER REMOTE_SERVER_PATH)
for required_value in ${required_values[@]}; do
    [ -z ${!required_value} ] && echo "${required_value} is missing!" && exit
done

[ -n "$MAGERUN_EXCLUDE" ] && EXCLUDE_TABLES=$MAGERUN_EXCLUDE;
[ -n "$EXCLUDE_TABLES" ] && EXCLUDE_TABLES="--exclude=\"${EXCLUDE_TABLES}\"";
[ -n "$INCLUDE_TABLES" ] && INCLUDE_TABLES="--include=\"${INCLUDE_TABLES}\"";

# Use MAGERUN_STRIP value, if it does not exist use default values
MAGERUN_STRIP="${MAGERUN_STRIP:-@2fa @aggregated @customers @idx @klarna @log @mailchimp @newrelic_reporting @oauth @quotes @replica @sales @search @sessions @stripped @trade @temp amasty_xsearch_users_search xtento_*_profile_history xtento_*_log sync_log magento_operation magento_bulk queue_*}"
REMOTE_SERVER_PORT="${REMOTE_SERVER_PORT:-22}"
REMOTE_MAGERUN="${REMOTE_MAGERUN:-magerun2}"
LOCAL_MAGERUN="${LOCAL_MAGERUN:-magerun2}"
if [ "$FORCE_ONLINE_MAGERUN" = true ] ; then
    REMOTE_MAGERUN="curl https://files.magerun.net/n98-magerun2-latest.phar -s --output /tmp/magerun2 > /dev/null && ${REMOTE_PHP:-php} /tmp/magerun2"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/anonymizer.sh"

echo -e "SSH connection info: \033[1;33mssh -p $REMOTE_SERVER_PORT $REMOTE_SERVER_USER@$REMOTE_SERVER_IP\033[0m"
echo -e "Running \033[1;33m${REMOTE_MAGERUN} db:dump --strip=\"${MAGERUN_STRIP}\" ${INCLUDE_TABLES} ${EXCLUDE_TABLES}\033[0m and importing..."
ssh -p $REMOTE_SERVER_PORT $REMOTE_SERVER_USER@$REMOTE_SERVER_IP "cd ${REMOTE_SERVER_PATH}; ${REMOTE_MAGERUN} db:dump --strip=\"${MAGERUN_STRIP}\" ${INCLUDE_TABLES} ${EXCLUDE_TABLES} --stdout" \
| ${anonymizer} \
| ${LOCAL_MAGERUN} db:import --compression=none /dev/stdin
