#!/usr/bin/env bash

KOPF_GIT_URL=https://github.com/lmenezes/elasticsearch-kopf.git
INQUISITOR_GIT_URL=https://github.com/polyfractal/elasticsearch-inquisitor.git
PARAMEDIC_GIT_URL=https://github.com/karmi/elasticsearch-paramedic.git
HEAD_GIT_URL=https://github.com/mobz/elasticsearch-head.git
ICU_GIT_URL=https://github.com/elasticsearch/elasticsearch-analysis-icu.git
BIGDESK_GIT_URL=https://github.com/lukas-vlcek/bigdesk.git

DIRECTORY='plugins'
options=':l:uch'
create_update= 

usage(){
  echo "-l <path> deploy local to folder"
  echo "-c -h deploy to heroku and create new app"
  echo "-u -h deploy to heroku and update app"
}

copy_files(){
  cp -R files/. plugins/
}

deploy_local(){
  directory=$1
  git clone $KOPF_GIT_URL $directory/kopf
  git clone $INQUISITOR_GIT_URL $directory/inquisitor
  git clone $PARAMEDIC_GIT_URL $directory/paramedic 
  git clone $HEAD_GIT_URL $directory/head
  git clone $ICU_GIT_URL $directory/icu
  git clone $BIGDESK_GIT_URL $directory/bigdesk
  copy_files
}

update_heroku(){
  cd $DIRECTORY
  git submodule foreach git pull origin master
  cd ..
}

create_heroku(){
  mkdir $DIRECTORY

  copy_files

  cd $DIRECTORY
  git init
  git add .
  git commit -m "initial commit"

  git submodule add $KOPF_GIT_URL kopf
  git submodule add $INQUISITOR_GIT_URL inquisitor
  git submodule add $PARAMEDIC_GIT_URL paramedic
  git submodule add $HEAD_GIT_URL head
  git submodule add $ICU_GIT_URL icu
  git submodule add $BIGDESK_GIT_URL bigdesk
  git commit -m "added submodules"
  heroku create
}

deploy_heroku(){
  if [[ -z "$1" ]]; then
    usage
    exit 1
  fi
  if [[ $1 = 'u' ]]; then
    update_heroku
  fi
  if [[ $1 = 'c' ]]; then
    create_heroku
  fi
  cd $DIRECTORY
  git push heroku master
  cd ..
}

while getopts $options opt; do
  case $opt in
    l) deploy_local $2;;
    h) deploy_heroku $create_update;;
    u) create_update='u';;
    c) create_update='c';;
    *) usage;;
  esac
done

