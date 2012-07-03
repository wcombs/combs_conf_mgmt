#!/bin/bash

CONF_LIST_FILE="/combsconf_cloudbox/conf_file_list"
CONF_PATH="/combsconf_cloudbox/conf"

echo "-==combsconf link checker==-"
echo

# pre-checks
echo -n "verifying config list..."
QUIT="no"
for i in `cat $CONF_LIST_FILE`; do
	FPATH=${CONF_PATH}${i}
	if [ ! -f $FPATH ]; then
		echo "error - $FPATH missing"
		QUIT="yes"
	fi
	if [ -L $FPATH ]; then
		echo "error - $FPATH is a symlink"
		QUIT="yes"
	fi
done

if [[ $QUIT == "yes" ]]; then
	echo
	echo "fix errors and re-run"
	exit
fi
echo "success"
echo

TOTAL_COUNT=0
SUCCESS_COUNT=0
ERROR_COUNT=0

# check each conf for correct linkage, if wrong fix it
echo "checking linkages..."
for i in `cat $CONF_LIST_FILE`; do
	TOTAL_COUNT=$[TOTAL_COUNT+1]
	SHOULD_DEST=${CONF_PATH}${i}
	if [ -f $i ]; then
		if [ -L $i ]; then
			REAL_DEST=`readlink $i`
			if [[ $SHOULD_DEST == $REAL_DEST ]]; then
				echo "$i is good to go"
				SUCCESS_COUNT=$[SUCCESS_COUNT+1]
			else
				echo -n "$i is linked to wrong dest, fixing..."
				mv $i ${i}.cs.orig && ln -s $SHOULD_DEST $i && echo "fixed"
				ERROR_COUNT=$[ERROR_COUNT+1]
			fi
		else
			echo -n "$i is not a symlink, fixing..."
			mv $i ${i}.cs.orig && ln -s $SHOULD_DEST $i && echo "fixed"
			ERROR_COUNT=$[ERROR_COUNT+1]
		fi
	else
		if [ -L $i ]; then
			echo -n "$i is a broken symlink, fixing..."
			rm $i && ln -s $SHOULD_DEST $i && echo "fixed"
			ERROR_COUNT=$[ERROR_COUNT+1]
		else
			echo -n "$i is not there, fixing..."
			ln -s $SHOULD_DEST $i && echo "fixed"
			ERROR_COUNT=$[ERROR_COUNT+1]
		fi
	fi 
done

# print results
echo
if [ $SUCCESS_COUNT -eq $TOTAL_COUNT ]; then
	echo "$TOTAL_COUNT config checked, all properly linked"
else
	echo "$TOTAL_COUNT config checked, $SUCCESS_COUNT already good, $ERROR_COUNT fixed"
fi
