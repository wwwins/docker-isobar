#
# Copyright 2019-2022 isobar. All Rights Reserved.
#
# without canvas:
# 	make app-build
#
# with canvas:
# 	make app-canvas-build(=make)
#
# node8:
# 	make node-build
# node12:
# 	make node12-build
# isobar node12:
# 	make isobar-node-build
# isobar node12 update:
# 	docker login(First)
# 	make isobar-node-update
#
# ab benchmark:
# 	make c1
# 	make c100
# 	make c500
# 	make coc COC=200 COC_REQ=2000
#
# app run:
# 	make app-run
# 	make app-mongo-run
#
DK = docker
DOCKER = sudo docker
MKDIR = sudo mkdir -p
TOUCH = sudo touch
CP = sudo cp
SED = sed -e
AB = ab
RUN = run --rm
OVERLOAD = util/server-overload.sh
OVERLOAD_C = util/server-overload-c.sh
COC = 1
COC_REQ = 1000

HOST_NAME = http://4ichatbot.isobar.com.tw/
#HOST_NAME = http://10.65.16.237:8000/

#API = mongo/updateAndFind/myCollection
#API = mongo/loop/myCollection/10
#API = img/00AAAA/test1.9.0-from-ab
#API = png/00AAAA/test1.11.0-from-ab-1cpu-200110
#API = png/00AA00/test2.3.0-from-ab-0114
#API = img/00AAAA/test1.9.0-from-ab
#API = png/00AAAA/test2.2.0-from-ab
#API = jpg/00AAAA/test2.2.0-from-ab
#API = jpg/00AAAA/app-1.11.0-from-ab-中文
API = png/00AAAA/app-1.11.0-from-ab-中文
#API = png/00AAAA/app-py-1.3.0-from-ab-中文
#API = mongo/loop/myCollection/10
#API = mongo/updateAndFind/myCollection

HOST = $(HOST_NAME)$(API)

# v1.x.x
#APP_DIR = app
# v2.x.x for GraphicsMagick
APP_DIR = app-dev

# Tag
NODE_8_TAG = 1.3.0
#NODE_12_TAG = 1.0.0
#NODE_12_TAG = 12-alpine-gm
NODE_12_TAG = 12-alpine-gm-pm2
#NODE_12_TAG = 12-alpine
#NODE_FFMPEG_TAG = 12-alpine-ffmpeg
NODE_FFMPEG_TAG = 12-alpine-gm-ffmpeg-pm2
#NODE_FFMPEG_TAG = 12-alpine-gm-ffmpeg
NODE_12_CANVAS_TAG = 12-alpine-gm-canvas-pm2
NODE_CANVAS_TAG = 1.1.0
PYTHON_TAG = 1.3.0
PYZBAR_TAG = zbar
FFMPEG_TAG = 4.2-ubuntu
#APP_TAG = 1.11.0
APP_TAG = 2.3.0
HLS_TAG = 1.1.0
NFS_TAG = 1.0.0
DEV_TAG = 1.2.0
STRESS_TAG = 1.0.0

GCR_IMAGE_NAME_APP = asia.gcr.io/isobar-gcp-k8s/app
GCR_IMAGE_NAME_NFS = asia.gcr.io/isobar-gcp-k8s/nfs
GCR_IMAGE_NAME_STRESS = asia.gcr.io/isobar-gcp-k8s/stress

BUILD_NODE_CANVAS = RUN apk add --no-cache --virtual .build-deps-full make gcc g++ python pkgconfig pixman-dev cairo-dev pango-dev libjpeg-turbo-dev giflib-dev lzip \&\& npm install canvas --save \&\& npm install gifencoder --save \&\& apk del .build-deps-full

default: app-canvas-build

app-push: gcr-tag gcr-push
hls-build-push: hls-build hls-tag hls-push
nfs-push: gcr-nfs-tag gcr-nfs-push
stress-push: gcr-stress-tag gcr-stress-push
isobar-node-update: isobar-node-clean isobar-node-build isobartw-tags isobartw-push

rm: rmc rmi

gcr-tag:
		@echo
		@echo "Create a tag for gcr.io"
		$(DOCKER) tag isobar/app:$(APP_TAG) $(GCR_IMAGE_NAME_APP):$(APP_TAG)

