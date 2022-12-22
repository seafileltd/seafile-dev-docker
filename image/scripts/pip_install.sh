# cd /tmp
# wget https://raw.githubusercontent.com/haiwen/seahub/${BRANCH}/requirements.txt
# wget https://raw.githubusercontent.com/haiwen/seahub/${BRANCH}/test-requirements.txt
# pip install -r requirements.txt
# pip install -r test-requirements.txt

pip3 install -i https://mirrors.aliyun.com/pypi/simple \
    Django==3.2.* \
    django-statici18n==2.3.* \
    django_webpack_loader==1.7.* \
    django_picklefield==3.1 \
    django_formtools==2.4 \
    django_simple_captcha==0.5.* \
    djangosaml2==1.5.* \
    djangorestframework==3.14.* \
    python-dateutil==2.8.* \
    pyjwt==2.6.* \
    pycryptodome==3.16.* \
    python-cas==1.6.* \
    pysaml2==7.2.* \
    requests==2.28.* \
    requests_oauthlib==1.3.* \
    future==0.18.* \
    gunicorn==20.1.* \
    mysqlclient==2.1.* \
    qrcode==7.3.* \
    pillow==9.3.* \
    chardet==5.1.* \
    cffi==1.15.1 \
    captcha==0.4 \
    openpyxl==3.0.* \
    Markdown==3.4.* \
    bleach==5.0.*

pip3 install -i https://mirrors.aliyun.com/pypi/simple mock nose exam splinter pytest pytest-django

pip3 install -i https://mirrors.aliyun.com/pypi/simple python-cas djangosaml2 cffi sqlalchemy pymysql pillow \
  pycryptodome configparser pylibmc django-pylibmc \
  elasticsearch==5.5.0 elasticsearch-dsl==5.4.0
