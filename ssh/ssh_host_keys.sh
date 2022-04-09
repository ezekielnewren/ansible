#!/bin/bash

if [ -f /tmp/secret.json ]; then
    secret=$(cat /tmp/secret.json)
else
    VAULT_ADDR=$1
    VAULT_TOKEN=$2

    if [ "$VAULT_ADDR" == "" ] || [ "$VAULT_TOKEN" == "" ]; then
        echo "VAULT_ADDR and VAULT_TOKEN must be passed as the first and second arguments"
        exit 1
    fi

    secret=$(curl -H "X-Vault-Token: $VAULT_TOKEN" -H "X-Vault-Request: true" $VAULT_ADDR/v1/cubbyhole/$name | jq -rMc .data)
fi



for file in $(echo "$secret" | jq -r "keys[]" | grep ssh_host); do
    echo $file
    echo "$secret" | jq -rMc ".data.\"$file\"" > $file
done
ls -1 | grep "^ssh_host.*key$" | xargs -l chmod 600

