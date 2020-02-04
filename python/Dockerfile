#
# Copyright 2019 isobar. All Rights Reserved.
#
# The isobar python image(From alpine:3.11)
#
# Usage:
#       dk build -t isobar/python:1.0.0 -f Dockerfile .
#
FROM python:3.5-alpine
LABEL maintainer "jacky.huang@isobar.com"

#WORKDIR /home/app

RUN apk add --no-cache libpng libjpeg-turbo zlib freetype musl && \
    apk add --no-cache --virtual .build-deps-full build-base python-dev libjpeg-turbo-dev libpng-dev zlib-dev freetype-dev && \
    pip install pillow-simd && \
#    pip install Pillow==4.3.0 && \
    pip install aiohttp && \
    pip install aiojobs && \
    pip install cchardet && \
    pip install gunicorn && \
    apk del .build-deps-full

CMD ["python", "-V"]
