#
# Copyright 2019 isobar. All Rights Reserved.
#
# The isobar node image(From alpine:3.10)
#
# Usage:
#       dk build -t isobar/node-8:1.0.0 -f Dockerfile .
#
FROM node:8-alpine
LABEL maintainer "jacky.huang@isobar.com"

# add node-canvas
#RUN apk --no-cache add curl git openssl libpng librsvg libgsf giflib libjpeg-turbo musl && \
#    npm install pm2 -g

# add graphicsmagick
ENV GM_VER=1.3.34
RUN apk --no-cache add curl git openssl libpng libjpeg-turbo libgomp libltdl freetype musl && \
		apk add --no-cache --virtual .build-deps-full make automake autoconf gcc g++ libtool libjpeg-turbo-dev libpng-dev freetype-dev && \
    wget https://downloads.sourceforge.net/graphicsmagick/graphicsmagick/$GM_VER/GraphicsMagick-$GM_VER.tar.gz && \
    tar xvzf GraphicsMagick-$GM_VER.tar.gz && \
    cd GraphicsMagick-$GM_VER && \
    ./configure \
      --prefix=/usr \
      --sysconfdir=/etc \
      --mandir=/usr/share/man \
      --infodir=/usr/share/info \
      --localstatedir=/var \
      --enable-shared \
      --disable-static \
      --with-modules \
      --with-threads \
      --with-jpeg=yes \
      --with-jp2=yes \
      --with-gs-font-dir=/usr/share/fonts/Type1 \
      --with-quantum-depth=16 && \
		make && \
		make install && \
		cd .. && \
		rm -rf Graphics* && \
		apk del .build-deps-full && \
		npm install pm2 -g

# Define default command.
CMD ["pm2-runtime", "-V"]
