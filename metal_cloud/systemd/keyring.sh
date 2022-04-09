#!/bin/bash

password=$(clevis decrypt tpm2 '{}' < ~/keyring.jwe)

for user in $(ls -1 /home); do
    machinectl shell $user@.host /usr/bin/bash -c "echo $password | gnome-keyring-daemon --daemonize --login"
done

