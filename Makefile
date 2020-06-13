#!/usr/bin/env make

.PHONY: install
install:
	if [ ! -f /usr/local/bin/goss ]; then curl -fsSL https://goss.rocks/install | sh; fi

.PHONY: lint
lint:
	docker run --rm -i hadolint/hadolint hadolint --ignore DL3013 - < Dockerfile

.PHONY: size
size: build
	if [ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]; then /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"; fi
	if [ ! -f /usr/local/bin/dive ]; then brew install dive; fi;
	dive artis3n/docker-arch-ansible:$${TAG:-test}

.PHONY: test
test: build
	dgoss run -it --rm artis3n/docker-arch-ansible:$${TAG:-test}
	# CI=true make size

.PHONY: test-edit
test-edit: build
	dgoss edit -it --rm artis3n/docker-arch-ansible:$${TAG:-test}

.PHONY: build
build:
	docker build . -t artis3n/docker-arch-ansible:$${TAG:-test}

.PHONY: run
run: build
	docker run -d --rm --name runner artis3n/docker-arch-ansible:$${TAG:-test}
	-docker exec -it runner /bin/sh
	docker stop runner
