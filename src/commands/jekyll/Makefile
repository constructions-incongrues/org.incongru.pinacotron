# Makefile configuration
DEFAULT_GOAL := help

# Command specification
COMMAND_NAME := $(notdir $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))))
COMMAND_DESCRIPTION := Integrate Pinacotron with Jekyll
COMMAND_SUBCOMMANDS := build init link preview script

# Command options
JEKYLL_THEME_GIT_URL := https://github.com/andyzg/gallery.git ## Jekyll compatible theme repository
JEKYLL_IMAGES_DIRECTORY := photos/pinacotron ## Relative path to images directory in Jekyll project
JEKYLL_PORT := 8001 ## Preview server port
JEKYLL_PROJECT := default ## Project name
JEKYLL_SCRIPT := setup.command ## Relative path to script
JEKYLL_SOURCE_IMAGES := ../../../annotate/jekyll/png ## Relative path to Pinacotron images
JEKYLL_VERSION := 4.0.0 ## Jekyll version

# Other Jekyll themes
#- https://github.com/dansku/photoGallery.git

# Helpers
comma := ,
log = printf "\e[1m[%-14s]\e[0m %-50s (%s)\n" "$(COMMAND_NAME)$(1)" "$(2)" "$(3)"

help:
	@echo -e "\e[33mDescription:\e[0m"
	@echo "  $(COMMAND_DESCRIPTION)"
	@echo
	@echo -e "\e[33mUsage:\e[0m"
	@echo "  $(COMMAND_NAME) <subcommand> [options]"
	@echo
	@$(MAKE) help.subcommands
	@echo
	@$(MAKE) help.options

help.summary:
	@printf "%-20s %s\n" "$(COMMAND_NAME)" "$(COMMAND_DESCRIPTION)"

help.subcommands:
	@echo -e "\e[33mAvailable subcommands:\e[0m"
	@$(foreach SUBCOMMAND,$(COMMAND_SUBCOMMANDS),echo -n "  "; $(MAKE) "help.$(SUBCOMMAND)";)

help.options:
	@echo -e "\e[33mAvailable options:\e[0m"
	awk 'match($$0, /^([A-Z_]+) := (.+) ## (.*)$$/, a) {printf "  \033[32m%-30s\033[0m %s (default: %s)\n", a[1], a[3], a[2]}' $(MAKEFILE_LIST)

help.build:
	@printf "%-20s %s\n" "build" "Builds project locally"

help.init:
	@printf "%-20s %s\n" "init" "Creates a new Jekyll project and links photos"

help.link:
	@printf "%-20s %s\n" "init" "Links Pinacotron images to Jekyll project"

help.script:
	@printf "%-20s %s\n" "script" "Executes a script in the project"

help.preview:
	@printf "%-20s %s\n" "preview" "Launch local preview server"

execute: help

build:
	@$(call log,/build,Building project,jekyll_version='$(strip $(JEKYLL_VERSION))')
	@docker run --rm \
		-e JEKYLL_GID=$$(id -u) \
		-e JEKYLL_UID=$$(id -u) \
		-e VERBOSE=true \
		-v "$$PINACOTRON_HOST_PWD/var:/srv" \
		-v "$$PINACOTRON_HOST_PWD/var/jekyll:/srv/jekyll" \
		jekyll/jekyll:$(strip $(JEKYLL_VERSION)) \
		jekyll build \
			--source /srv/jekyll/$(strip $(JEKYLL_PROJECT)) \
			--destination /srv/jekyll/$(strip $(JEKYLL_PROJECT))/_site \
			--quiet > /dev/null
	@$(call log,/build,project build complete,jekyll_version='$(strip $(JEKYLL_VERSION))')

init:
	@$(call log,/init,Initializing Jekyll project,project='$(strip $(JEKYLL_PROJECT))'$(comma) (strip $(JEKYLL_THEME_GIT_URL))')
	@git clone --depth 1 --quiet $(strip $(JEKYLL_THEME_GIT_URL)) /var/local/pinacotron/jekyll/$(strip $(JEKYLL_PROJECT))
	@rm -rf /var/local/pinacotron/jekyll/$(strip $(JEKYLL_PROJECT))/.git /var/local/pinacotron/jekyll/$(strip $(JEKYLL_PROJECT))/photos/*
	@cp /usr/local/src/pinacotron/skel/jekyll/_config.yml /var/local/pinacotron/jekyll/$(strip $(JEKYLL_PROJECT))/_config.yml
	@$(MAKE) link
	@$(MAKE) script
	@$(call log,/init,Jekyll project initialization complete,project='$(strip $(JEKYLL_PROJECT))'$(comma) git_url='$(strip $(JEKYLL_THEME_GIT_URL))')

link:
	@$(call log,/link,Linking Pinacotron images to project,project='$(strip $(JEKYLL_PROJECT))'$(comma) src='$(strip $(JEKYLL_SOURCE_IMAGES))'$(comma) dest='$(strip $(JEKYLL_IMAGES_DIRECTORY))')
	@mkdir -p $$(dirname "/var/local/pinacotron/jekyll/$(strip $(JEKYLL_PROJECT))/$(strip $(JEKYLL_IMAGES_DIRECTORY))")
	@ln -sf $(strip $(JEKYLL_SOURCE_IMAGES)) /var/local/pinacotron/jekyll/$(strip $(JEKYLL_PROJECT))/$(strip $(JEKYLL_IMAGES_DIRECTORY))

script:
	@if [ -f "/var/local/pinacotron/jekyll/$(strip $(JEKYLL_PROJECT))/$(strip $(JEKYLL_SCRIPT))" ]; then \
		$(call log,/script,project='$(strip $(JEKYLL_PROJECT))'$(comma) Executing script,path='$(strip $(JEKYLL_SCRIPT))'); \
		/var/local/pinacotron/jekyll/$(strip $(JEKYLL_PROJECT))/$(strip $(JEKYLL_SCRIPT)); \
		$(call log,/script,Script execution complete,project='$(strip $(JEKYLL_PROJECT))'$(comma) path='$(strip $(JEKYLL_SCRIPT))'); \
	else \
		$(call log,/script,Script not found,project='$(strip $(JEKYLL_PROJECT))'$(comma) path='$(strip $(JEKYLL_SCRIPT))'); \
	fi

preview: build
	@$(call log,/preview,Starting preview server,port='$(strip $(JEKYLL_PORT))')
	@-RET=$$(docker rm -f "$(notdir $(PWD))_$(COMMAND_NAME)_$@") > /dev/null
	@CONTAINER_ID=$$(docker run \
		-d \
		--name "$(notdir $(PWD))_$(COMMAND_NAME)_$@" \
		--rm \
		-p "$(strip $(JEKYLL_PORT)):80" \
		-v "$$PINACOTRON_HOST_PWD/var/jekyll/$(strip $(JEKYLL_PROJECT))/_site:/usr/share/nginx/html" \
		nginx) 2> /dev/null; \
	$(call log,/preview,Preview server started,url='http://localhost:$(strip $(JEKYLL_PORT))$(comma) container_name='$(notdir $(PWD))_$(COMMAND_NAME)_$@'$(comma) container_id='$$CONTAINER_ID')