gcr-push:
		@echo
		@echo "Push a stable docker image to google container registry"
		$(DOCKER) -- push $(GCR_IMAGE_NAME_APP):$(APP_TAG)

gcr-nfs-tag:
		@echo
		@echo "Create a tag for gcr.io"
		$(DOCKER) tag isobar/nfs:$(NFS_TAG) $(GCR_IMAGE_NAME_NFS):$(NFS_TAG)

gcr-nfs-push:
		@echo
		@echo "Push a stable docker image to google container registry"
		$(DOCKER) -- push $(GCR_IMAGE_NAME_NFS):$(NFS_TAG)

gcr-stress-tag:
		@echo
		@echo "Create a tag for gcr.io"
		$(DOCKER) tag isobar/stress:$(STRESS_TAG) $(GCR_IMAGE_NAME_STRESS):$(STRESS_TAG)

gcr-stress-push:
		@echo
		@echo "Push a stable docker image to google container registry"
		$(DOCKER) -- push $(GCR_IMAGE_NAME_STRESS):$(STRESS_TAG)

hls-tag:
		@echo
		@echo "Create a tag for registry.isobar.com.tw"
		$(DOCKER) tag isobar/hls-service:$(HLS_TAG) registry.isobar.com.tw/project/amway/hls-service:$(HLS_TAG)

hls-push:
		@echo
		@echo "Push a image to registry.isobar.com.tw"
		$(DOCKER) push registry.isobar.com.tw/project/amway/hls-service

isobartw-tags:
		@echo
		@echo "Create tags for isobartw"
		$(DK) tag isobar/node:12-alpine 								isobartw/node:12-alpine
		$(DK) tag isobar/node:12-alpine 								isobartw/node:12
		$(DK) tag isobar/node:12-alpine 								isobartw/node:lts
		$(DK) tag isobar/node:12-alpine-pm2 						isobartw/node:12-alpine-pm2
		$(DK) tag isobar/node:12-alpine-pm2 						isobartw/node:12-pm2
		$(DK) tag isobar/node:12-alpine-gm 							isobartw/node:12-alpine-gm
		$(DK) tag isobar/node:12-alpine-gm 							isobartw/node:12-gm
		$(DK) tag isobar/node:12-alpine-gm-pm2 					isobartw/node:12-alpine-gm-pm2
		$(DK) tag isobar/node:12-alpine-gm-pm2 					isobartw/node:12-gm-pm2
		$(DK) tag isobar/node:12-alpine-ffmpeg 					isobartw/node:12-alpine-ffmpeg
		$(DK) tag isobar/node:12-alpine-ffmpeg 					isobartw/node:12-ffmpeg
		$(DK) tag isobar/node:12-alpine-gm-ffmpeg 			isobartw/node:12-alpine-gm-ffmpeg
		$(DK) tag isobar/node:12-alpine-gm-ffmpeg 			isobartw/node:12-gm-ffmpeg
		$(DK) tag isobar/node:12-alpine-gm-ffmpeg-pm2 	isobartw/node:12-alpine-gm-ffmpeg-pm2
		$(DK) tag isobar/node:12-alpine-gm-ffmpeg-pm2 	isobartw/node:12-gm-ffmpeg-pm2

isobartw-push:
		@echo
		@echo "Push docker images to docker hub registry"
		$(DK) push isobartw/node:12-alpine
		$(DK) push isobartw/node:12
		$(DK) push isobartw/node:lts
		$(DK) push isobartw/node:12-alpine-pm2
		$(DK) push isobartw/node:12-pm2
		$(DK) push isobartw/node:12-alpine-gm
		$(DK) push isobartw/node:12-gm
		$(DK) push isobartw/node:12-alpine-gm-pm2
		$(DK) push isobartw/node:12-gm-pm2
		$(DK) push isobartw/node:12-alpine-ffmpeg
		$(DK) push isobartw/node:12-ffmpeg
		$(DK) push isobartw/node:12-alpine-gm-ffmpeg
		$(DK) push isobartw/node:12-gm-ffmpeg
		$(DK) push isobartw/node:12-alpine-gm-ffmpeg-pm2
		$(DK) push isobartw/node:12-gm-ffmpeg-pm2
		@echo
		@echo "Update all tagged images on the gitlab-runner"
		@echo "docker pull -a isobartw/node"

