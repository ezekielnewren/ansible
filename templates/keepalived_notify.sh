#!/bin/bash

if ip -brief a s dev br-fast | grep -q 192.168.17.1; then
    ip route del default table fast
    ip route add default via 192.168.16.1 dev br-mgmt table fast
else
    ip route del default table fast
    ip route add default via 192.168.17.1 dev br-fast table fast
fi

