pip install python-cas djangosaml2 sqlalchemy pillow elasticsearch \
  elasticsearch-dsl pycryptodome

cd /tmp
wget https://raw.githubusercontent.com/haiwen/seahub/${BRANCH}/requirements.txt
wget https://raw.githubusercontent.com/haiwen/seahub/${BRANCH}/test-requirements.txt

pip install -r requirements.txt
pip install -r test-requirements.txt
