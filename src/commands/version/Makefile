# Command specification
COMMAND_NAME := $(notdir $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))))
COMMAND_DESCRIPTION := Displays Pinacotron version information

# Helpers
log = printf "\e[1m[%-8s]\e[0m %-50s (%s)\n" "$(COMMAND_NAME)" "$(1)" "$(2)"

# Help rules
help:
	@echo -e "\e[33mDescription:\e[0m"
	@echo "  $(COMMAND_DESCRIPTION)"
	@echo
	@echo -e "\e[33mUsage:\e[0m"
	@echo "  $(COMMAND_NAME)"

help.summary:
	@printf "%-20s %s\n" "$(COMMAND_NAME)" "$(COMMAND_DESCRIPTION)"

# Command
execute:
	@echo -e "Pinacotron \e[32m$$PINACOTRON_VERSION\e[0m"
