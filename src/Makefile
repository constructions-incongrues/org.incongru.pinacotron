SHELL=/usr/bin/env bash
PINACOTRON_ACTIONS=`ls -1 /usr/local/bin/pinacotron-* | tr '\n' '\0' | sed 's/pinacotron-//' | xargs -0 -n 1 basename`
PINACOTRON_ACTIONS := images posters

help: ## Show help
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

$(PINACOTRON_ACTIONS): %: ## Executes the action
	@echo -e "\e[1m[action/$*]\e[0m Starting"
	@/usr/local/bin/pinacotron-$*
	@echo -e "\e[1m[action/$*]\e[0m Done"

actions: ## Lists available actions
	@echo "Available actions :"
	@$(foreach ACTION,$(PINACOTRON_ACTIONS),echo "   $(ACTION)";)

gallery-start: ## Starts a local web gallery for browsing images
	if [ ! -f "/var/local/pinacotron/pigallery.json" ]; then cp /etc/pigallery.json /var/local/pinacotron/; fi
	docker rm -f pinacotron_gallery || true
	docker run \
			--name pinacotron_gallery \
			-d \
			-p $${GALLERY_PORT-8000}:80 \
			-e NODE_ENV=production \
			-e PUID=`id -u` \
			-e GUID=`id -g` \
			-v $$GALLERY_IMAGES_DIR/pigallery.json:/pigallery2-release/config.json \
			-v $$GALLERY_IMAGES_DIR:/pigallery2-release/pinacotron/images \
			bpatrik/pigallery2:1.7.0-stretch
	echo "Gallery is available at http://localhost:$${GALLERY_PORT-8000}"

gallery-stop: ## Stops the local web gallery
	docker rm -f pinacotron_gallery

init: ## Creates stub configuration
	mkdir -p /var/local/pinacotron/images /var/local/pinacotron/posters /var/local/pinacotron/posters/pdf /var/local/pinacotron/posters/png
	mkdir -p /etc/pinacotron/collections/mycollection
	echo "lovely kitten" > /etc/pinacotron/collections/mycollection/keywords.txt
	echo "adorable baby dog" >> /etc/pinacotron/collections/mycollection/keywords.txt
	echo "-s large -l 5" >> /etc/pinacotron/collections/mycollection/parameters.txt
	mkdir -p /etc/pinacotron/words
	echo "hello world" >> /etc/pinacotron/words/default.txt

version: ## Displays version
	echo "pinacotron: $$PINACOTRON_VERSION"
