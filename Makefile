build:
	docker-compose build --build-arg=DOCKER_TAG=`git describe --tags`