isobartw-node-tags:
		@echo
		@echo "Create tags for isobartw"
		$(DK) tag isobar/node:12-alpine 								isobartw/node:12-alpine
		$(DK) tag isobar/node:12-alpine 								isobartw/node:12
		$(DK) tag isobar/node:12-alpine 								isobartw/node:lts
		$(DK) tag isobar/node:12-alpine-pm2 						isobartw/node:12-alpine-pm2
		$(DK) tag isobar/node:12-alpine-pm2 						isobartw/node:12-pm2
		$(DK) tag isobar/node:12-alpine-gm 							isobartw/node:12-alpine-gm
		$(DK) tag isobar/node:12-alpine-gm 							isobartw/node:12-gm
		$(DK) tag isobar/node:12-alpine-gm-pm2 					isobartw/node:12-alpine-gm-pm2
		$(DK) tag isobar/node:12-alpine-gm-pm2 					isobartw/node:12-gm-pm2
		@echo "Added canvas tags"
		$(DK) tag isobar/node:12-alpine-gm-canvas				isobartw/node:12-alpine-gm-canvas
		$(DK) tag isobar/node:12-alpine-gm-canvas-pm2 	isobartw/node:12-alpine-gm-canvas-pm2
		$(DK) tag isobar/node:12-alpine-gm-canvas				isobartw/node:12-gm-canvas
		$(DK) tag isobar/node:12-alpine-gm-canvas-pm2 	isobartw/node:12-gm-canvas-pm2
		@echo "Added ffmpeg tags"
		$(DK) tag isobar/node:12-alpine-ffmpeg					isobartw/node:12-alpine-ffmpeg
		$(DK) tag isobar/node:12-alpine-ffmpeg					isobartw/node:12-ffmpeg
		$(DK) tag isobar/node:12-alpine-gm-ffmpeg 			isobartw/node:12-alpine-gm-ffmpeg
		$(DK) tag isobar/node:12-alpine-gm-ffmpeg 			isobartw/node:12-gm-ffmpeg
		$(DK) tag isobar/node:12-alpine-gm-ffmpeg-pm2		isobartw/node:12-alpine-gm-ffmpeg-pm2
		$(DK) tag isobar/node:12-alpine-gm-ffmpeg-pm2		isobartw/node:12-gm-ffmpeg-pm2

isobartw-node-push:
		@echo
		@echo "Push docker images to docker hub registry"
		$(DK) push isobartw/node:12-alpine
		$(DK) push isobartw/node:12
		$(DK) push isobartw/node:lts
		$(DK) push isobartw/node:12-alpine-pm2
		$(DK) push isobartw/node:12-pm2
		$(DK) push isobartw/node:12-alpine-gm
		$(DK) push isobartw/node:12-gm
		$(DK) push isobartw/node:12-alpine-gm-pm2
		$(DK) push isobartw/node:12-gm-pm2
		@echo "Push canvas tags"
		$(DK) push isobartw/node:12-alpine-gm-canvas
		$(DK) push isobartw/node:12-alpine-gm-canvas-pm2
		$(DK) push isobartw/node:12-gm-canvas
		$(DK) push isobartw/node:12-gm-canvas-pm2
		@echo "Push ffmpeg tags"
		$(DK) push isobartw/node:12-alpine-ffmpeg
		$(DK) push isobartw/node:12-ffmpeg
		$(DK) push isobartw/node:12-alpine-gm-ffmpeg
		$(DK) push isobartw/node:12-gm-ffmpeg
		$(DK) push isobartw/node:12-alpine-gm-ffmpeg-pm2
		$(DK) push isobartw/node:12-gm-ffmpeg-pm2

isobartw-zbar-tags:
		@echo
		@echo "Create tags for isobartw"
		$(DK) tag isobar/python:zbar isobartw/python:zbar

isobartw-zbar-push:
		@echo
		@echo "Push docker images to docker hub registry"
		$(DK) push isobartw/python:zbar

isobartw-ffmpeg-tags:
		@echo
		@echo "Create tags for isobartw"
		$(DK) tag isobar/ffmpeg:$(FFMPEG_TAG) isobartw/ffmpeg:$(FFMPEG_TAG)

