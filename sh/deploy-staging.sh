#!/bin/sh
#
# Copyright 2020 isobar. All Rights Reserved.
#
# Usage:
#       deploy-staging.sh -n project-name -o project-owner -p port -t [init:update]
#


MOUNT=/mnt/sources
IMAGE_TAG=12-gm-pm2
ACT=checkout
DOCKER=docker

usage()
{
   echo ""
   echo "Usage: $0 -n project-name -o project-owner -p port -t [init|update]"
   echo "\t-n project name"
   echo "\t-o project owner"
   echo "\t-p port"
   echo "\t-t init or update"
   exit 1
}

while getopts "n:o:p:t:" opt
do
   case "$opt" in
      n ) APP="$OPTARG" ;;
      o ) USER="$OPTARG" ;;
      p ) PORT="$OPTARG" ;;
      t ) ACT="$OPTARG" ;;
      ? ) usage ;;
   esac
done

# Print usage in case parameters are empty
if [ -z "$APP" ] || [ -z "$USER" ] || [ -z "$PORT" ] || [ -z "$ACT" ]
then
   echo "Invalid options";
   usage
fi

PROJECT=$MOUNT/$APP
GIT_PROJECT=$USER/$APP
FILE=$PROJECT/.git

# Update this repository
if [ -d $FILE ]; then
  echo "Project does exist"
  cd $PROJECT
  echo "Updating the project"
  git pull
else
  echo "Project does not exist"
  git clone git@gitlab.isobar.com.tw:$GIT_PROJECT.git $PROJECT
fi

if [ $ACT = "init" ]; then
  echo "Starting $APP"
  #docker run --rm -d --name app-staging -p 8000:8000 -v /home/ubuntu/Downloads/mnt/app-staging:/workspace isobartw/node:lts yarn install && node src/app.js
  #docker run --rm --name $APP -p 8000:8000 -v /home/ubuntu/Downloads/mnt/app-staging:/workspace isobar/node:12-alpine-pm2
  $DOCKER run --rm --name $APP -p $PORT:8000 -v $PROJECT:/workspace isobartw/node:$IMAGE_TAG
fi

if [ $ACT = "update" ]; then
  echo "Update $APP"
  docker exec $APP yarn install
fi

