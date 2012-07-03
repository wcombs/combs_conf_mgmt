#!/bin/bash

CONF_LIST_FILE="/combsconf_cloudbox/conf_file_list"

echo -n "sorting conf file list..."
cp -p $CONF_LIST_FILE ${CONF_LIST_FILE}.sort && sort ${CONF_LIST_FILE}.sort > $CONF_LIST_FILE && rm ${CONF_LIST_FILE}.sort
echo "sorted"
echo
