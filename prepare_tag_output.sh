#!/bin/sh

usage() {
	echo "$0 option file.xml"
}

if [ "$#" != "2" ]; then
	echo error: you need to pass 2 parameters
	usage
	exit 1
fi

OPTION=$1
LOGFILE=$2

case $OPTION in
	file-activity)
		cat $LOGFILE | sed -f filter-to-file-activity.sed | sort | uniq -c | while read LINE; do
			COUNT=`echo $LINE | awk '{print $1}'`
			NICK=`echo $LINE | sed 's/^[ ]*[0-9]* //g'`
			echo "$NICK:$COUNT"
		done
		;;
	commit-activity)
		cat $LOGFILE | sed -f filter-to-commit-activity.sed |sort| uniq | sed 's/[ ]*[0-9]* //' | sort | uniq -c | while read LINE; do
			COUNT=`echo $LINE | awk '{print $1}'`
			NICK=`echo $LINE | sed 's/^[ ]*[0-9]* //g'`
			echo "$NICK:$COUNT"
		done
		;;
	*)
		usage
		exit 1
esac
