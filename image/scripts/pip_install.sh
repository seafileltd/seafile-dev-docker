#!/bin/bash

if [[ ! -e /root/scripts/requirements.txt ]]; then
    echo 'Do not find requirements.txt and events-requirements.txt, you should copy these files to scripts/ dir.'
    exit 1
fi

pip3 install --no-cache-dir --ignore-installed \
    Django==5.2.* \
    mock \
    exam \
    splinter \
    pytest \
    pytest-django \
    python-cas \
    cffi \
    sqlalchemy \
    pymysql \
    configparser \
    pylibmc \
    django-pylibmc \
    fabric3 \
    oss2 \
    boto3 \
    lxml \
    pytz

if [[ $? != 0 ]]; then
    exit 1
fi

pip3 install --no-cache-dir --ignore-installed -r /root/scripts/events-requirements.txt

if [[ $? != 0 ]]; then
    exit 1
fi

pip3 install --no-cache-dir --ignore-installed -r /root/scripts/requirements.txt

if [[ $? != 0 ]]; then
    exit 1
fi

sleep 1

# fix fabric3
sed -i 's/^from collections import Mapping/from collections.abc import Mapping/' /usr/local/lib/python3.12/dist-packages/fabric/main.py
