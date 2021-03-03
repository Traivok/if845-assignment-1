#!/bin/bash

#####################################################################################
## Global Variables
SCRIPT_NAME=`basename $0`
USAGE="$SCRIPT_NAME <pid> [duration in seconds (default 60s)]\n
Example $SCRIPT_NAME 123 360\n 
Author: José Ricardo A. Figueirôa (jraf@cin.ufpe.br)"

#####################################################################################
## Get arguments
PID=$1
duration=$2

if [[ -z $PID ]]; then
    echo -e $USAGE
    exit 1;
fi

if [[ -z $duration ]]; then
    duration=60
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
