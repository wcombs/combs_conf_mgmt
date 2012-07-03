#!/bin/bash

CONF_LIST_FILE="/combsconf_cloudbox/conf_file_list"
CONF_PATH="/combsconf_cloudbox/conf"

if [ $# -ne 1 ]; then
    echo "USAGE: `basename $0` /full/path/to/file"
    echo "exiting..."
    exit
fi

echo "-==combsconf file grabber==-"
echo

ARG_PATH=$1
FULL_CONF_PATH=${CONF_PATH}${ARG_PATH}
FULL_CONF_DIR=`dirname $FULL_CONF_PATH`

# pre-checks
echo -n "verifying file grab..."
QUIT="no"
if [ ! -f $ARG_PATH ]; then
	echo "error - $ARG_PATH not a file"
	QUIT="yes"
fi
if [ -L $ARG_PATH ]; then
	echo "error - $ARG_PATH is a symlink"
	QUIT="yes"
fi
if [ -n "`grep "$ARG_PATH" $CONF_LIST_FILE`" ]; then
	echo "error - $ARG_PATH already in conf at $CONF_LIST_FILE"
	QUIT="yes"
fi
if [ -f $FULL_CONF_PATH ]; then
	echo "error - $FULL_CONF_PATH already there"
	QUIT="yes"
fi
if [ -n "`echo "$ARG_PATH" | grep "^$CONF_PATH"`" ]; then
	echo "error - $ARG_PATH is a subdir of $CONF_PATH"
	QUIT="yes"
fi

if [[ $QUIT == "yes" ]]; then
	echo
	echo "error, exiting..."
	exit
fi
echo "success"
echo

echo -n "grabbing the file..."
mkdir -p $FULL_CONF_DIR
cp -p $ARG_PATH $FULL_CONF_PATH
echo "$ARG_PATH" >> $CONF_LIST_FILE
echo "success"
