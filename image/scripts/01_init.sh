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
        if [[ -e ${SOURCE_PATH}/$d ]]; then
            cp -rf ${SOURCE_PATH}/$d/* /usr/$d/
        fi
    done
}


function prepare_init() {
    mkdir -p $SOURCE_PATH
    mkdir -p $DATA_PATH
    mkdir -p $LOG_PATH
}


function init() {

    prepare_init

    #cd $DATA_PATH
    
    #wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz && tar xf libmemcached-1.0.18.tar.gz && cd libmemcached-1.0.18/ && ./configure --prefix=$SOURCE_PATH && make && make install && ldconfig && cd ..

    #local_migrate
    
    #git clone https://github.com/haiwen/seafobj.git
    
    git clone https://github.com/haiwen/libevhtp.git && cd libevhtp/ && cmake -DCMAKE_INSTALL_PREFIX:PATH=$SOURCE_PATH -DEVHTP_DISABLE_SSL=OFF -DEVHTP_BUILD_SHARED=ON . && make && make install && ldconfig && cd ..

    local_migrate

    git clone https://github.com/haiwen/libsearpc.git && cd libsearpc && ./autogen.sh && ./configure --prefix=$SOURCE_PATH && make && make install && ldconfig && cd ..

    local_migrate

    ssh-keygen -F github.com || ssh-keyscan github.com >>~/.ssh/known_hosts

    git clone https://github.com/seafileltd/portable-python-libevent.git
    
    git clone https://github.com/haiwen/ccnet-server.git && cd ccnet-server && ./autogen.sh && ./configure --prefix=$SOURCE_PATH && make && make install && ldconfig && cd ..

    local_migrate

    ccnet-init -c $CONF_PATH -n zming -H 127.0.0.1
    
    git clone https://github.com/haiwen/seafile-server.git && cd seafile-server && ./autogen.sh && ./configure --prefix=$SOURCE_PATH && make && make install && ldconfig && cd ..

    local_migrate

    cd $CONF_PATH && seaf-server-init -d seafile-data/ && echo "$CONF_PATH/seafile-data" > seafile.ini && cd ..

    cd conf && echo -en "\n[Database]\nENGINE = mysql\nHOST = db\nPORT = 3306\nUSER = root\nPASSWD = db_dev\nDB = ccnet\nCONNECTION_CHARSET = utf8" >> ccnet.conf && echo -en "\n[database]\ntype = mysql\nhost = db\nport = 3306\nuser = root\npassword = db_dev\ndb_name = seafile\nconnection_charset = utf8" >> seafile-data/seafile.conf

    cd /data/dev && git clone https://github.com/haiwen/seahub.git && cd seahub

    cd $CONF_PATH && cat > seahub_settings.py <<EOF
DEBUG = True
TEMPLATE_DEBUG = True

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql', # Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': 'seahub', # Or path to database file if using sqlite3.
        'USER': 'root',                      # Not used with sqlite3.
        'PASSWORD': 'db_dev',                  # Not used with sqlite3.
        'HOST': 'db',                      # Set to empty string for localhost. Not used with sqlite3.
        'PORT': '3306',                      # Set to empty string for default. Not used with sqlite3.
    }
}
EOF

    cd /data/dev &&  git clone git@github.com:seafileltd/seahub-extra.git && cd seahub-extra && git fetch origin 6.3:6.3 && git checkout 6.3

    #cd /data/dev && git clone git@github.com:seafileltd/seafevents.git && cd seafevents && git fetch origin 6.3:6.3 && git checkout 6.3

    cd $CONF_PATH && cat > seafevents.conf  <<EOF
[DATABASE]
type=mysql
username=root
password=db_dev
name=seafevents
host=db

[INDEX FILES]
enabled=true
interval=5m
seafesdir=/data/dev/seafes/

[STATISTICS]
enabled = true

[OFFICE CONVERTER]
enabled = true
EOF

    cd /data/dev && git clone git@github.com:seafileltd/seafes.git
}


if [[ ! -e /data ]]; then
    exit 1
fi

if [[ ! -e /data/ssh_key/id_rsa.pub || ! -e /data/ssh_key/id_rsa ]]; then
    echo 'do not find ssh private/public key, exit'
    exit 1
fi

cp -rf /data/ssh_key/id_rsa.pub /data/ssh_key/id_rsa /root/.ssh/
chmod 600 /root/.ssh/id_rsa
chmod 644 /root/.ssh/id_rsa.pub

if [[ ! -e /data/dev ]]; then
    init
    cp /root/scripts/run.sh /data/dev
    chmod u+x /data/dev/*.sh
fi

local_migrate
