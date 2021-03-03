#!/bin/bash

SCRIPT_NAME=`basename $0`
USAGE="$SCRIPT_NAME <pid> [-t duration in seconds (default 60s)] [-h help]\n
Example $SCRIPT_NAME 123 -t 360\n 
Author: José Ricardo A. Figueirôa (jraf@cin.ufpe.br)"

duration=60
PID=$1

while getopts ":ht:" opt; do
    case $opt in
        t) duration=${OPTARG} ;;
        h) echo -e $USAGE; exit 0;;
        :) echo "Missing options argument for -$OPTARG" >&2; exit 1;;
    esac
done
shift $((OPTIND-1))

if [[ -z $PID ]]; then
    echo -e $USAGE
    exit 1;
fi

cat /proc/$PID/stat >&2
