# Command specification
COMMAND_NAME := $(notdir $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))))
COMMAND_DESCRIPTION := Initializes a new Pinacotron project

# Command options
INIT_SKEL := default ## Base skel name

# Helpers
log = printf "\e[1m[%-4s]\e[0m %-50s (%s)\n" "$(COMMAND_NAME)" "$(1)" "$(2)"

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
	@$(call log,Initializing new project from skel,skel='$(strip $(INIT_SKEL))'); \
	if [ -d "/etc/pinacotron/google/collections" ]; then \
		$(call log,Project has already been initialized. Aborting,skel='$(strip $(INIT_SKEL))'); \
	else \
		cp -R /usr/local/src/pinacotron/skel/$(strip $(INIT_SKEL))/project/* /etc/pinacotron/; \
		$(call log,Project initialization complete,skel='$(strip $(INIT_SKEL))'); \
	fi
