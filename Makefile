# Makefile configuration
SHELL=/usr/bin/env bash

# Options
CHANGELOG_FUTURE_RELEASE :=

# Helpers
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
        $(error Undefined $1$(if $2, ($2))$(if $(value @), \
                required by target `$@')))

help: ## Displays this help message
	@for MKFILE in $(MAKEFILE_LIST); do \
		grep -E '^[a-zA-Z0-9\._-]+:.*?## .*$$' $$MKFILE | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'; \
	done

build: ## Builds docker images locally
	docker-compose build --build-arg=PINACOTRON_VERSION=`git describe --tags`

changelog: ## Generates changelog from Github
	@:$(call check_defined, CHANGELOG_FUTURE_RELEASE, x.y.z)
	docker run -it --rm -v "$(PWD)":/usr/local/src/your-app ferrarimarco/github-changelog-generator --user constructions-incongrues --project org.incongru.pinacotron --future-release $(CHANGELOG_FUTURE_RELEASE)
