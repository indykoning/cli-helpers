HELP+=| Magepack:\\n
HELP+=| Variables used for magepack:\\n
HELP+=| CMS_URL:\\n
HELP+=| CATEGORY_URL:\\n
HELP+=| PRODUCT_URL:\\n
HELP+=| Available commands for magepack:\\n
HELP+=|     $(COLOR_YELLOW)magepack-generate$(COLOR_NONE): Generate the magepack file\\n
HELP+=|\\n

magepack-generate:
	bash $(current_dir)/mk/scripts/magepack-generate.sh
