#!/bin/bash

# cd /tmp
# wget https://raw.githubusercontent.com/haiwen/seahub/${BRANCH}/requirements.txt
# wget https://raw.githubusercontent.com/haiwen/seahub/${BRANCH}/test-requirements.txt
# pip install -r requirements.txt
# pip install -r test-requirements.txt

pip3 install --no-cache-dir \
    Django==4.2.* \
    django-statici18n==2.5.* \
    django_webpack_loader==1.7.* \
    django_picklefield==3.2.* \
    django_formtools==2.5.* \
    django_simple_captcha==0.6.* \
    djangosaml2==1.9.* \
    djangorestframework==3.15.* \
    python-dateutil==2.9.* \
    pyjwt==2.9.* \
    pycryptodome==3.20.* \
    python-cas==1.6.* \
    pysaml2==7.3.* \
    requests==2.32.* \
    requests_oauthlib==2.0.* \
    future==1.0.* \
    gunicorn==23.0.* \
    mysqlclient==2.2.* \
    qrcode==7.4.* \
    pillow==10.4.* \
    chardet==5.2.* \
    cffi==1.17.0 \
    captcha==0.6.* \
    openpyxl==3.1.* \
    Markdown==3.6.* \
    bleach==5.0.* \
    python-ldap==3.4.* \
    pypinyin==0.52.* \
    dnspython==2.6.* \
    pillow-heif==0.18.*

if [[ $? != 0 ]]; then
    exit 1
fi

pip3 install --no-cache-dir \
    SQLAlchemy==2.0.* \
    redis==5.0.* \
    pyjwt==2.9.* \
    pymysql==1.1.* \
    gevent==24.2.* \
    Flask==3.0.* \
    apscheduler==3.10.* \
    pyexiftool==0.4.* \
    beautifulsoup4==4.12.3 \
    markdown-it-py==3.0.0 \
    mdit_py_plugins==0.4.2 \
    linkify-it-py==2.0.3 \
    scikit-learn==1.3.*

if [[ $? != 0 ]]; then
    exit 1
fi

pip3 install --no-cache-dir \
    configparser==5.3.* \
    pylibmc==1.6.* \
    django-pylibmc==0.6.* \
    elasticsearch==8.5.2 \
    pdfrw==0.4 \
    oss2==2.16.* \
    mock \
    exam \
    splinter \
    pytest==7.4.4 \
    pytest-django \
    fabric3

if [[ $? != 0 ]]; then
    exit 1
fi

sleep 1

# fix fabric3
sed -i 's/^from collections import Mapping/from collections.abc import Mapping/' /usr/local/lib/python3.12/dist-packages/fabric/main.py
