# cd /tmp
# wget https://raw.githubusercontent.com/haiwen/seahub/${BRANCH}/requirements.txt
# wget https://raw.githubusercontent.com/haiwen/seahub/${BRANCH}/test-requirements.txt
# pip install -r requirements.txt
# pip install -r test-requirements.txt

pip3 install -i https://mirrors.aliyun.com/pypi/simple \
    Django==3.2.16 \
    django-statici18n==2.3.1 \
    django_webpack_loader==1.7.0 \
    django_picklefield==3.1 \
    django_formtools==2.4 \
    django_simple_captcha==0.5.17 \
    djangosaml2==1.5.3 \
    djangorestframework==3.14.0 \
    python-dateutil==2.8.2 \
    pyjwt==2.6.0 \
    pycryptodome==3.16.0 \
    python-cas==1.6.0 \
    pysaml2==7.2.1 \
    requests==2.28.1 \
    requests_oauthlib==1.3.1 \
    future==0.18.2 \
    gunicorn==20.1.0 \
    mysqlclient==2.1.1 \
    qrcode==7.3.1 \
    pillow==9.3.0 \
    chardet==5.1.0 \
    cffi==1.15.1 \
    captcha==0.4 \
    openpyxl==3.0.10 \
    Markdown==3.4.1 \
    bleach==5.0.1 \

pip3 install -i https://mirrors.aliyun.com/pypi/simple mock nose exam splinter pytest pytest-django

pip3 install -i https://mirrors.aliyun.com/pypi/simple \
    sqlalchemy==1.4.44 \
    pymysql==1.0.2 \
    configparser==5.3.0 \
    pylibmc==1.6.3 \
    django-pylibmc==0.6.1 \
    redis==4.3.5 \
    elasticsearch==5.5.0 \
    elasticsearch-dsl==5.4.0
