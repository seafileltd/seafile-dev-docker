# cd /tmp
# wget https://raw.githubusercontent.com/haiwen/seahub/${BRANCH}/requirements.txt
# wget https://raw.githubusercontent.com/haiwen/seahub/${BRANCH}/test-requirements.txt
# pip install -r requirements.txt
# pip install -r test-requirements.txt

pip3 install -i https://mirrors.aliyun.com/pypi/simple \
    Django==3.2.* \
    future \
    captcha \
    django-statici18n \
    django-webpack_loader==0.7.0 \
    gunicorn \
    mysqlclient \
    django-picklefield==2.1.1 \
    openpyxl \
    qrcode \
    django-formtools==2.3 \
    django-simple-captcha \
    djangorestframework==3.11.1 \
    python-dateutil \
    requests \
    pillow \
    pyjwt==2.1.* \
    pycryptodome \
    requests_oauthlib
    chardet \
    python-cas \
    djangosaml2==0.20.0 \
    pysaml2==6.5.1 \
    cffi

pip3 install -i https://mirrors.aliyun.com/pypi/simple mock nose exam splinter pytest pytest-django

pip3 install -i https://mirrors.aliyun.com/pypi/simple python-cas djangosaml2 cffi sqlalchemy pymysql pillow \
  pycryptodome configparser pylibmc django-pylibmc \
  elasticsearch==5.5.0 elasticsearch-dsl==5.4.0
