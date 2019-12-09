# Command specification
COMMAND_NAME := $(notdir $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))))
COMMAND_DESCRIPTION := Updates Pinacotron to its latest version

# Command options
IMAGE_REPOSITORY := constructionsincongrues/pinacotron ## Docker repository
IMAGE_TAG := latest ## Docker image tag

# Helpers
log = printf "\e[1m[%-8s]\e[0m %-50s (%s)\n" "$(COMMAND_NAME)" "$(1)" "$(2)"

# Help rules
help:
	@echo -e "\e[33mDescription:\e[0m"
	@echo "  $(COMMAND_DESCRIPTION)"
	@echo
	@echo -e "\e[33mUsage:\e[0m"
	@echo "  $(COMMAND_NAME) [options]"
	@echo
	@$(MAKE) help.options

help.summary:
	@printf "%-20s %s\n" "$(COMMAND_NAME)" "$(COMMAND_DESCRIPTION)"

help.options:
	@echo -e "\e[33mAvailable options:\e[0m"
	awk 'match($$0, /^([A-Z_]+) := (.+) ## (.*)$$/, a) {printf "  \033[32m%-30s\033[0m %s (default: %s)\n", a[1], a[3], a[2]}' $(MAKEFILE_LIST)

# Command
execute:
	$(call log,Updating Pinacotron image,repository='$(strip $(IMAGE_REPOSITORY))'$(comma) tag='$(strip $(IMAGE_TAG))');
	@docker pull $(strip $(IMAGE_REPOSITORY)):$(strip $(IMAGE_TAG)) > /dev/null
	$(call log,Pinacotron update complete,repository='$(strip $(IMAGE_REPOSITORY))'$(comma) tag='$(strip $(IMAGE_TAG))');
