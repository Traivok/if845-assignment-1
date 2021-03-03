#!/bin/bash

#####################################################################################
## Global Variables
SCRIPT_NAME=`basename $0`
USAGE="$SCRIPT_NAME <pid> [-t duration in seconds (default 60s)] [-h help]\n
Example $SCRIPT_NAME 123 -t 360\n 
Author: José Ricardo A. Figueirôa (jraf@cin.ufpe.br)"
duration=60
PID=$1

#####################################################################################
## Get Opts and parse arguments
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

#####################################################################################
## Monitoring
elapsed=0
period=5

echo 'DATE, PROCESS, CPU, CPU%, DISC Writes (kB_wr/s), MEM%, TOTAL MEM, FREE MEM, BUFFERS, CACHED'

while [ $elapsed -lt $duration ]; do

    process=`  pidstat -p  $PID | tail +4 | awk '{print $11}'` 
    cpu_usage=`pidstat -p  $PID | tail +4 | awk '{print $9}'` 
    cpu=`      pidstat -p  $PID | tail +4 | awk '{print $10}'` 

    writes=`pidstat -d -p $PID | tail +4 | awk '{print $5}'`

    ram_usage=`pidstat -r -p $PID | tail +4 | awk '{print $5}'`

    mtotal=`cat /proc/meminfo | awk '/MemTotal/{print $2}'`
    mfree=` cat /proc/meminfo | awk '/MemFree/{print $2}'`
    buff=`  cat /proc/meminfo | awk '/Buffers/{print $2}'`
    cach=`  cat /proc/meminfo | awk '/^Cached/{print $2}'`

    echo "`date`, $process, $cpu_usage, $cpu, $writes, $ram_usage, $mtotal, $mfree, $buff, $cach"

    sleep $period
    elapsed=$((elapsed + period)) 
done
