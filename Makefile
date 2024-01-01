#!/usr/bin/env make

.PHONY: install
install:
	if [ ! -f /usr/local/bin/goss ]; then curl -fsSL https://goss.rocks/install | sh; fi

.PHONY: lint
lint:
	hadolint --ignore DL3013 --ignore DL3007 Dockerfile

.PHONY: test
test: build
	docker run -d --rm --privileged --cgroupns=host --volume=/sys/fs/cgroup:/sys/fs/cgroup:rw artis3n/docker-arch-ansible:$${TAG:-test}
	docker exec --tty test-container env TERM=xterm ansible --version
	docker stop test-container

.PHONY: build
build:
	docker build . -t artis3n/docker-arch-ansible:$${TAG:-test}

.PHONY: run
run: build
	docker run -id --rm --name runner --privileged --cgroupns=host --volume=/sys/fs/cgroup:/sys/fs/cgroup:rw artis3n/docker-arch-ansible:$${TAG:-test}
	-docker exec -it runner /bin/sh
	docker stop runner
