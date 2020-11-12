#!/bin/bash
set -e

PROJECT=$1
BRANCH=$2


if [[ -z $BRANCH || -z $PROJECT ]]; then
    echo 'please type command like: seafile-checkout.sh Project_name Branch_name'
    exit 1
fi

if [[ ! -e ~/seafile/dev/${PROJECT} ]]; then
    echo "the project ${PROJECT} does not exists"
    exit 1
fi

cd ~/seafile/dev/${PROJECT}

if [ ! -z "$(git status --porcelain)" ]; then
    echo 'Working directory not clean'
    exit 0
fi

if [[ $(git branch --list ${BRANCH}) ]]; then
    echo
    read -p 'Branch already exists, should remove? [Y/N]' deleted
    if [[ ${deleted} == [Yy] ]]; then
        git Branch -D ${BRANCH}
    else
       echo 'please resolve this conflict first'
       exit 1
    fi
fi

git fetch origin ${BRANCH}:${BRANCH}
git checkout ${BRANCH}

if [[ ${PROJECT} =~ ^.*?ccnet.*?$ || ${PROJECT} =~ ^.*?seafile.*?$ ]]; then
    ./configure --prefix=${SOURCE_PATH} && make && make install
    . ~/seafile/dev/run.sh migrate
    echo "$PROJECT has been compiled"
fi

echo "Branch already checkout to $BRANCH"
