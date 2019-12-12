# Command specification
COMMAND_NAME := $(notdir $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))))
COMMAND_DESCRIPTION := Searches and downloads images using Google Image
COMMAND_SUBCOMMANDS := download purge

# Command options
GOOGLE_COLLECTION := * ## Collection(s)

# Helpers
comma:= ,
log = printf "\e[1m[%-14s]\e[0m %-50s (%s)\n" "$(COMMAND_NAME)$(1)" "$(2)" "$(3)"

# Help rules
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

help.download:
	@printf "%-20s %s\n" "download" "Search and download images"

help.purge:
	@printf "%-20s %s\n" "purge" "Deletes collection's local image cache"

# Command
execute: help

download:
	@for COLLECTION in /etc/pinacotron/google/collections/$(strip $(GOOGLE_COLLECTION)); do \
		$(call log,/download,Processing collection,collection='$$(basename $$COLLECTION)'); \
		if [ ! -d "/var/local/pinacotron/google/$$(basename $$COLLECTION)" ]; then \
			$(call log,/download,Images folder missing : downloading images,collection='$$(basename $$COLLECTION)'); \
			googleimagesdownload `cat $$COLLECTION/parameters.txt` -kf $$COLLECTION/keywords.txt -o "/var/local/pinacotron/google/$$(basename $$COLLECTION)" > /dev/null; \
			$(call log,/download,Fixing up images filenames,collection='$$(basename $$COLLECTION)'); \
			rename 'use URI::Escape; $$_ = uri_unescape $$_' /var/local/pinacotron/google/*/*/*.*; \
		else \
			$(call log,/download,Images folder found : skipping,collection='$$(basename $$COLLECTION)'); \
		fi; \
		$(call log,/download,Done processing collection,collection='$$(basename $$COLLECTION)'$(comma) num_images='$$(find /var/local/pinacotron/google/$$(basename $$COLLECTION) -type f | wc -l)'); \
	done

purge:
	@$(call log,/download,Purging collection(s),collection='$(strip $(GOOGLE_COLLECTION))')
	@rm -rf /var/local/pinacotron/google/$(strip $(GOOGLE_COLLECTION))
	@$(call log,/download,Done purging collection(s),collection='$(strip $(GOOGLE_COLLECTION))')
