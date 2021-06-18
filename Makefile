mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))
.DEFAULT_GOAL := help
# No color code
COLOR_NONE=\033[0m
# Bold color codes
COLOR_BLACK=\033[1;30m
COLOR_RED=\033[1;31m
COLOR_GREEN=\033[1;32m
COLOR_YELLOW=\033[1;33m
COLOR_BLUE=\033[1;34m
COLOR_PURPLE=\033[1;35m
COLOR_CYAN=\033[1;36m
COLOR_WHITE=\033[1;37m

HELP=" ______________________________________________________________\\n"
HELP+=|\\n
HELP+=| This reads context from the .env or app/etc/.env file\\n
HELP+=| And uses the variables defined in there to execute the commands\\n
HELP+=|\\n
HELP+=| Usage: $(COLOR_CYAN)cli-helpers$(COLOR_NONE) $(COLOR_YELLOW)<command>$(COLOR_NONE)\\n |\\n


include $(current_dir)/mk/*.mk

help:
	@echo "$(HELP)"
