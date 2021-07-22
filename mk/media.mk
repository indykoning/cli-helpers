HELP+=| Media:\\n
HELP+=| macFUSE will need to be installed for the media commands\\n
HELP+=| https://osxfuse.github.io/\\n
HELP+=| It is currently `command -v sshfs &> /dev/null && echo "$(COLOR_GREEN)Installed" || echo "$(COLOR_RED)Not installed"`$(COLOR_NONE)\\n
HELP+=| Variables used by media scripts:\\n
HELP+=| REMOTE_SERVER_IP\\n
HELP+=| REMOTE_SERVER_USER\\n
HELP+=| REMOTE_SERVER_PATH\\n
HELP+=| Available commands for media:\\n
HELP+=|     $(COLOR_YELLOW)media-link$(COLOR_NONE):    link the remote media folder to local\\n
HELP+=|     $(COLOR_YELLOW)media-unlink$(COLOR_NONE):  unlink the remote media folder\\n
HELP+=|     $(COLOR_YELLOW)media-list$(COLOR_NONE):    list the currently mounted folders\\n
HELP+=|\\n

media-link:
	bash $(current_dir)/mk/scripts/dev-tunnel.sh
media-list:
	mount | grep 'osxfuse\|macfuse'
media-unlink:
	bash $(current_dir)/mk/scripts/media-unlink.sh
	@echo "Media unmounted"
