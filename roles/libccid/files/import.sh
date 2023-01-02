#!/bin/bash

file="$1"

for i in `seq 0 2`; do
    openssl pkcs12 -export -out tmp.pfx -passout pass: \
    -inkey <(jq -r .[$i].private_key $file) \
    -in <(jq -r .[$i].certificate $file) \
    --name $(jq -r .[$i].nickname $file)

    pk12util -d /etc/pki/nssdb -W "" -i tmp.pfx
done

certutil -d /etc/pki/nssdb -K
certutil -d /etc/pki/nssdb -L

rm tmp.pfx
