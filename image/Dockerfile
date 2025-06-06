FROM ubuntu:24.04

# https://github.com/phusion/baseimage-docker
COPY base_scripts /bd_build
RUN /bd_build/prepare.sh && \
    /bd_build/system_services.sh && \
    /bd_build/utilities.sh && \
    /bd_build/cleanup.sh
ENV DEBIAN_FRONTEND="teletype" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

ENV UPDATE_AT=202410 BRANCH=master COMPILE_PATH=/data/compiled SOURCE_PATH=/data/dev LOG_PATH=/data/logs CONF_PATH=/data/conf

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
RUN apt-get install -y curl sudo telnet netcat-traditional unzip netbase ca-certificates \
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
RUN apt-get install -y python3 python3-pip python3-dev python3-setuptools python3-ldap python3-rados \
    python3-dateutil python3-simplejson && \
    rm /usr/lib/python3.12/EXTERNALLY-MANAGED

# install python packages
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib
COPY scripts /root/scripts
RUN /root/scripts/transifex-install.sh
RUN /root/scripts/gettext-install.sh
RUN /root/scripts/pip_install.sh

# scripts
RUN rm -rf /etc/my_init.d/* && mkdir -p /root/.ssh/
COPY scripts/01_init.sh scripts/02_aliass.sh /etc/my_init.d/

# set up dtable development env
COPY scripts/default /etc/nginx/sites-available/default

# https://github.com/phusion/baseimage-docker/blob/master/README_ZH_cn_.md
CMD ["/sbin/my_init", "--", "/root/scripts/enterpoint.sh"]
