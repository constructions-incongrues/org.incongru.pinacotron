help: ## Show help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

images: ## Downloads images from collections
	/usr/local/bin/images

posters: ## Combine words and images into posters
	/usr/local/bin/posters
