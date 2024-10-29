#!/bin/bash

#set -e

function stop_server() {
    pkill -9 -f seaf-server
    pkill -9 -f runserver
    pkill -9 -f main
    pkill -9 -f "node dist/src/index.js"
    pkill -9 -f "seaf-md-server"
}

function set_env() {
    export CCNET_CONF_DIR=$CONF_PATH
    export SEAFILE_CONF_DIR=$CONF_PATH/seafile-data
    export PYTHONPATH=$COMPILE_PATH:$CONF_PATH:$PYTHONPATH:/usr/lib/python3/dist-packages:/usr/lib/python3.12/site-packages:/usr/local/lib/python3.12/dist-packages:/usr/local/lib/python3.12/site-packages:/data/dev/seahub/thirdpart:/data/dev/pyes/pyes:/data/dev/portable-python-libevent/libevent:/data/dev/seafobj:/data/dev/seahub/seahub/:/data/dev/
    export SEAFES_DIR=/data/dev/seafes/
    export SEAHUB_DIR=/data/dev/seahub/
    export JWT_PRIVATE_KEY=bc187b9a-2f34-43cf-bea3-73c87e7375eb  
    export SITE_ROOT=/
}

function start_server() {
    stop_server

    set_env

    seaf-server -c $CONF_PATH -d $CONF_PATH/seafile-data -D all -L /data -f -l - >> /data/logs/seafile.log 2>&1 &
    sleep 0.5

    cd /data/dev/seaf-md-server
    ./seaf-md-server -c $CONF_PATH/seaf-md-server.conf &
    sleep 0.5

    cd /data/dev/seahub
    python manage.py runserver 0.0.0.0:8000 &
    cd ../seafevents
    sleep 0.5
    python main.py --config-file $CONF_PATH/seafevents.conf >> /data/logs/seafevents.log 2>&1 &
    # Seafevents cannot start without sleep for a few seconds
    sleep 2
}

function start_frontend {
    set_env
    cd /data/dev/seahub/frontend
    npm run dev &
}

function start_dtable_web {
    stop_server
    set_env

    seaf-server -c $CONF_PATH -d $CONF_PATH/seafile-data -D all -f -l - &
    sleep 0.5
    cd /data/dev/dtable-web/
    python manage.py runserver 0.0.0.0:8001 &
}

function start_dtable_frontend {
    set_env
    cd /data/dev/dtable-web/frontend
    npm run dev &
}

function start_dtable {
    set_env
    service nginx restart
    cd /data/dev/dtable-server/
    export DTABLE_SERVER_CONFIG=config/config.json && node dist/src/index.js >> index.log &
}

function check_python_executable() {
    if [[ "$PYTHON" != "" && -x $PYTHON ]]; then
        return 0
    fi

    if which python3.8 2>/dev/null 1>&2; then
        PYTHON=python3.8
    elif which python38 2>/dev/null 1>&2; then
        PYTHON=python38
    else
        echo
        echo "Can't find a python executable of version 3.8 or above in PATH"
        echo "Install python 3.8+ before continue."
        echo "Or if you installed it in a non-standard PATH, set the PYTHON enviroment varirable to it"
        echo
        exit 1
    fi
}

function run_python_wth_env() {
    set_env
    check_python_executable

    $PYTHON ${*:2}
}

function run_pytest_wth_env() {
    set_env
    check_python_executable

    py.test ${*:2}
}

function run_with_env() {
    set_env

    ${*:2}
}

function check_process() {
    # check the args
    if [ "$1" = "" ];
    then
        return 0
    fi

    #PROCESS_NUM => get the process number regarding the given thread name
    PROCESS_NUM=$(ps -ef | grep "$1" | grep -v "grep" | wc -l)
    if [ $PROCESS_NUM -ge 1 ];
    then
    	return 1
    else
        echo "$1 already exit"
        exit 1
    fi
}

