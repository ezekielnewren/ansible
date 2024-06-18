#!/bin/bash

INTERFACE=$1
STATUS=$2

if [[ "$INTERFACE" == "br-fast" && "$STATUS" == "up" ]]; then
    ip route add default via 192.168.17.1 dev br-fast table fast
    ip route add 192.168.17.0/24 dev br-fast scope link src {{ FAST_IP }} table fast
    ip rule add from all to 192.168.17.0/24 lookup fast priority 200
    ip rule add from 192.168.17.0/24 lookup fast priority 200
    ip rule add not from 192.168.17.0/24 to {{ FAST_IP }} lookup main priority 100
    ip rule add from {{ FAST_IP }} not to 192.168.17.0/24 lookup main priority 100
fi

