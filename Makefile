##
# docker-manjaro-ansible
#
# @file
# @version 0.1

#!/usr/bin/env make

.PHONY: install
install:
	if [ ! -f /usr/local/bin/goss ]; then curl -fsSL https://goss.rocks/install | sh; fi

.PHONY: lint
lint:
	bash lint.sh

.PHONY: size
size: build
	bash dive.sh $${TAG:-test}

.PHONY: test
test: build
	dgoss run -it --rm --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro captain-proton/docker-manjaro-ansible:$${TAG:-test}
	# CI=true make size

.PHONY: test-edit
test-edit: build
	dgoss edit -it --rm --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro captain-proton/docker-manjaro-ansible:$${TAG:-test}

.PHONY: build
build:
	docker build . -t captain-proton/docker-manjaro-ansible:$${TAG:-test}

.PHONY: run
run: build
	docker run -id --rm --name runner --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro captain-proton/docker-manjaro-ansible:$${TAG:-test}
	-docker exec -it runner /bin/sh
	docker stop runner
# end
