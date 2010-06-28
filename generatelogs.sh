#!/bin/sh

DRUPAL_GIT_REPO=$1
TARGET=703488e5c5daf2c917c2d114d7946bc3a206519d..master

# drupal 7 logs
echo "creating D7 logs"
python drupalcodeswarmlog.py $DRUPAL_GIT_REPO $TARGET | sed -f post-process.sed > drupal7-git-logs.xml

# drupal whole history
echo "creating whole history logs"
python drupalcodeswarmlog.py -a $DRUPAL_GIT_REPO | sed -f post-process.sed > drupalfull-git-logs.xml
