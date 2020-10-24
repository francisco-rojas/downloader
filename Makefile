dc=docker-compose $(1)
dc-run=$(call dc, run --service-ports --rm downloader $(1))

build: ## Build docker image
	$(call dc, build)
bundle: ## Install gems
	$(call dc-run, bundle install)
dev: ## Fire a shell
	$(call dc-run, ash)
test: ## Run tests
	$(call dc-run, rake test)
