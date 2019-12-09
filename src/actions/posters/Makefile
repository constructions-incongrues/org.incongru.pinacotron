ACTION_NAME := $(notdir $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))))
log = printf "\e[1m[%-10s]\e[0m %-50s (%s)\n" "$(ACTION_NAME)" "$(1)" "$(2)"
PINACOTRON_POSTERS_CONVERT_PARAMETERS := -gravity South -pointsize 196 -stroke black -fill "\\\#FFFFFF" -colorspace Gray -separate -average -annotate 0
PINACOTRON_POSTERS_WORDS := default.txt
PINACOTRON_POSTERS_RUNID := "$$(date +%Y%m%d_%H%M%s)"
PINACOTRON_POSTERS_FORMATS := pdf
comma:= ,

help:
	@echo "$(ACTION_NAME):"
	@echo "    Generates posters"
	@echo "    Usage: $(ACTION_NAME) [-c <convert_parameters>] [-f <formats>] [-i runid] [-P <0|1>] [-w <words_filename>]"
	@echo "      -c : Convert parameters for text (default : '$(PINACOTRON_POSTERS_CONVERT_PARAMETERS)')"
	@echo "      -f : Generated formats (default : '$(PINACOTRON_POSTERS_FORMATS)')"
	@echo "      -i : Run id (default : '$(PINACOTRON_POSTERS_RUNID)')"
	@echo "      -w : Database of words in 'words/' directory (default : '$(PINACOTRON_POSTERS_WORDS)')"

execute:
	PINACOTRON_POSTERS_RUNID=$(PINACOTRON_POSTERS_RUNID); \
	mkdir -p /var/local/pinacotron/posters/$$PINACOTRON_POSTERS_RUNID; \
	for FORMAT in $(PINACOTRON_POSTERS_FORMATS); do \
		mkdir -p /var/local/pinacotron/posters/$$PINACOTRON_POSTERS_RUNID/$$FORMAT; \
	done; \
	find /var/local/pinacotron/images -type f |while read file; do \
		shortname=$$(basename "$$file"); \
		dirname=$$(dirname "$$file"); \
		COLLECTION=$$(basename "$$dirname"); \
		WORDS=$$(shuf -n1 /etc/pinacotron/words/$${PINACOTRON_POSTERS_WORDS}); \
		$(call log,Adding words to image,run_id='$$PINACOTRON_POSTERS_RUNID'$(comma)collection='$$COLLECTION'$(comma)image='$$shortname'$(comma)words_db='$(PINACOTRON_POSTERS_WORDS)'$(comma)words='$$WORDS'$(comma)convert_parameters=$${PINACOTRON_POSTERS_CONVERT_PARAMETERS}); \
		convert "$$file" $$(echo $${PINACOTRON_POSTERS_CONVERT_PARAMETERS} | xargs) "$$(echo $${WORDS} | tr ' ' '\n')" /var/local/pinacotron/posters/$$PINACOTRON_POSTERS_RUNID/$$shortname; \
		for FORMAT in $(PINACOTRON_POSTERS_FORMATS); do \
			$(call log,Generating document,run_id='$$PINACOTRON_POSTERS_RUNID'$(comma)collection='$$COLLECTION'$(comma)image='$$shortname'$(comma)format='$$FORMAT'); \
			convert -density 300 -page A4 -resize 1500x2185\! /var/local/pinacotron/posters/$$PINACOTRON_POSTERS_RUNID/$$shortname /var/local/pinacotron/posters/$$PINACOTRON_POSTERS_RUNID/$$FORMAT/$$shortname.$$FORMAT; \
		done; \
		rm /var/local/pinacotron/posters/$$PINACOTRON_POSTERS_RUNID/$$shortname; \
	done; \
	for FORMAT in $(PINACOTRON_POSTERS_FORMATS); do \
		if [ "$$FORMAT" == "pdf" ]; then \
			$(call log,Generating PDF aggregate,run_id='$$PINACOTRON_POSTERS_RUNID'$(comma)num_documents='$$(ls /var/local/pinacotron/posters/$$PINACOTRON_POSTERS_RUNID/pdf/*.pdf | wc -l)'); \
			pdfunite /var/local/pinacotron/posters/$$PINACOTRON_POSTERS_RUNID/pdf/*.pdf /var/local/pinacotron/posters/$$PINACOTRON_POSTERS_RUNID/aggregate.pdf; \
		fi; \
	done
