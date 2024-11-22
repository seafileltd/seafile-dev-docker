#!/bin/bash

# Install gettext old version

apt purge -y gettext

cd /tmp

tar -zxvf /root/scripts/gettext-0.19.8.1.tar.gz

cd /tmp/gettext-0.19.8.1

./configure && make && make install

rm -rf /tmp/gettext-0.19.8.1

cd /
