# Makefile configuration
DEFAULT_GOAL := help

# Command specification
COMMAND_NAME := $(notdir $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))))
COMMAND_DESCRIPTION := Controls the image gallery web service
COMMAND_SUBCOMMANDS := start status stop

# Command options
GALLERY_PORT := 8000 ## Web service port

# Helpers
CONTAINER_NAME := $$(basename "$(PWD)")_pinacotron_gallery
comma:= ,
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

help.start:
	@printf "%-20s %s\n" "start" "Starts the service"

help.status:
	@printf "%-20s %s\n" "status" "Checks service status"

help.stop:
	@printf "%-20s %s\n" "stop" "Stops status"

execute: help

exists:
	@CONTAINER_EXISTS="false"; \
	RET=$$(docker container inspect --format='{{ .Name }}' $(CONTAINER_NAME) 2> /dev/null); \
	if [ "$$?" == "0" ]; then CONTAINER_EXISTS="true"; fi; \
	$(call log,/$@,Check if service exists,container_name='$(CONTAINER_NAME)'$(comma) exists='$$CONTAINER_EXISTS'); \
	if [ "$$CONTAINER_EXISTS" != "true" ]; then exit 1; fi

start:
	if [ ! -f "/etc/pinacotron/pigallery.json" ]; then \
		$(call log,/start,Creating custom configuration file,path='$$PINACOTRON_HOST_PWD/etc/skel/pigallery.json'); \
		cp /usr/local/src/pinacotron/skel/pigallery.json /etc/pinacotron/; \
	fi
	$(call log,/$@,Starting service,port='$(strip $(GALLERY_PORT))'$(comma) container_name='$(CONTAINER_NAME)'); \
	RET=$$(docker rm -f $(CONTAINER_NAME) 2> /dev/null); \
	CONTAINER_ID=$$(docker run \
		--name $(CONTAINER_NAME) \
		-d \
		-p "$(strip $(GALLERY_PORT)):80" \
		-e NODE_ENV=production \
		-e PUID=`id -u` \
		-e GUID=`id -g` \
		-v $$PINACOTRON_HOST_PWD/etc/pinacotron/pigallery.json:/pigallery2-release/config.json \
		-v $$PINACOTRON_HOST_PWD/var:/pigallery2-release/pinacotron/images \
		bpatrik/pigallery2:1.7.0-stretch); \
	$(call log,/$@,Service started,url='http://localhost:$(strip $(GALLERY_PORT))'$(comma) container_name='$(CONTAINER_NAME)'$(comma) container_id='$$CONTAINER_ID')

status: exists
	CONTAINER_STATUS=$$(docker inspect -f '{{ .State.Status }}' $(CONTAINER_NAME)); \
	$(call log,/$@,Querying service status,container_name='$(CONTAINER_NAME)'$(comma) status='$$CONTAINER_STATUS');

stop: exists
	$(call log,/$@,Stopping service,container_name='$(CONTAINER_NAME)'); \
	docker rm -f $(CONTAINER_NAME) > /dev/null
