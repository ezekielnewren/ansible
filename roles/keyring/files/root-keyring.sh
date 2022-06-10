#!/bin/bash

echo "export DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" > ~/dbus.sh
password=$(clevis decrypt tpm2 '{}' < ~/keyring.jwe)
source <(echo -n $password | gnome-keyring-daemon --unlock)
echo -n $password | gnome-keyring-daemon --foreground --login >/dev/null
