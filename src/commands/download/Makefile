# Command specification
COMMAND_NAME := $(notdir $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))))
COMMAND_DESCRIPTION := Searches and downloads images
COMMAND_SUBCOMMANDS := collection purge

# Command options
DOWNLOAD_COLLECTION := default ## Collection(s)

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

help.collection:
	@printf "%-20s %s\n" "collection" "Search and download images from all collection DOWNLOAD_COLLECTION"

help.purge:
	@printf "%-20s %s\n" "purge" "Deletes collection's local image cache"

# Command
execute: help

collection:
	@for COLLECTION in /etc/pinacotron/download/collections/$(strip $(DOWNLOAD_COLLECTION)); do \
		if [ ! -d "/etc/pinacotron/download/collections/$$(basename $$COLLECTION)" ]; then \
			$(call log,/all,Collection does not exist,collection='$$(basename $$COLLECTION)'); \
			exit 0; \
		fi; \
		$(call log,/all,Processing collection,collection='$$(basename $$COLLECTION)'); \
		if [ ! -d "/var/local/pinacotron/download/$$(basename $$COLLECTION)" ]; then \
			$(call log,/all,Creating new collection,collection='$$(basename $$COLLECTION)'); \
			mkdir -p "/var/local/pinacotron/download/$$(basename $$COLLECTION)"; \
			OLDIFS=$$IFS; \
			IFS=$$'\n'; \
			for KEYWORD in $$(cat $$COLLECTION/keywords.txt); do \
				mkdir -p "/var/local/pinacotron/download/$$(basename $$COLLECTION)/$$KEYWORD"; \
				IFS=$$OLDIFS; \
				$(call log,/all,Downloading images,collection='$$(basename $$COLLECTION)'$(comma) keyword='$$KEYWORD'); \
				docker run -u $$(id -u):$$(id -g) --rm -v "$$PINACOTRON_HOST_PWD/var/download/$$(basename $$COLLECTION)/$$KEYWORD:/var/image-downloader" constructionsincongrues/image-downloader $$(cat /etc/pinacotron/download/profiles/default.json | jq -r ". | to_entries | map(\"--\" + .key + \" \" + .value) | join(\" \")") "$$KEYWORD" > /dev/null; \
			done; \
		else \
			$(call log,/all,Images folder found : skipping,collection='$$(basename $$COLLECTION)'); \
		fi; \
		$(call log,/all,Done processing collection,collection='$$(basename $$COLLECTION)'$(comma) num_images='$$(find /var/local/pinacotron/download/$$(basename $$COLLECTION) -type f | wc -l)'); \
	done

purge:
	@$(call log,/purge,Purging collection(s),collection='$(strip $(DOWNLOAD_COLLECTION))')
	@rm -rf /var/local/pinacotron/download/$(strip $(DOWNLOAD_COLLECTION))
	@$(call log,/purge,Done purging collection(s),collection='$(strip $(DOWNLOAD_COLLECTION))')
