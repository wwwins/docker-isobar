DOCKER = sudo docker
MKDIR = sudo mkdir -p
CP = sudo cp
SED = sed -e
RUN = run --rm

# Tag
NODE_TAG = 1.1.0
NODE_CANVAS_TAG = 1.1.0
APP_TAG = 1.7.0
NFS_TAG = 1.0.0
DEV_TAG = 1.2.0

GCR_IMAGE_NAME_APP = asia.gcr.io/isobar-gcp-k8s/app
GCR_IMAGE_NAME_NFS = asia.gcr.io/isobar-gcp-k8s/nfs

BUILD_NODE_CANVAS = RUN apk add --no-cache --virtual .build-deps-full make gcc g++ python pkgconfig pixman-dev cairo-dev pango-dev libjpeg-turbo-dev giflib-dev \&\& npm install canvas --save \&\& apk del .build-deps-full

default: app-build

app-push: gcr-tag gcr-push
nfs-push: gcr-nfs-tag gcr-nfs-push

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

node-build:
		@echo
		@echo "Build a node-8:$(NODE_TAG) image"
		$(DOCKER) build -t isobar/node-8:$(NODE_TAG) -f node/Dockerfile .

node-canvas-build:
		@echo
		@echo "Build a node-canvas:$(NODE_CANVAS_TAG) image"
		$(DOCKER) build -t isobar/node-canvas:$(NODE_CANVAS_TAG) -f node-canvas/Dockerfile .

app-build: BUILD_NODE_CANVAS:=
app-build:
		@echo
		@echo "Build a app:$(APP_TAG) image"
		$(SED) 's/{INSTALL_NODE_CANVAS}/$(BUILD_NODE_CANVAS)/' app/Dockerfile > app/Dockerfile.tmp
		$(DOCKER) build -t isobar/app:$(APP_TAG) -f app/Dockerfile.tmp .

app-canvas-build:
		@echo
		@echo "Build a app:$(APP_TAG) with node-canvas"
		$(SED) 's/{INSTALL_NODE_CANVAS}/$(BUILD_NODE_CANVAS)/' app/Dockerfile > app/Dockerfile.tmp
		$(DOCKER) build -t isobar/app:$(APP_TAG) -f app/Dockerfile.tmp .

nfs-build:
		@echo
		@echo "Build a nfs:$(NFS_TAG) image"
		$(DOCKER) build -t isobar/nfs:$(NFS_TAG) -f nfs-server-alpine/Dockerfile .

dev-build:
		@echo
		@echo "Build a app:$(DEV_TAG) image"
		#$(DOCKER) build -t isobar/app-slim:$(DEV_TAG) -f app/Dockerfile .
		$(DOCKER) build -t isobar/dev:$(DEV_TAG) -f dev/Dockerfile .

rmc:
		@echo
		@echo "Remove a dev container"
		$(DOCKER) rm `$(DOCKER) ps -aq`

rmi:
		@echo
		@echo "Remove a dev image"
		$(DOCKER) rmi `$(DOCKER) images -q -f dangling=true`

app-run:
		@echo
		@echo "Start an app:$(APP_TAG) image"
		$(DOCKER) $(RUN) --name app -p 8000:8000 isobar/app:$(APP_TAG)
