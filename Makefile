build:
	docker-compose build --build-arg=PINACOTRON_VERSION=`git describe --tags`
