#!/bin/bash

TYPE=$1
NAME=$2
STATE=$3

case $STATE in
  "MASTER")
    ip route del default table fast
    ip route add default via 192.168.16.1 dev br-mgmt table fast
    ;;
  "BACKUP" | "FAULT")
    ip route del default table fast
    ip route add default via 192.168.17.1 dev br-fast table fast
    ;;
esac

