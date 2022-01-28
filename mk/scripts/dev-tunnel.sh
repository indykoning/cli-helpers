#!/usr/bin/env bash

# Include all variables from .env file.
[ -f app/etc/.env ] && source app/etc/.env
[ -f .env ] && source .env
[ -f app/etc/.env.${APP_ENV} ] && source app/etc/.env.${APP_ENV}
[ -f .env.${APP_ENV} ] && source .env.${APP_ENV}

if ! command -v sshfs &> /dev/null
then
    echo 'ERROR: OSXFUSE not installed, try running "brew cask install osxfuse && brew install sshfs"'
    exit
fi

if [ -d "./public/wp" ]; then DIR="public/app/uploads"; fi
if [ -f "./bin/magento" ]; then DIR="pub/media"; fi

[ -z ${DIR} ] && echo "Project not compatible." && exit

# Verify required values are available.
required_values=(REMOTE_SERVER_IP REMOTE_SERVER_USER REMOTE_SERVER_PATH)
for required_value in ${required_values[@]}; do
    [ -z ${!required_value} ] && echo "ERROR: ${required_value} is missing!" && exit
done

# Set local settings
LOCAL_FOLDER="${LOCAL_FOLDER:-./$DIR}"

TIMESTAMP=$( date +%s )


# Setup SSHFS
if mount | grep "$REMOTE_SERVER_USER@$REMOTE_SERVER_IP" > /dev/null; then
    echo "ERROR: Remote images were already mounted."
else
    # Check if the path is valid and get the full path
    full_path=$(ssh $REMOTE_SERVER_USER@$REMOTE_SERVER_IP "cd ${REMOTE_SERVER_PATH}/${DIR} > /dev/null 2>&1 && pwd -P")

    [ $? -ne 0 ] && echo "ERROR: There may be a typo in the remote path (don't include $DIR)" && exit;

    # Check if local folder is empty
    if [ "$(ls -A $LOCAL_FOLDER)" ]; then

        # Ask user how to continue, default exit
        echo "WARNING: Local folder not empty, move to backup? (y/N)"
        read str
        if [[ $str == *y* ]]; then

            LOCAL_FOLDER_BACKUP_NAME="$LOCAL_FOLDER-$TIMESTAMP"
            echo "INFO: Moving to $LOCAL_FOLDER_BACKUP_NAME"
            mv $LOCAL_FOLDER $LOCAL_FOLDER_BACKUP_NAME
            mkdir  $LOCAL_FOLDER

        else
            # No valid response, exiting
            exit
        fi

    fi

    sshfs -o allow_other,defer_permissions "$REMOTE_SERVER_USER@$REMOTE_SERVER_IP:${full_path}" $LOCAL_FOLDER -o allow_other
    echo "INFO: Remote images mounted"
fi