function install_compiled() {
    dirs=(
        include
        lib
        share
        bin
    )
    for d in ${dirs[*]}; do
        if [[ -e ${COMPILE_PATH}/$d ]]; then
            cp -rf ${COMPILE_PATH}/$d/* /usr/$d/
        fi
    done
}

function prepare_init() {
    mkdir -p $COMPILE_PATH
    mkdir -p $SOURCE_PATH
    mkdir -p $LOG_PATH
    mkdir -p $CONF_PATH
    mkdir $CONF_PATH/seafile-data
    mkdir $CONF_PATH/seafile-data/library-template
    mkdir -p $CONF_PATH/md-server-data
}

function fetch() {
    prepare_init
    cd $SOURCE_PATH

    ssh-keygen -F github.com || ssh-keyscan github.com >>~/.ssh/known_hosts

    if [ ! -d "libevhtp" ];then
        git clone git@github.com:haiwen/libevhtp.git
    else
        cd libevhtp && git pull && cd ..
    fi

    if [ ! -d "libsearpc" ];then
        git clone git@github.com:haiwen/libsearpc.git
    else
        cd libsearpc && git pull && cd -
    fi

    if [ ! -d "seafobj" ]; then
        git clone git@github.com:haiwen/seafobj.git
    else
        cd seafobj && git pull && cd -
    fi

    if [ ! -d "seafile-pro-server" ]; then
        git clone git@github.com:seafileltd/seafile-pro-server.git
    else
        cd seafile-pro-server && git pull && cd -
    fi

    if [ ! -d "/data/dev/seahub" ]; then
        cd /data/dev && git clone git@github.com:/haiwen/seahub.git
    else
        cd /data/dev/seahub && git pull && cd -
    fi

    if [ ! -d "/data/dev/seafevents" ]; then
        cd /data/dev && git clone git@github.com:seafileltd/seafevents.git
    else
        cd /data/dev/seafevents && git pull && cd -
    fi

    if [ ! -d "/data/dev/seafes" ]; then
        cd /data/dev && git clone git@github.com:seafileltd/seafes.git
    else
        cd /data/dev/seafes && git pull && cd -
    fi

    if [ ! -d "/data/dev/sdoc-server" ]; then
        cd /data/dev && git clone git@github.com:seafileltd/sdoc-server.git
    else
        cd /data/dev/sdoc-server && git pull && cd -
    fi

    if [ ! -d "/data/dev/seaf-md-server" ]; then
        cd /data/dev && git clone git@github.com:seafileltd/seaf-md-server.git
    else
        cd /data/dev/seaf-md-server && git pull && cd -
    fi
}

#https://dev.seafile.com/seahub/f/a4124dd839484598b63c/
function compile() {

    cd $SOURCE_PATH

    cd libevhtp/ && cmake -DCMAKE_INSTALL_PREFIX:PATH=$COMPILE_PATH -DEVHTP_DISABLE_SSL=ON -DEVHTP_BUILD_SHARED=OFF . && make && make install && ldconfig && cd ..
    install_compiled

    cd libsearpc && ./autogen.sh && ./configure --prefix=$COMPILE_PATH && make && make install && ldconfig && cd ..
    install_compiled

    cd seafile-pro-server && ./autogen.sh && ./configure --disable-fuse --prefix=$COMPILE_PATH && make && make install && ldconfig && cd ..
    install_compiled

    cd seaf-md-server && go build -trimpath && cd ..
    install_compiled


if [ ! -f "$CONF_PATH/seahub_settings.py" ]; then
    cd $CONF_PATH && cat > seahub_settings.py <<EOF
# DEBUG = True

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql', # Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': 'seahub',                     # Or path to database file if using sqlite3.
        'USER': 'root',                       # Not used with sqlite3.
        'PASSWORD': 'db_dev',                 # Not used with sqlite3.
        'HOST': 'db',                         # Set to empty string for localhost. Not used with sqlite3.
        'PORT': '3306',                       # Set to empty string for default. Not used with sqlite3.
    }
}

SERVICE_URL = 'http://127.0.0.1:8000'
FILE_SERVER_ROOT = 'http://127.0.0.1:8082'

ENABLE_METADATA_MANAGEMENT = True
METADATA_SERVER_SECRET_KEY = 'e37347d67d53ca9bae69d3f842655da3'
METADATA_SERVER_URL = 'http://127.0.0.1:8088'

EOF
fi


if [ ! -f "$CONF_PATH/seafevents.conf" ]; then
    cd $CONF_PATH && cat > seafevents.conf  <<EOF
[DATABASE]
type = mysql
username = root
password = db_dev
name = seahub
host = db

[INDEX FILES]
enabled = false
interval = 5m
external_es_server = true
es_host = es
es_port = 9200

[STATISTICS]
enabled = true

[OFFICE CONVERTER]
enabled = true

[AUDIT]
enabled = true

[REDIS]
server=redis
EOF
fi


if [ ! -f "$CONF_PATH/seafile-data/seafile.conf" ]; then

    cd $CONF_PATH && cat > seafile.ini  <<EOF
$CONF_PATH/seafile-data
EOF


    cd $CONF_PATH && cat > ccnet.conf  <<EOF
[Database]
ENGINE = mysql
HOST = db
PORT = 3306
USER = root
PASSWD = db_dev
DB = ccnet
CONNECTION_CHARSET = utf8
CREATE_TABLES = true

EOF


    cd $CONF_PATH/seafile-data && cat > seafile.conf  <<EOF
[database]
type = mysql
host = db
port = 3306
user = root
password = db_dev
db_name = seafile
connection_charset = utf8
create_tables = true
EOF

    cd
fi

if [ ! -f "$CONF_PATH/seaf-md-server.conf" ]; then
    cd $CONF_PATH && cat > seaf-md-server.conf  <<EOF
[general]
host = 0.0.0.0
port = 8088
log_dir = /data/logs
log_level = info

[server]
private_key = e37347d67d53ca9bae69d3f842655da3

[storage]
data_dir = $CONF_PATH/md-server-data

EOF
fi

}


case $1 in
    "start" )
        start_server
        ;;
    "python-env" )
        run_python_wth_env "$@"
        ;;
    "pytest" )
        run_pytest_wth_env "$@"
        ;;
    "env" )
        run_with_env "$@"
        ;;
    "install" )
        install_compiled
        ;;
    "fetch" )
        fetch
        ;;
    "compile" )
        compile
        ;;
    "start-frontend" )
        start_frontend
        ;;
    "start-dtable-web" )
        start_dtable_web
        ;;
    "start-dtable-frontend" )
        start_dtable_frontend
        ;;
    "start-dtable" )
        start_dtable
        ;;
    * )
        start_server
        ;;
esac
