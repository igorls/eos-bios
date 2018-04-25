#!/bin/bash

# `boot_network` hook
# $1 genesis JSON
# $2 ephemeral public key
# $3 ephemeral private key
#
# This process must not BLOCK.

echo "Copying base config"
cp base_config.ini config.ini

echo "Writing genesis.json"
echo $1 > genesis.json

echo "producer-name = eosio" >> config.ini
echo "enable-stale-production = true" >> config.ini
echo "private-key = [\"$2\",\"$3\"]" >> config.ini

sudo rm -rf /tmp/nodeos-data

docker run -ti --rm --detach --name nodeos-bios \
       -v `pwd`:/etc/nodeos -v /tmp/nodeos-data:/data \
       -p 8888:8888 -p 9876:9876 \
       eosio/eos:latest \
       /opt/eosio/bin/nodeos --data-dir=/data \
                             --genesis-json=/etc/nodeos/genesis.json \
                             --config-dir=/etc/nodeos

echo "Waiting for nodeos to launch through Docker"
sleep 3