#
# Copyright 2019 isobar. All Rights Reserved.
#
# The isobar node image
#
# Usage:
#       dk build -t isobar/node-8:1.0.0 -f Dockerfile .
#
FROM node:8-alpine
LABEL maintainer "jacky.huang@isobar.com"

RUN apk --no-cache add curl git openssl

# Define default command.
CMD ["curl", "-V"]
