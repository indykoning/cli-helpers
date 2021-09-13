#!/usr/bin/env bash

# Include all variables from .env file.
[ -f app/etc/.env ] && source app/etc/.env
[ -f .env ] && source .env
[ -f app/etc/.env.${APP_ENV} ] && source app/etc/.env.${APP_ENV}
[ -f .env.${APP_ENV} ] && source .env.${APP_ENV}

# Verify required values are available.
required_values=(CMS_URL CATEGORY_URL PRODUCT_URL)
for required_value in ${required_values[@]}; do
    [ -z ${!required_value} ] && echo "${required_value} is missing!" && exit
done

# Install magepack if not available.
command -v magepack || yarn global add magepack;

# Generate magepack config.
magepack generate --cms-url="${CMS_URL}" --category-url="${CATEGORY_URL}" --product-url="${PRODUCT_URL}";
