FROM phusion/baseimage:focal-1.2.0

ENV UPDATE_AT=202406 BRANCH=master COMPILE_PATH=/data/compiled SOURCE_PATH=/data/dev LOG_PATH=/data/logs CONF_PATH=/data/conf

RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN apt-get update --fix-missing && apt-get upgrade -y
RUN apt-get install -y software-properties-common

RUN add-apt-repository -y ppa:longsleep/golang-backports

# See https://manual.seafile.com/develop/env.html
RUN apt-get install -y ssh libevent-dev libcurl4-openssl-dev libglib2.0-dev
RUN apt-get install -y uuid-dev intltool libsqlite3-dev libarchive-dev libtool \
    libjansson-dev valac libfuse-dev cmake re2c flex sqlite3 htop \
    git libssl-dev libldap2-dev libonig-dev libargon2-dev

# development tools
RUN apt-get install -y vim vim-scripts wget \
    cmake gcc

RUN apt-get install -y autoconf automake libmysqlclient-dev mysql-client
RUN apt-get install -y librados-dev libxml2-dev libjwt-dev
RUN apt-get install -y curl sudo telnet netcat unzip netbase ca-certificates \
    apt-transport-https build-essential libxslt1-dev libffi-dev libpcre3-dev \
    libz-dev xz-utils nginx \
    libmemcached-dev \
    zlib1g-dev

RUN cd /tmp && wget https://github.com/redis/hiredis/archive/refs/tags/v1.1.0.tar.gz && tar -zxvf v1.1.0.tar.gz && \
    cd hiredis-1.1.0 && make && make install && cd / && rm -r /tmp/hiredis-1.1.0 && rm /tmp/v1.1.0.tar.gz && \
    ln -s /usr/local/lib/libhiredis.* /usr/lib/

# set up golang
RUN apt install golang-go -y
RUN go env -w GOPROXY=https://goproxy.cn

# set up the repository for nodejs 20 and npm
RUN curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
RUN apt-get install -y nodejs

# set python3 global
RUN apt-get install -y python3.8 python3-pip python3-setuptools python3-ldap python3-rados \
    python3-dateutil python3-simplejson
RUN python3 -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple/ && rm -r /root/.cache/pip
RUN rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python && \
    rm -f /usr/bin/pip && ln -s /usr/local/bin/pip3 /usr/bin/pip

# install python packages
COPY scripts /root/scripts
RUN /root/scripts/pip_install.sh && rm -r /root/.cache/pip

# scripts
RUN rm -rf /etc/my_init.d/* && mkdir -p /root/.ssh/
COPY scripts/01_init.sh scripts/02_aliass.sh /etc/my_init.d/

# set up dtable development env
COPY scripts/default /etc/nginx/sites-available/default

# https://github.com/phusion/baseimage-docker/blob/master/README_ZH_cn_.md
CMD ["/sbin/my_init", "--", "/root/scripts/enterpoint.sh"]
