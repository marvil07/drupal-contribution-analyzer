#!/bin/sh

HEADER='<?xml version="1.0"?>\n<file_events>
'
FOOTER='</file_events>'
SEPARATOR="%x09" #tab
COMMIT_BEFORE_D7_START=703488e5c5daf2c917c2d114d7946bc3a206519d

echo $HEADER
#d7 only
#git log --date=iso --reverse --format="%H$SEPARATOR%at$SEPARATOR%an$SEPARATOR%s" $COMMIT_BEFORE_D7_START..HEAD | while read LINE; do
#whole history
git log --all --date=iso --reverse --format="%H$SEPARATOR%at$SEPARATOR%an$SEPARATOR%s" master | while read LINE; do
    HASH=`echo "$LINE"| cut -f1`
    TIMESTAMP=`echo "$LINE"| cut -f2`
    COMMITER=`echo "$LINE"| cut -f3`
    SUBJECT=`echo "$LINE"| cut -f4`
    # process each file
    git whatchanged -1 --format="%an" $HASH | grep ^:| cut -f 2 | while read FILE; do
        echo "<event date=\"${TIMESTAMP}000\" filename=\"/cvs/drupal/drupal/$FILE\" author=\"$COMMITER\" />"
        # process each author parsing subject
        echo $SUBJECT | php getauthors.php | while read AUTOR; do
            echo "<event date=\"${TIMESTAMP}000\" filename=\"/cvs/drupal/drupal/$FILE\" author=\"$AUTOR\" />"
        done
    done
done
echo $FOOTER
