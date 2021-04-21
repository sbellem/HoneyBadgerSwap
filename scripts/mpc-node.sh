#!/usr/bin/env bash
set -e

config=${1:-/opt/hbswap/conf/server.toml}

# Place the data where MP-SPDZ expects it
setup_data() {
    mkdir -p /opt/hbswap/data/db/$NODE_ID
    #/opt/hbswap/data/inputmask-shares /opt/hbswap/data/preprocessing-data
    # Copy the public keys of all players
    cp /opt/hbswap/public-keys/* Player-Data/
    # Symlink to the private key, to where MP-SPDZ expects it to be (under Player-Data/).
    ln --symbolic --force /run/secrets/P$NODE_ID.key Player-Data/P$NODE_ID.key
}

reset_contract_data() {
    go run /go/src/github.com/initc3/HoneyBadgerSwap/src/go/reset/reset.go
}

httpserver() {
    hbswap-start-httpserver
}

mpcserver() {
    if [ $NODE_ID -eq 0 ]; then
        # TODO remove once the data is persisted
        #go run /go/src/github.com/initc3/HoneyBadgerSwap/src/go/reset/reset.go

        mkdir -p /usr/src/hbswap/log
        ./mpcserver -config $config -id $NODE_ID > /usr/src/hbswap/log/mpc_server_$NODE_ID.log 2>&1
    else
        ./mpcserver -config $config -id $NODE_ID
    fi
}

setup_data

httpserver & mpcserver
