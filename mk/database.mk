HELP+=| Variables used in  the database scripts:\\n
HELP+=|     REMOTE_SERVER_IP\\n
HELP+=|     REMOTE_SERVER_USER\\n
HELP+=|     REMOTE_SERVER_PATH (db-magerun only)\\n
HELP+=|     MAGERUN_STRIP (db-magerun only)\\n
HELP+=|     MAGERUN_EXCLUDE (db-magerun only)\\n
HELP+=|     DB_DATABASE (automysqlbackup/mysqldump only)\\n
HELP+=|     DB_USERNAME (automysqlbackup/mysqldump only)\\n
HELP+=|     DB_PASSWORD (automysqlbackup/mysqldump only)\\n
HELP+=|     DB_PORT (automysqlbackup/mysqldump only)\\n
HELP+=|     DB_HOST (automysqlbackup/mysqldump only)\\n
HELP+=|     REMOTE_SERVER_DATABASE (automysqlbackup/mysqldump only)\\n
HELP+=|     REMOTE_DB_USERNAME (mysqldump only)\\n
HELP+=|     REMOTE_DB_PASSWORD (mysqldump only)\\n
HELP+=|     INCLUDE_TABLES (mysqldump only)\\n
HELP+=|     EXCLUDE_TABLES (mysqldump only)\\n
HELP+=|     REMOTE_MAGERUN (specify the remote absolute path to magerun2)\\n
HELP+=| Available commands for databases:\\n
HELP+=|     $(COLOR_YELLOW)db-magerun$(COLOR_NONE):         Import database from remote using magerun\\n
HELP+=|     $(COLOR_YELLOW)db-automysqlbackup$(COLOR_NONE): Import database from remote using automysqlbackup\\n
HELP+=|     $(COLOR_YELLOW)db-mysqldump$(COLOR_NONE):       Import database from remote using mysqldump\\n
HELP+=|\\n

db-magerun:
	bash $(current_dir)/mk/scripts/db-magerun.sh
db-automysqlbackup:
	bash $(current_dir)/mk/scripts/db-automysqlbackup.sh
db-mysqldump:
	bash $(current_dir)/mk/scripts/db-mysqldump.sh
