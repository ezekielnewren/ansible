#!/bin/bash


if [ $(id -u) -eq 0 ]; then
    if [ "$1" == "-" ]; then
        read -sp "keyring: " password
    else
        password=$(clevis decrypt tpm2 '{}' < ~/keyring.jwe)
    fi

    if [ "$password" == "" ]; then
        echo "password is empty, exiting..."
        exit 1
    fi

    for user in $(ls -1 /home); do
        machinectl shell $user@.host /usr/bin/bash -c "echo -n $password | keyring.sh"
    done
else
    if [ "$(ps a -U $USER | grep gnome-keyring-daemon | grep -v grep | wc -l)" -le 0 ]; then
        read -sp "keyring: " password
        if [ "$password" == "" ]; then
            echo "empty password skipping..."
            exit 1
        fi

        base=~/.local/share/keyrings

        mkdir -p $base
        pwhash=$(echo -n $password | sha256sum | cut -d' ' -f1)
        if [ $(ls -1 $base | wc -l) -eq 0 ]; then
            echo $pwhash > $base/keyring.hash
            echo -n $password | gnome-keyring-daemon -d --login
        else
            if [ "$pwhash" == "$(cat $base/keyring.hash)" ]; then
                echo -n $password | gnome-keyring-daemon -d --login
            else
                echo "bad password"
                exit 2
            fi
        fi
        
        #ec=$(echo -n test | secret-tool store --label="test" test test; echo $?)
        #if [ $ec -eq 0 ]; then
        if echo -n test | secret-tool store --label="test" test test; then
            echo "keyring started for '$USER'"
            secret-tool clear test test 2>/dev/null
        else
            echo "failed to start keyring for '$USER'"
            secret-tool clear test test 2>/dev/null
            exit 3
        fi
    else
        if echo -n test | secret-tool store --label="test" test test; then
            echo "keyring is already started for '$USER'"
            secret-tool clear test test 2>/dev/null
        else
            echo "problem with the keyring for '$USER'"
            secret-tool clear test test 2>/dev/null
            exit 4
        fi
    fi
fi
