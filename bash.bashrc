# Bash start-up file, created by chaplocal

export PROMPT_DIRTRIM=2
cd $APPS_DIR

echo ""
echo "Now running inside container. Directory is: $APPS_DIR"
echo ""

echo "The default '$HTTPD_SERVER_NAME' site is running at http://$CONFIG_EXT_SSL_HOSTNAME:$CONFIG_EXT_HTTPS_PORT/"
