DOCKER = sudo docker
MKDIR = sudo mkdir -p
CP = sudo cp
RUN = run --rm

# Tag
APP_TAG = 1.0.0

default: app-build
app-build:
		@echo
		@echo "Build a app:$(APP_TAG) image"
		$(DOCKER) build -t isobar/app:$(APP_TAG) -f Dockerfile .
