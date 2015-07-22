# Bash start-up file, created by chaplocal

export PROMPT_DIRTRIM=2
cd $APPS_DIR

echo ""
echo "Now running inside container. Directory is: $APPS_DIR"
echo ""

if [ "$EXTERN_HOSTPORT" != "" -a "$HTTPD_SERVER_NAME" != "" ]; then
  echo "The default '$HTTPD_SERVER_NAME' site is running at http://$EXTERN_HOSTPORT/"
  echo ""
fi

