ACTION_NAME := $(notdir $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))))
log = printf "\e[1m[%-10s]\e[0m %-50s (%s)\n" "$(ACTION_NAME)" "$(1)" "$(2)"
PINACOTRON_DOWNLOAD_PURGE = 0

help:
	echo "$(ACTION_NAME):"
	echo "    Downloads images from collections"
	@echo "    Usage: $(ACTION_NAME) [-P <0|1>]"
	@echo "      -P purge images directory (default: 0)"

execute:
	@for COLLECTION in /etc/pinacotron/collections/*; do \
		$(call log,Processing collection,collection='$$(basename $$COLLECTION)'); \
		if [[ "$(PINACOTRON_DOWNLOAD_PURGE)" == "1" ]]; then \
			$(call log,Purge requested : deleted existing images,collection='$$(basename $$COLLECTION)'); \
			rm -rf /var/local/pinacotron/images/$$(basename $$COLLECTION); \
		fi; \
		if [ ! -d "/var/local/pinacotron/images/$$(basename $$COLLECTION)" ]; then \
			$(call log,Images folder missing : downloading images,collection='$$(basename $$COLLECTION)'); \
			googleimagesdownload `cat $$COLLECTION/parameters.txt` -kf $$COLLECTION/keywords.txt -o "/var/local/pinacotron/images/$$(basename $$COLLECTION)"; \
		else \
			$(call log,Images folder found : skipping,collection='$$(basename $$COLLECTION)'); \
		fi; \
		$(call log,Done processing collection,collection='$$(basename $$COLLECTION)'); \
	done
