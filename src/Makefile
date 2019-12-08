SHELL=/usr/bin/env bash

help: ## Show help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

gallery-start: ## Starts a local web gallery for browsing images
	if [ ! -f "/var/local/pinacotron/pigallery.json" ]; then cp /etc/pigallery.json /var/local/pinacotron/; fi
	chown $${HOST_UID-1000}:$${HOST_GID-1000} /var/local/pinacotron/pigallery.json
	docker rm -f pinacotron_gallery || true
	docker run \
		--name pinacotron_gallery \
		-d \
		-p $${GALLERY_PORT-8000}:80 \
		-e NODE_ENV=production \
		-e PUID=$${HOST_UID-1000} \
		-e GUID=$${HOST_GID-1000} \
		-v $$GALLERY_IMAGES_DIR/pigallery.json:/pigallery2-release/config.json \
		-v $$GALLERY_IMAGES_DIR:/pigallery2-release/pinacotron/images \
		bpatrik/pigallery2:1.7.0-stretch
	@echo "Gallery is available at http://localhost:$${GALLERY_PORT-8000}"

gallery-stop: ## Stops the local web gallery
	docker rm -f pinacotron_gallery

images: ## Downloads images from collections
	/usr/local/bin/images

posters: ## Combine words and images into posters
	/usr/local/bin/posters

version: ## Displays version
	@echo "pinacotron: $$PINACOTRON_VERSION"
