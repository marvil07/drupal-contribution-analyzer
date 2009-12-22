#!/bin/bash

OUTPUT_FILE=$1

# follow blip.tv suggestion http://blip.tv/learning/export
for i in {1,2}; do
    mencoder mf://*.png -mf fps=24:type=png -o $OUTPUT_FILE\
        -of lavf -ofps 15 -vf harddup \
        -ovc lavc -lavcopts vcodec=flv:vbitrate=400:cbp:mv0:mbd=2:trell:v4mv:last_pred=3:vpass=$i \
        -oac copy;
done
