#!/usr/bin/env make

.PHONY: install
install:
	if [ ! -f /usr/local/bin/goss ]; then curl -fsSL https://goss.rocks/install | sh; fi

.PHONY: lint
lint:
	hadolint --ignore DL3013 --ignore DL3007 Dockerfile

.PHONY: size
size: build
	if [ ! -f /usr/local/bin/dive ]; then brew install dive; fi;
	dive artis3n/docker-arch-ansible:$${TAG:-test}

.PHONY: test
test: build
	dgoss run -it --rm --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro artis3n/docker-arch-ansible:$${TAG:-test}
	# CI=true make size

.PHONY: test-edit
test-edit: build
	dgoss edit -it --rm --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro artis3n/docker-arch-ansible:$${TAG:-test}

.PHONY: build
build:
	docker build . -t artis3n/docker-arch-ansible:$${TAG:-test}

.PHONY: run
run: build
	docker run -id --rm --name runner --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro artis3n/docker-arch-ansible:$${TAG:-test}
	-docker exec -it runner /bin/sh
	docker stop runner
