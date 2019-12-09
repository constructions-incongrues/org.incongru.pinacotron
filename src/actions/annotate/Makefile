ACTION_NAME := $(notdir $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))))
log = printf "\e[1m[%-10s]\e[0m %-50s (%s)\n" "$(ACTION_NAME)" "$(1)" "$(2)"
PINACOTRON_ANNOTATE_CONVERT_PARAMETERS := -gravity South -pointsize 196 -stroke black -fill "\\\#FFFFFF" -colorspace Gray -separate -average -annotate 0
PINACOTRON_ANNOTATE_FORMATS := pdf
PINACOTRON_ANNOTATE_RUNID := "$$(date +%Y%m%d_%H%M%s)"
PINACOTRON_ANNOTATE_PROFILE := default
PINACOTRON_ANNOTATE_WORDS := default.txt
comma:= ,

help:
	@echo "$(ACTION_NAME):"
	@echo "    Annotates images with text"
	@echo "    Usage: $(ACTION_NAME) [-c <convert_parameters>] [-f <formats>] [-i runid] [-P <0|1>] [-w <words_filename>]"
	@echo "      -f : Generated formats (default : '$(PINACOTRON_ANNOTATE_FORMATS)')"
	@echo "      -i : Run id (default : '$(PINACOTRON_ANNOTATE_RUNID)')"
	@echo "      -p : Profile (default : '$(PINACOTRON_ANNOTATE_PROFILE)')"
	@echo "      -w : Database of words in 'words/' directory (default : '$(PINACOTRON_ANNOTATE_WORDS)')"

execute:
	PINACOTRON_ANNOTATE_RUNID=$(PINACOTRON_ANNOTATE_RUNID); \
	mkdir -p /var/local/pinacotron/annotate/$$PINACOTRON_ANNOTATE_RUNID; \
	for FORMAT in $(PINACOTRON_ANNOTATE_FORMATS); do \
		mkdir -p /var/local/pinacotron/annotate/$$PINACOTRON_ANNOTATE_RUNID/$$FORMAT; \
	done; \
	find /var/local/pinacotron/images -type f |while read file; do \
		shortname=$$(basename "$$file"); \
		mininame="$${shortname:0:7}..."; \
		dirname=$$(dirname "$$file"); \
		COLLECTION=$$(basename "$$dirname"); \
		WORDS=$$(shuf -n1 /etc/pinacotron/words/$${PINACOTRON_ANNOTATE_WORDS}); \
		$(call log,Annotating image,run_id='$$PINACOTRON_ANNOTATE_RUNID'$(comma) profile='$(PINACOTRON_ANNOTATE_PROFILE)'$(comma) collection='$$COLLECTION'$(comma) image='$$mininame'$(comma) words='$(PINACOTRON_ANNOTATE_WORDS)'$(comma)'); \
		convert "$$file" $$(cat /etc/pinacotron/profiles/$(PINACOTRON_ANNOTATE_PROFILE).json | jq -r '.annotate.annotate | to_entries | map("-" + .key + " " + .value) | join(" ")') "$$(echo $${WORDS} | tr ' ' '\n')" /var/local/pinacotron/annotate/$$PINACOTRON_ANNOTATE_RUNID/$$shortname; \
		for FORMAT in $(PINACOTRON_ANNOTATE_FORMATS); do \
			$(call log,Exporting image,run_id='$$PINACOTRON_ANNOTATE_RUNID'$(comma) profile='$(PINACOTRON_ANNOTATE_PROFILE)'$(comma) collection='$$COLLECTION'$(comma) image='$$mininame'$(comma) format='$$FORMAT'); \
			convert $$(cat /etc/pinacotron/profiles/$(PINACOTRON_ANNOTATE_PROFILE).json | jq -r ".annotate.formats.$${FORMAT} | to_entries | map(\"-\" + .key + \" \" + .value) | join(\" \")") /var/local/pinacotron/annotate/$$PINACOTRON_ANNOTATE_RUNID/$$shortname /var/local/pinacotron/annotate/$$PINACOTRON_ANNOTATE_RUNID/$$FORMAT/$$shortname.$$FORMAT; \
		done; \
		rm /var/local/pinacotron/annotate/$$PINACOTRON_ANNOTATE_RUNID/$$shortname; \
	done; \
	for FORMAT in $(PINACOTRON_ANNOTATE_FORMATS); do \
		if [ "$$FORMAT" == "pdf" ]; then \
			$(call log,Generating PDF aggregate,run_id='$$PINACOTRON_ANNOTATE_RUNID'$(comma) num_documents='$$(ls /var/local/pinacotron/annotate/$$PINACOTRON_ANNOTATE_RUNID/pdf/*.pdf | wc -l)'); \
			pdfunite /var/local/pinacotron/annotate/$$PINACOTRON_ANNOTATE_RUNID/pdf/*.pdf /var/local/pinacotron/annotate/$$PINACOTRON_ANNOTATE_RUNID/aggregate.pdf; \
		fi; \
	done
