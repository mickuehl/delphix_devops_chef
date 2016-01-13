#!/usr/bin/env bash

export REPO=https://github.com/mickuehl/delphix_devops_ffcrm.git
export BRANCH=release
export APP_HOME=$SETUP_HOME/app_mysql

cd $SETUP_HOME

if [ ! -d "$APP_HOME" ];then
	git clone $REPO --branch $BRANCH app_mysql
	cp app_mysql/config/database.de.mysql.yml app_mysql/config/database.yml
else
	cd $APP_HOME
	git pull origin $BRANCH
fi

chown -R delphix:delphix $APP_HOME

su - delphix
cd $SETUP_HOME/app_mysql

# make sure bundler is installed and all gems are available
bundle install
