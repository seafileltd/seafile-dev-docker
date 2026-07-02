#!/bin/bash

set -e

function local_migrate() {
    dirs=(
        include
        lib
        bin
        share
    )
    for d in ${dirs[*]}; do
        if [[ -e ${COMPILE_PATH}/$d ]]; then
            cp -rf ${COMPILE_PATH}/$d/* /usr/$d/
        fi
    done
}


if [[ ! -e /data ]]; then
    echo 'do not find /data path'
    exit 1
fi

if [[ ! -e /data/ssh_key/id_rsa.pub || ! -e /data/ssh_key/id_rsa ]]; then
    echo 'do not find ssh private/public key, exit'
    exit 1
fi

cp -rf /data/ssh_key/id_rsa.pub /data/ssh_key/id_rsa /root/.ssh/
chmod 600 /root/.ssh/id_rsa
chmod 644 /root/.ssh/id_rsa.pub

if [[ ! -e /data/scripts ]]; then
    mkdir /data/scripts
    cp /root/scripts/run.sh /data/scripts
    chmod u+x /data/scripts/*.sh
fi

local_migrate
