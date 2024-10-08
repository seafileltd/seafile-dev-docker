# cd /tmp
# wget https://raw.githubusercontent.com/haiwen/seahub/${BRANCH}/requirements.txt
# wget https://raw.githubusercontent.com/haiwen/seahub/${BRANCH}/test-requirements.txt
# pip install -r requirements.txt
# pip install -r test-requirements.txt

pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple/ \
    Django==4.2.* \
    django-statici18n==2.3.* \
    django_webpack_loader==1.7.* \
    django_picklefield==3.1 \
    django_formtools==2.4 \
    django_simple_captcha==0.6.* \
    djangosaml2==1.5.* \
    djangorestframework==3.14.* \
    python-dateutil==2.8.* \
    pyjwt==2.6.* \
    pycryptodome==3.20.* \
    python-cas==1.6.* \
    pysaml2==7.2.* \
    requests==2.31.* \
    requests_oauthlib==1.3.* \
    future==0.18.* \
    gunicorn==20.1.* \
    mysqlclient==2.1.* \
    qrcode==7.3.* \
    pillow==10.2.* \
    chardet==5.1.* \
    cffi==1.15.1 \
    captcha==0.5.* \
    openpyxl==3.0.* \
    Markdown==3.4.* \
    bleach==5.0.* \
    python-ldap==3.4.* \
    pypinyin==0.50.* \
    PyMuPDF==1.24.* \
    dnspython==2.6.*

pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple/ mock nose exam splinter pytest==7.4.4 pytest-django fabric3

pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple/ \
    sqlalchemy==2.0.18 \
    pymysql==1.0.* \
    configparser==5.3.* \
    pylibmc==1.6.* \
    django-pylibmc==0.6.* \
    redis==4.3.* \
    elasticsearch==8.5.2 \
    reportlab==3.4.* \
    pdfrw==0.4 \
    oss2==2.16.*
