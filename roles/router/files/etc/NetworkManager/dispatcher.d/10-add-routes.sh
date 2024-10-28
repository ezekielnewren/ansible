#!/bin/bash

## copy this file to /etc/NetworkManager/dispatcher.d/
## mark it as executable

INTERFACE=$1
ACTION=$2

IF="br-lan"
if [ "$INTERFACE" == "$IF" ] && [ "$ACTION" == "up" ]; then
    ip route add 192.168.17.0/24 via 192.168.16.20 dev "$IF"
elif [ "$INTERFACE" == "$IF" ] && [ "$ACTION" == "down" ]; then
    ip route del 192.168.17.0/24 via 192.168.16.20 dev "$IF"
fi

