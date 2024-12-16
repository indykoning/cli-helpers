# Cli Helpers
This repository aims to make it easier to make it easier to work with
Laravel, Akeneo, Magento 2 and Wordpress projects by adding utility functions that utilise the information already available in a `.env` file.

## Installation

### Composer
Because (almost) all these projects utilise composer we support installing this as a composer package though it's not dependent on php itself (except for the scripts utilising Magerun)
If you have your global composer in your $PATH (`export PATH=$PATH:$HOME/.composer/vendor/bin`) you can run
```bash
composer global require indykoning/cli-helpers
```
after which you should be able to run 
```bash
cli-helpers
```
### Without Composer
If you don't want to or can't use composer you can simply clone this repository and symlink the `bin/cli-helpers` file to your bin folder.
e.g.
```bash
git clone git@github.com:indykoning/cli-helpers.git
chmod +x cli-helpers/bin/cli-helpers
ln -s `pwd`/cli-helpers/bin/cli-helpers /usr/local/bin/cli-helpers
```

> **Tip!** Install `pv` to get a progress bar when importing and exporting databases

## Commands
You can define a custom env file to use by prepending `ENVFILE=".env.custom"` to the command
Our current list of available commands are

### db-magerun
`cli-helpers db-magerun` uses magerun2 for exporting and importing a database with stripped tables

Available environment variables:
```env
REMOTE_SERVER_IP=
REMOTE_SERVER_USER=
# Path to the root folder of Magento
REMOTE_SERVER_PATH=
# In case the remote ssh server is running on a different port
REMOTE_SERVER_PORT=22
# If you wanna specify where magerun can be found on the remote server
REMOTE_MAGERUN="magerun2"
# If you wanna always use the latest version of Magerun
FORCE_ONLINE_MAGERUN=false
# Tables to strip the data from using mageruns --strip option https://github.com/netz98/n98-magerun2#stripped-database-dump
MAGERUN_STRIP="@2fa @aggregated @customers @idx @log @oauth @quotes @replica @sales @search @sessions @stripped @trade @temp"
# Tables to only include
INCLUDE_TABLES=
# Tables to skip entirely
EXCLUDE_TABLES=
```

### db-automysqlbackup
`cli-helpers db-automysqlbackup` uses the latest automysqlbackup dump to import
Do note that this requires you to have root access to the server.

Available environment variables:
```env
REMOTE_SERVER_IP=
DB_DATABASE=
DB_USERNAME=
DB_PASSWORD=
DB_PORT=
DB_HOST=
REMOTE_SERVER_DATABASE=
```
### db-mysqldump
`cli-helpers db-mysqldump` Creates a dump using mysqldump and imports it at the same time
This imports the database AS it is exporting.

Available environment variables:
```env
REMOTE_SERVER_IP=
REMOTE_SERVER_USER=
REMOTE_SERVER_DATABASE=
REMOTE_DB_USERNAME=
REMOTE_DB_PASSWORD=
DB_DATABASE=
DB_USERNAME=
DB_PASSWORD=
DB_PORT=
DB_HOST=
INCLUDE_TABLES=
EXCLUDE_TABLES=
```
> [!NOTE]  
> `INCLUDE_TABLES` and `EXCLUDE_TABLES` are space separated. E.g. `EXCLUDE_TABLES="table_one table_two"`


## Anonymizing the database

To anonymize the database [dbanon](https://github.com/mdshack/dbanon) is used. You can enable it by setting `ANONYMIZE=true` in your `.env` file. 

You can optionally set the config file path by setting `DBANON_CONFIG` in your `.env` file. If not set, `dbanon.yml` in the root of your project will be used.