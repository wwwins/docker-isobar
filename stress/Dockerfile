#
# Copyright 2019 isobar. All Rights Reserved.
#
# The isobar stress image(From alpine:3.10)
#
# Usage:
#       dk build -t isobar/stress-8:1.0.0 -f Dockerfile .
#
FROM containerstack/alpine-stress:latest
LABEL maintainer "jacky.huang@isobar.com"

COPY stress/docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["docker-entrypoint.sh"]

# Define default command.
CMD ["stress"]
