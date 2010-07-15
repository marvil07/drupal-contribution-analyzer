#!/bin/sh

LOGFILE=$1
cat $LOGFILE | sed -f simplelist.sed | sort | uniq -c | while read LINE; do
    COUNT=`echo $LINE | awk '{print $1}'`
    NICK=`echo $LINE | sed 's/^[ ]*[0-9]* //g'`
    echo "$NICK:$COUNT"
done
