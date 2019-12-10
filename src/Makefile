# Makefile configuration
SHELL=/usr/bin/env bash
.PHONY: jekyll

# Helpers
PINACOTRON_COMMANDS := $(shell ls -A1 ./commands)
log = printf "\e[1m[%-20s]\e[0m %-50s (%s)\n" "$(1)" "$(2)" "$(3)"

help: version ## Lists available commands
	@echo
	@echo -e "\e[33mUsage:\e[0m"
	@echo "  command [options] [arguments]"
	@echo
	@echo -e "\e[33mAvailable commands:\e[0m"
	@$(foreach COMMAND,$(PINACOTRON_COMMANDS),echo -n "  "; make -s --no-print-directory -C /usr/local/src/pinacotron/commands/$(COMMAND) help.summary;)

$(PINACOTRON_COMMANDS): %: ## Calls commands
	@make -s --no-print-directory -C /usr/local/src/pinacotron/commands/$* $(PINACOTRON_SUBCOMMAND_NAME)
