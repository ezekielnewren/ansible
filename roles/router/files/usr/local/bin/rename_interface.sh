#!/bin/bash

prefix="$1"
if [ -z "$prefix" ]; then
  echo "no prefix specified" >&2
  exit 1
fi

if_old="$2"
if [ -z "$if_old" ]; then
  echo "no interface name specified" >&2
  exit 2
fi

if [ ! -e "/sys/class/net/$if_old/address" ]; then
  echo "interface does not exist" >&2
  exit 3
fi

if_new="${prefix}$(cat /sys/class/net/$if_old/address | tr -d :)"
if [ "$if_new" != "$if_old" ]; then
  ip link set "$if_old" down
  ip link set "$if_old" name "$if_new"
  ip link set "$if_new" up
else
  echo "interface rename not required"
  exit 0
fi

