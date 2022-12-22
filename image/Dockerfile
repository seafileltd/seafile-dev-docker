FROM phusion/baseimage:focal-1.2.0

ENV UPDATE_AT=202212 BRANCH=master COMPILE_PATH=/data/compiled SOURCE_PATH=/data/dev LOG_PATH=/data/logs CONF_PATH=/data/conf

RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN apt-get update && apt-get upgrade -y

# See https://manual.seafile.com/develop/env.html
RUN apt-get install -y ssh libevent-dev libcurl4-openssl-dev libglib2.0-dev \
  uuid-dev intltool libsqlite3-dev libmysqlclient-dev libarchive-dev libtool \
  libjansson-dev valac libfuse-dev cmake re2c flex sqlite3 htop \
  git libssl-dev libldap2-dev libonig-dev

# development tools
RUN apt-get install -y vim vim-scripts wget
RUN apt-get install -y cmake gcc

RUN apt-get install -y autoconf automake mysql-client
RUN apt-get install -y librados-dev libxml2-dev libjwt-dev
RUN apt-get install -y curl sudo telnet netcat unzip netbase ca-certificates \
  apt-transport-https build-essential libxslt1-dev libffi-dev libpcre3-dev \
  libz-dev xz-utils nginx

# libmemcached
RUN apt-get install -y libmemcached-dev

# set up the repository for nodejs 10 and npm
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
RUN apt-get install -y nodejs

# set python3 global
RUN apt-get install -y python3.8 python3-pip python3-setuptools python3-ldap python3-rados \
    python3-dateutil python3-simplejson
RUN python3 -m pip install --upgrade pip && rm -r /root/.cache/pip
RUN rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python && \
    rm -f /usr/bin/pip && ln -s /usr/local/bin/pip3 /usr/bin/pip

# install python packages
COPY scripts /root/scripts
RUN /root/scripts/pip_install.sh && rm -r /root/.cache/pip

# scripts
RUN rm -rf /etc/my_init.d/*
COPY scripts/01_init.sh scripts/02_aliass.sh /etc/my_init.d/
RUN mkdir -p /root/.ssh/

# set up dtable development env
COPY scripts/default /etc/nginx/sites-available/default

# https://github.com/phusion/baseimage-docker/blob/master/README_ZH_cn_.md
CMD ["/sbin/my_init", "--", "/root/scripts/enterpoint.sh"]
