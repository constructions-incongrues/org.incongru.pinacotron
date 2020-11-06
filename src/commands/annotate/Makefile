# Command specification
COMMAND_DESCRIPTION := Annotates downloaded images with text
COMMAND_NAME := $(notdir $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))))

# Command options
ANNOTATE_FORMATS := pdf ## Space separated list of output formats
ANNOTATE_RUNID := $$(date +%Y%m%d_%H%M%s) ## Run identifier
ANNOTATE_PROFILE := default ## Configuration profile
ANNOTATE_WORDS := default.txt ## Words database

# Helpers
log = printf "\e[1m[%-8s]\e[0m %-50s (%s)\n" "$(COMMAND_NAME)" "$(1)" "$(2)"
comma:= ,

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
	ANNOTATE_RUNID=$(strip $(ANNOTATE_RUNID)); \
	mkdir -p "/var/local/pinacotron/annotate/$$ANNOTATE_RUNID"; \
	for FORMAT in $(strip $(ANNOTATE_FORMATS)); do \
		mkdir -p "/var/local/pinacotron/annotate/$$ANNOTATE_RUNID/$$FORMAT"; \
	done; \
	find /var/local/pinacotron/download -type f | while read file; do \
		shortname=$$(basename "$$file"); \
		mininame="$${shortname:0:7}..."; \
		dirname=$$(dirname "$$file"); \
		COLLECTION=$$(basename "$$dirname"); \
		WORDS=$$(shuf -n1 /etc/pinacotron/words/$(strip $(ANNOTATE_WORDS))); \
		$(call log,Annotating image,run_id='$$ANNOTATE_RUNID'$(comma) profile='$(strip $(ANNOTATE_PROFILE))'$(comma) collection='$$COLLECTION'$(comma) image='$$mininame'$(comma) words='$(strip $(ANNOTATE_WORDS))'); \
		convert -font /var/local/pinacotron/fonts/Combat.otf "$$file" $$(cat /etc/pinacotron/profiles/$(strip $(ANNOTATE_PROFILE)).json | jq -r '.annotate.annotate | to_entries | map("-" + .key + " " + .value) | join(" ")') "$$(echo $${WORDS} | tr ' ' '\n')" /var/local/pinacotron/annotate/$$ANNOTATE_RUNID/$$shortname; \
		for FORMAT in $(strip $(ANNOTATE_FORMATS)); do \
			FORMAT_PROFILE=$$FORMAT; \
			$(call log,Exporting image,run_id='$$ANNOTATE_RUNID'$(comma) profile='$(strip $(ANNOTATE_PROFILE))'$(comma) collection='$$COLLECTION'$(comma) image='$$mininame'$(comma) format='$$FORMAT'); \
			if [ "$$(cat /etc/pinacotron/profiles/$(strip $(ANNOTATE_PROFILE)).json | jq -r .annotate.formats.$${FORMAT_PROFILE})" == "null" ]; then FORMAT_PROFILE=default; fi; \
			convert $$(cat /etc/pinacotron/profiles/$(strip $(ANNOTATE_PROFILE)).json | jq -r ".annotate.formats.$${FORMAT_PROFILE} | to_entries | map(\"-\" + .key + \" \" + .value) | join(\" \")") /var/local/pinacotron/annotate/$$ANNOTATE_RUNID/$$shortname /var/local/pinacotron/annotate/$$ANNOTATE_RUNID/$$FORMAT/$${RANDOM}.$$shortname.$$FORMAT; \
		done; \
		rm /var/local/pinacotron/annotate/$$ANNOTATE_RUNID/$$shortname; \
	done; \
	for FORMAT in $(strip $(ANNOTATE_FORMATS)); do \
		if [ "$$FORMAT" == "pdf" ]; then \
			$(call log,Generating PDF aggregate,run_id='$$ANNOTATE_RUNID'$(comma) num_documents='$$(ls /var/local/pinacotron/annotate/$$ANNOTATE_RUNID/pdf/*.pdf | wc -l)'); \
			pdfunite /var/local/pinacotron/annotate/$$ANNOTATE_RUNID/pdf/*.pdf /var/local/pinacotron/annotate/$$ANNOTATE_RUNID/aggregate.pdf; \
		fi; \
	done
