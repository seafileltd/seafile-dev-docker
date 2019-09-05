FROM phusion/baseimage:0.11

ENV UPDATE_AT=20190826 BRANCH=python3-master COMPILE_PATH=/data/compiled SOURCE_PATH=/data/dev LOG_PATH=/data/logs CONF_PATH=/data/conf

RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN apt-get update && apt-get upgrade -y

# See https://manual.seafile.com/develop/env.html
RUN apt-get install -y ssh libevent-dev libcurl4-openssl-dev libglib2.0-dev \
  uuid-dev intltool libsqlite3-dev libmysqlclient-dev libarchive-dev libtool \
  libjansson-dev valac libfuse-dev python-dateutil cmake re2c flex sqlite3 python-pip \
  python-simplejson git libssl-dev libldap2-dev libonig-dev


# development tools
RUN apt-get install -y vim vim-scripts wget
RUN apt-get install -y cmake gcc

RUN apt-get install -y autoconf automake mysql-client
RUN apt-get install -y librados-dev libxml2-dev
RUN apt-get install -y curl sudo telnet netcat unzip netbase ca-certificates \
  apt-transport-https build-essential libxslt1-dev libffi-dev libpcre3-dev \
  libz-dev xz-utils nginx

# build-in office and file search
RUN apt-get install -y pkg-config poppler-utils
# RUN apt-get install -y libreoffice libreoffice-script-provider-python
# RUN apt-get install -y ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy

# libmemcached
RUN apt-get install -y libmemcached-dev

# set up the repository for nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs

# set python3.7 global
RUN apt-get install -y python3-dev python3-pip python3.7 python3.7-dev
RUN python3.7 -m pip install --upgrade pip
RUN rm /usr/bin/python; exit 0
RUN rm /usr/bin/python3; exit 0
RUN rm /usr/bin/pip; exit 0
RUN rm /usr/bin/pip3; exit 0
RUN ln -s /usr/bin/python3.7 /usr/bin/python
RUN ln -s /usr/bin/python3.7 /usr/bin/python3
RUN ln -s /usr/local/bin/pip3.7 /usr/bin/pip
RUN ln -s /usr/local/bin/pip3.7 /usr/bin/pip3

RUN apt-get autoremove -y && apt-get autoclean -y


# scripts
RUN rm -rf /etc/my_init.d/*
COPY scripts/01_init.sh scripts/02_aliass.sh /etc/my_init.d/
COPY scripts /root/scripts
RUN mkdir -p /root/.ssh/

# install python packages
RUN . /root/scripts/pip_install.sh
RUN rm -rf ~/.cache/pip

# https://github.com/phusion/baseimage-docker/blob/master/README_ZH_cn_.md
CMD ["/sbin/my_init", "--", "/root/scripts/enterpoint.sh"]
