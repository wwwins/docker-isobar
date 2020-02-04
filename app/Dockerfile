#
# Copyright 2019 isobar. All Rights Reserved.
#
# The isobar app image
#
# Usage:
#       dk build -t isobar/app:1.0.0 -f Dockerfile .
#
FROM isobar/node:canvas
LABEL maintainer "jacky.huang@isobar.com"

WORKDIR /home/app

COPY app .
RUN npm install

# Installing dependencies and node-canvas
{INSTALL_NODE_CANVAS}

# Define default command.
#CMD ["npm", "start"]
CMD ["pm2-runtime", "start", "pm2.json"]
