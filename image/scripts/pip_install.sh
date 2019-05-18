pip install sqlalchemy pillow mysql-python elasticsearch==5.5.0 elasticsearch-dsl==5.4.0

wget https://raw.githubusercontent.com/haiwen/seahub/${BRANCH}/requirements.txt
wget https://raw.githubusercontent.com/haiwen/seahub/${BRANCH}/test-requirements.txt

pip install -r requirements.txt
pip install -r test-requirements.txt
