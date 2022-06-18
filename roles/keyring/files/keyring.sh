#!/bin/bash

password=$(clevis decrypt tpm2 '{}' < ~/keyring.jwe)

## start the keyring for the root user
#dbus-run-session -- bash root-keyring.sh &
#disown -h

for user in $(ls -1 /home); do
    machinectl shell $user@.host /usr/bin/bash -c "echo -n $password | gnome-keyring-daemon --daemonize --login"
done

