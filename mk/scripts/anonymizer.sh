# DBAnon settings
ANONYMIZE="${ANONYMIZE:-false}"
DBANON_CONFIG="${DBANON_CONFIG:-dbanon.yml}"

# Check if dbanon is available
if [ "${ANONYMIZE}" == "true" ]; then
    if ! command -v dbanon &> /dev/null; then
        echo -e "\033[0;31mdbanon is required for anonymization but it's not installed. Install dbanon or disable anonymize.\033[0m"
        exit 1
    fi

    if [ ! -f "${DBANON_CONFIG}" ]; then
        echo -e "\033[0;31mConfiguration file '${DBANON_CONFIG}' not found. Please create a valid config file for dbanon.\033[0m"
        exit 1
    fi

    anonymizer="dbanon --config=${DBANON_CONFIG}"
    echo -e "\033[0;32mAnonymizing database\033[0m"
else
    anonymizer='cat'
    echo -e "\033[0;31mNot anonymizing database!\033[0m"
fi