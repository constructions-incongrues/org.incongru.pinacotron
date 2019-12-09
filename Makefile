build:
	docker-compose build --build-arg=DOCKER_TAG=`git describe --tags`

changelog:
	docker run -it --rm -v "$(PWD)":/usr/local/src/your-app ferrarimarco/github-changelog-generator --user constructions-incongrues --project org.incongru.pinacotron --future-release $(CHANGELOG_FUTURE_RELEASE)
