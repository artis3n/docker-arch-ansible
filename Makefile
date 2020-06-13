#!/usr/bin/env make

.PHONY: install
install:
	if [ ! -f /usr/local/bin/goss ]; then curl -fsSL https://goss.rocks/install | sh; fi

.PHONY: lint
lint:
	docker run --rm -i hadolint/hadolint hadolint - < Dockerfile

.PHONY: size
size:
	if [ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]; then /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"; fi
	if [! -f /usr/local/bin/dive ]; then brew install dive; fi;
	dive build artis3n/docker-arch-ansible:$${TAG:-test}

.PHONY: test
test:
	dgoss run -it --rm artis3n/docker-arch-ansible:$${TAG:-test}
	CI=true dive artis3n/docker-arch-ansible:$${TAG:-test}

.PHONY: test-edit
test-edit:
	dgoss edit -it --rm artis3n/docker-arch-ansible:$${TAG:-test}

.PHONY: build
build:
	docker build . -t artis3n/docker-arch-ansible:$${TAG:-test}

.PHONY: run
run:
	docker run -d --rm --name runner artis3n/docker-arch-ansible:$${TAG:-latest}
	-docker exec -it runner /bin/sh
	docker stop runner
