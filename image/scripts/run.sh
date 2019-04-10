#!/bin/bash

#set -e

function stop_server() {
    pkill -9 -f ccnet-server
    pkill -9 -f seaf-server
    pkill -9 -f runserver
    pkill -9 -f main
}

function set_env() {
    export CCNET_CONF_DIR=$CONF_PATH
    export SEAFILE_CONF_DIR=$CONF_PATH/seafile-data
    export PYTHONPATH=/usr/lib/python2.7/dist-packages:/usr/lib/python2.7/site-packages:/usr/local/lib/python2.7/dist-packages:/usr/local/lib/python2.7/site-packages:/data/dev/seahub/thirdpart:/data/dev/pyes/pyes:/data/dev/seahub-extra::/data/dev/portable-python-libevent/libevent:/data/dev/seafobj:/data/dev/:/data/dev/seahub/seahub/:$CONF_PATH:$PYTHONPATH
    export SEAFES_DIR=/data/dev/seafes/
}

function start_server() {
    stop_server

    set_env

    ccnet-server -c $CONF_PATH -D all -L /data -f - &
    sleep 0.5
    seaf-server -c $CONF_PATH -d $CONF_PATH/seafile-data -D all -f -l - &
    sleep 0.5
    cd /data/dev/seahub
    python manage.py runserver 0.0.0.0:8000 &
    cd ../seafevents
    sleep 0.5
    python main.py --config-file $CONF_PATH/seafevents.conf &
    # Seafevents cannot start without sleep for a few seconds
    sleep 2
}

function start_frontend {
    set_env
    cd /data/dev/seahub/frontend
    npm run dev &
}

function check_python_executable() {
    if [[ "$PYTHON" != "" && -x $PYTHON ]]; then
        return 0
    fi

    if which python2.7 2>/dev/null 1>&2; then
        PYTHON=python2.7
    elif which python27 2>/dev/null 1>&2; then
        PYTHON=python27
    else
        echo
        echo "Can't find a python executable of version 2.7 or above in PATH"
        echo "Install python 2.7+ before continue."
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
}

function fetch() {
    prepare_init
    cd $SOURCE_PATH

    if [ ! -d "libmemcached-1.0.18" ];then
        wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz && tar xf libmemcached-1.0.18.tar.gz
    fi
    ssh-keygen -F github.com || ssh-keyscan github.com >>~/.ssh/known_hosts

    if [ ! -d "libevhtp" ];then
        git clone git@github.com:haiwen/libevhtp.git
    else
        cd libevhtp && git pull && cd ..
    fi

    if [ ! -d "libsearpc" ];then
        git clone git@github.com:haiwen/libsearpc.git
    else
        cd libsearpc && git pull && cd ..
    fi

    if [ ! -d "seafobj" ]; then
        git clone git@github.com:haiwen/seafobj.git
    else
        cd seafobj && git pull && cd ..
    fi

    if [ ! -d "portable-python-libevent" ]; then
        git clone git@github.com:seafileltd/portable-python-libevent.git
    else
        cd portable-python-libevent && git pull && cd ..
    fi

    if [ ! -d "ccnet-pro-server" ]; then
        git clone git@github.com:seafileltd/ccnet-pro-server.git
    else
        cd ccnet-pro-server && git pull && cd ..
    fi

    if [ ! -d "seafile-pro-server" ]; then
        git clone git@github.com:seafileltd/seafile-pro-server.git
    else
        cd seafile-pro-server && git pull && cd ..
    fi

    if [ ! -d "/data/dev/seahub" ]; then
        cd /data/dev && git clone git@github.com:/haiwen/seahub.git
    else
        cd /data/dev/seahub && git pull && cd -
    fi

    if [ ! -d "/data/dev/seahub-extra" ]; then
        cd /data/dev && git clone git@github.com:seafileltd/seahub-extra.git
    else
        cd /data/dev/seahub-extra && git pull && cd -
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
}


function compile() {

    cd $SOURCE_PATH

    cd libmemcached-1.0.18/ && ./configure --prefix=$COMPILE_PATH && make && make install && ldconfig && cd ..
    install_compiled

    cd libevhtp/ && cmake -DCMAKE_INSTALL_PREFIX:PATH=$COMPILE_PATH -DEVHTP_DISABLE_SSL=OFF -DEVHTP_BUILD_SHARED=ON . && make && make install && ldconfig && cd ..
    install_compiled

    cd libsearpc && ./autogen.sh && ./configure --prefix=$COMPILE_PATH && make && make install && ldconfig && cd ..
    install_compiled

    cd ccnet-pro-server && ./autogen.sh && ./configure --prefix=$COMPILE_PATH && make && make install && ldconfig && cd ..

    install_compiled

    ccnet-init -c $CONF_PATH -n zming -H 127.0.0.1

    cd seafile-pro-server && ./autogen.sh && ./configure --disable-fuse --prefix=$COMPILE_PATH && make && make install && ldconfig && cd ..

    install_compiled

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
EOF

    if [ ! -f "$CONF_PATH/seafile-data/seafile.conf" ]; then
        cd $CONF_PATH && seaf-server-init -d seafile-data/ && echo "$CONF_PATH/seafile-data" > seafile.ini && cd ..

        cd conf && echo -en "\n[Database]\nENGINE = mysql\nHOST = db\nPORT = 3306\nUSER = root\nPASSWD = db_dev\nDB = ccnet\nCONNECTION_CHARSET = utf8\nCREATE_TABLES = true" >> ccnet.conf && echo -en "\n[database]\ntype = mysql\nhost = db\nport = 3306\nuser = root\npassword = db_dev\ndb_name = seafile\nconnection_charset = utf8\ncreate_tables = true" >> seafile-data/seafile.conf && cd -
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
    * )
        start_server
        ;;
esac
