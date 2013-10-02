#!/usr/bin/env bash

KOPF_GIT_URL=https://github.com/lmenezes/elasticsearch-kopf.git
INQUISITOR_GIT_URL=https://github.com/polyfractal/elasticsearch-inquisitor.git
PARAMEDIC_GIT_URL=https://github.com/karmi/elasticsearch-paramedic.git
HEAD_GIT_URL=https://github.com/mobz/elasticsearch-head.git
ICU_GIT_URL=https://github.com/elasticsearch/elasticsearch-analysis-icu.git

DIRECTORY='plugins'
options=':l:h'

usage(){
  echo "-l deploy local to folder"
  echo "-h deploy to heroku"
}

write_config_ru(){
  echo -e "map '/' do
    use Rack::Static, urls: [''],
                      root: File.expand_path('./'),
                      index: 'index.html'
    run lambda {}
  end" > config.ru
}

deploy_local(){
  directory=$1
  git clone $KOPF_GIT_URL $directory/kopf
  git clone $INQUISITOR_GIT_URL $directory/inquisitor
  git clone $PARAMEDIC_GIT_URL $directory/paramedic 
  git clone $HEAD_GIT_URL $directory/head
  git clone $ICU_GIT_URL $directory/icu
  cd $directory
  write_config_ru
  write_index
}

write_index(){
  echo -e "<!DOCTYPE html>
  <html>
    <head>
      <title>Elasticsearch plugins</title>
      <style type='text/css'>
        .text{
          font-size: 16px;
          font-family: Arial;
        }
        ul{
          list-style: none;
      }
      </style>
    </head>
    <body>
      <ul>
        <li><a href='/kopf/index.html'><span class='text'>kopf</span></a></li>
        <li><a href='/inquisitor/_site/index.html'><span class='text'>inquisitor</span></a></li>
        <li><a href='/paramedic/index.html'><span class='text'>paramedic</span></a></li>
        <li><a href='/head/index.html'><span class='text'>head</span></a></li>
      </ul>
    </body>
  </html>" > index.html
}

deploy_heroku(){
  mkdir $DIRECTORY
  cd $DIRECTORY
  git init

  write_config_ru

  echo -e "source 'https://rubygems.org/'
  ruby '2.0.0'
  gem 'rack'" > Gemfile
  bundle install
  write_index

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


