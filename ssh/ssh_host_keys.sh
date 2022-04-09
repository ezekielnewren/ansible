#!/bin/bash

if [ -f /tmp/secret.json ]; then
    secret=$(cat /tmp/secret.json)
else
    name=$1
    VAULT_ADDR=$2
    VAULT_TOKEN=$3

    if [ "$VAULT_ADDR" == "" ] || [ "$VAULT_TOKEN" == "" ]; then
        echo "VAULT_ADDR and VAULT_TOKEN must be passed as the first and second arguments"
        exit 1
    fi

    secret=$(curl -H "X-Vault-Token: $VAULT_TOKEN" -H "X-Vault-Request: true" $VAULT_ADDR/v1/cubbyhole/$name | jq -rMc .data)
fi



for file in $(echo "$secret" | jq -r "keys[]" | grep ssh_host); do
    echo $file
    echo "$secret" | jq -rMc ".data.\"$file\"" > /etc/ssh/$file
done
cd /etc/ssh
ls -1 | grep "^ssh_host.*key$" | xargs -l chmod 600

