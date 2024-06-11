#!/bin/bash

INTERFACE=$1
STATUS=$2

if [[ "$INTERFACE" == "br-fast" && "$STATUS" == "up" ]]; then
    ip route add 192.168.17.0/24 dev br-fast scope link src {{ FAST_IP }} table fast
    ip rule add from all to 192.168.17.0/24 lookup fast
    ip rule add from 192.168.17.0/24 lookup fast
fi

