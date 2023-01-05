#!/usr/bin/env sh

if [ ! -f /usr/local/bin/hadolint ]; then
    echo "Running hadolint from docker container"
    docker run --rm -i \
    -v "$(pwd)"/hadolint.yml:/.config/hadolint.yaml \
    hadolint/hadolint <Dockerfile
else
    echo "Running hadolint"
    hadolint -c "$(pwd)"/hadolint.yml Dockerfile
fi