isobartw-ffmpeg-push:
		@echo
		@echo "Push docker images to docker hub registry"
		$(DK) push isobartw/ffmpeg:$(FFMPEG_TAG)

node-build:
		@echo
		@echo "Build a node-8:$(NODE_8_TAG) image"
		$(DOCKER) build -t isobar/node-8:$(NODE_8_TAG) -f node/Dockerfile .

node12-build:
		@echo
		@echo "Build a node-12:$(NODE_12_TAG) image"
		#$(DOCKER) build -t isobar/node-12:$(NODE_12_TAG) -f node/Dockerfile .
		#$(DOCKER) build -t isobar/node:$(NODE_12_TAG) -f node/Dockerfile .
		$(DOCKER) build -t isobar/node:$(NODE_12_TAG) -f node/Dockerfile-12-GraphicsMagick-pm2 .

node12-ffmpeg-build:
		@echo
		@echo "Build a node-12:$(NODE_FFMPEG_TAG) with ffmpeg image"
		#$(DOCKER) build -t isobar/node:$(NODE_FFMPEG_TAG) -f node/Dockerfile-12-ffmpeg .
		#$(DOCKER) build -t isobar/node:$(NODE_FFMPEG_TAG) -f node/Dockerfile-12-GraphicsMagick-ffmpeg .
		$(DOCKER) build -t isobar/node:$(NODE_FFMPEG_TAG) -f node/Dockerfile-12-GraphicsMagick-ffmpeg-pm2 .

node12-canvas-build:
		@echo
		@echo "Build a node-12:${NODE_12_CANVAS_TAG} imgage"
		#$(DOCKER) build -t isobar/node:$(NODE_12_CANVAS_TAG) -f node/Dockerfile-12-GraphicsMagick-Canvas .
		$(DOCKER) build -t isobar/node:$(NODE_12_CANVAS_TAG) -f node/Dockerfile-12-GraphicsMagick-Canvas-pm2 .


node-canvas-build:
		@echo
		@echo "Build a node-canvas:$(NODE_CANVAS_TAG) image"
		$(DOCKER) build -t isobar/node-canvas:$(NODE_CANVAS_TAG) -f node-canvas/Dockerfile .

isobar-node-clean:
		@echo
		#echo "Make clean node images"
		$(DOCKER) rmi node:12-alpine

isobar-node-build:
		@echo
		@echo "Build a isobar node images"
		$(DOCKER) build -t isobar/node:12-alpine -f node/Dockerfile-12 .
		$(DOCKER) build -t isobar/node:12-alpine-pm2 -f node/Dockerfile-12-pm2 .
		$(DOCKER) build -t isobar/node:12-alpine-gm -f node/Dockerfile-12-GraphicsMagick .
		$(DOCKER) build -t isobar/node:12-alpine-gm-pm2 -f node/Dockerfile-12-GraphicsMagick-pm2 .
		$(DOCKER) build -t isobar/node:12-alpine-ffmpeg -f node/Dockerfile-12-ffmpeg .
		$(DOCKER) build -t isobar/node:12-alpine-gm-ffmpeg -f node/Dockerfile-12-GraphicsMagick-ffmpeg .
		$(DOCKER) build -t isobar/node:12-alpine-gm-ffmpeg-pm2 -f node/Dockerfile-12-GraphicsMagick-ffmpeg-pm2 .

python-build:
		@echo
		@echo "Build a python-3.5:$(PYTHON_TAG) image"
		$(DOCKER) build -t isobar/python-3.5:$(PYTHON_TAG) -f python/Dockerfile .

pyzbar-build:
		@echo
		@echo "Build a python-3.7:$(PYZBAR_TAG) image"
		$(DOCKER) build -t isobar/python:$(PYZBAR_TAG) -f python/Dockerfile-pyzbar .

ffmpeg-build:
		@echo
		@echo "Build a ffmpeg:$(FFMPEG_TAG) image"
		$(DOCKER) build -t isobar/ffmpeg:$(FFMPEG_TAG) -f ffmpeg/Dockerfile .

hls-build:
		@echo
		@echo "Build a hls:$(HLS_TAG) image"
		$(MKDIR) hls-service/upload
		$(MKDIR) hls-service/output
		$(MKDIR) hls-service/backup
		$(MKDIR) hls-service/logs
		$(MKDIR) hls-service/assets
		$(TOUCH) hls-service/assets/pic.jpg
		$(DOCKER) build -t isobar/hls-service:$(HLS_TAG) -f hls-service-dockerfile/Dockerfile .

