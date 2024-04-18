#!/bin/bash


path=$1

device=$(readlink -f $path)

if [ ! -b $device ]; then
    echo "$path is not a block device"
    exit 1
fi

if [ $(id -u) -ne 0 ]; then
    echo "must run with sudo or as root"
    exit 1
fi

metadata=$(cryptsetup luksDump --dump-json-metadata $path); ec=$?
if [ "$ec" != "0" ]; then
    echo "failed to retrieve metadata, is this a valid luks device?"
    exit $ec
fi
metadata=$(echo $metadata | jq -rMc)

keyslots=$(echo $metadata | jq -r '.keyslots|keys|join(" ")')
echo "keyslots: $keyslots"

tokens=$(echo $metadata | jq -r '.tokens|keys|join(" ")')
echo "tokens: $tokens"

echo "$path -> $device"
cryptsetup luksKillSlot $path 1; ec=$?
for token in $tokens; do
    cryptsetup token remove --token-id $token $path
done
echo
cryptsetup luksDump $path
