#!/bin/bash

DEV=''

if [ -z $1 ]; then
    DEV='lo'
else
    DEV=$1
fi

sudo tcpdump -i $DEV tcp port 22 -c 100 -s 60 -w log.pcap