app-build: BUILD_NODE_CANVAS:=
app-build:
		@echo
		@echo "Build a app:$(APP_TAG) image"
		$(SED) 's/{INSTALL_NODE_CANVAS}/$(BUILD_NODE_CANVAS)/' $(APP_DIR)/Dockerfile > $(APP_DIR)/Dockerfile.tmp
		$(DOCKER) build -t isobar/app:$(APP_TAG) -f $(APP_DIR)/Dockerfile.tmp .

app-canvas-build:
		@echo
		@echo "Build a app:$(APP_TAG) with node-canvas"
		$(SED) 's/{INSTALL_NODE_CANVAS}/$(BUILD_NODE_CANVAS)/' $(APP_DIR)/Dockerfile > $(APP_DIR)/Dockerfile.tmp
		$(DOCKER) build -t isobar/app:$(APP_TAG) -f $(APP_DIR)/Dockerfile.tmp .

nfs-build:
		@echo
		@echo "Build a nfs:$(NFS_TAG) image"
		$(DOCKER) build -t isobar/nfs:$(NFS_TAG) -f nfs-server-alpine/Dockerfile .

stress-build:
		@echo
		@echo "Build a stress:$(STRESS_TAG) image"
		$(DOCKER) build -t isobar/stress:$(STRESS_TAG) -f stress/Dockerfile .

dev-build:
		@echo
		@echo "Build a app:$(DEV_TAG) image"
		#$(DOCKER) build -t isobar/app-slim:$(DEV_TAG) -f app/Dockerfile .
		$(DOCKER) build -t isobar/dev:$(DEV_TAG) -f dev/Dockerfile .

rmc:
		@echo
		@echo "Remove a dev container"
		$(DOCKER) rm `$(DOCKER) ps -aq`

rmlast:
		@echo
		@echo "Remove a last image"
		$(DOCKER) rmi `$(DOCKER) images -q |head -1`

rmi:
		@echo
		@echo "Remove a dev image"
		$(DOCKER) rmi `$(DOCKER) images -q -f dangling=true`

cpu:
		@echo
		@echo "Stressing CPU"
		$(DOCKER) $(RUN) isobar/stress:$(STRESS_TAG) --cpu 4 --timeout 60s

vm:
		@echo
		@echo "Stressing VM"
		$(DOCKER) $(RUN) isobar/stress:$(STRESS_TAG) -m 1 --vm-bytes 1024M --timeout 60s

overload:
		@echo
		@echo "Server overload with vision"
		#$(OVERLOAD_C)
		$(OVERLOAD)

c100: COC=100
c100: coc

c200: COC=200
c200: coc

c300: COC=300
c300: coc

c400: COC=400
c400: coc

c500: COC=500
c500: coc

c600: COC=600
c600: coc

c700: COC=700
c700: coc

c800: COC=800
c800: coc

c900: COC=900
c900: coc

c1000: COC=1000
c1000: coc

coc:
		@echo
		@echo "Benchmarking $(COC) concurrency $(COC_REQ) requests"
		echo $(AB) -c $(COC) -n $(COC_REQ) $(HOST)

c1:
		@echo
		@echo "1 concurrency 1000 requests"
		$(AB) -c 1 -n 1000 $(HOST)

staging:
		@echo
		@echo "Deploy to staging"
		@sh/deploy-staging.sh fastify-app Jhuang05

app-run:
		@echo
		@echo "Start an app:$(APP_TAG) image"
		$(DOCKER) $(RUN) --name app -p 8000:8000 isobar/app:$(APP_TAG)

app-mongo-run:
		@echo
		@echo "Running a mongo server"
		@echo "cd ~/github/docker-2019ncku; make run-mongo"
		@echo "Start an app:$(APP_TAG) image"
		$(DOCKER) $(RUN) --name app -p 8000:8000 -e MONGO_URI="mongodb://jp:wwwins@mongo:27017/Sinopac_2019ncku" -e URL="http://10.65.16.237:8000" --network mongo-network isobar/app:$(APP_TAG) pm2-runtime start src/app.js -i 2

