# Command specification
COMMAND_NAME := $(notdir $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))))
COMMAND_DESCRIPTION := Downloads images from collections

# Command options
DOWNLOAD_PURGE := 0 ## Deletes download folder contents

# Helpers
comma:= ,
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
	@for COLLECTION in /etc/pinacotron/collections/*; do \
		$(call log,Processing collection,collection='$$(basename $$COLLECTION)'); \
		if [[ "$(strip $(DOWNLOAD_PURGE))" == "1" ]]; then \
			$(call log,Purge requested : deleted existing images,collection='$$(basename $$COLLECTION)'); \
			rm -rf /var/local/pinacotron/download/$$(basename $$COLLECTION); \
		fi; \
		if [ ! -d "/var/local/pinacotron/download/$$(basename $$COLLECTION)" ]; then \
			$(call log,Images folder missing : downloading images,collection='$$(basename $$COLLECTION)'); \
			googleimagesdownload `cat $$COLLECTION/parameters.txt` -kf $$COLLECTION/keywords.txt -o "/var/local/pinacotron/download/$$(basename $$COLLECTION)"; \
			$(call log,Fixing up images filenames,collection='$$(basename $$COLLECTION)'); \
			rename 'use URI::Escape; $$_ = uri_unescape $$_' /var/local/pinacotron/download/*/*/*.*; \
		else \
			$(call log,Images folder found : skipping,collection='$$(basename $$COLLECTION)'); \
		fi; \
		$(call log,Done processing collection,collection='$$(basename $$COLLECTION)'$(comma) num_images='$$(find /var/local/pinacotron/download/$$(basename $$COLLECTION) -type f | wc -l)'); \
	done
