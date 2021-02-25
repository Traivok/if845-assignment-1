#!/bin/bash


USAGE="q1: [-b browser (default chrome)] [-t duration in seconds (default 100s)] [-h help]
Example q1 -b firefox -t 360 
Author: José Ricardo A. Figueirôa (jraf@cin.ufpe.br)"

browser="chrome"
duration=100
while getopts ":hb:t:" opt; do
    case $opt in
        t) duration=${OPTARG} ;;
        b) browser=${OPTARG} ;;
        h) echo $USAGE; exit 0;;
        :) ;;
    esac
done
shift $((OPTIND-1))

PIDs=pgrep $browser 

for PID in $PIDs; do
    echo $PID
done
