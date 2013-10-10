#!/usr/bin/env bash

KOPF_GIT_URL=https://github.com/lmenezes/elasticsearch-kopf.git
INQUISITOR_GIT_URL=https://github.com/polyfractal/elasticsearch-inquisitor.git
PARAMEDIC_GIT_URL=https://github.com/karmi/elasticsearch-paramedic.git
HEAD_GIT_URL=https://github.com/mobz/elasticsearch-head.git
ICU_GIT_URL=https://github.com/elasticsearch/elasticsearch-analysis-icu.git

DIRECTORY='plugins'
options=':l:h'

usage(){
  echo "-l <path> deploy local to folder"
  echo "-h deploy to heroku"
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
  cd $directory
}

deploy_heroku(){
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
  git commit -m "added submodules"

  heroku create
  git push heroku master
}
while getopts $options opt; do
  case $opt in
    l) deploy_local $2;;
    h) deploy_heroku;;
    *) usage;;
  esac
done


