# docker-arch-ansible

Arch Linux Docker container for Ansible playbook and role testing.
Inspired by <https://github.com/geerlingguy/docker-ubuntu2004-ansible>.

## Tags

- `latest`: Latest stable version of Ansible.

The latest tag is a lightweight image for basic validation of Ansible playbooks.

## How to Build

This image is built any time a commit is made or merged to the `master` branch.
But if you need to build the image on your own locally, do the following:

  1. [Install Docker](https://docs.docker.com/install/).
  2. `cd` into this directory.
  3. Run `make build`.

## How to Use

1. [Install Docker](https://docs.docker.com/engine/installation/).
2. Pull this image from Docker Hub: `docker pull artis3n/docker-arch-ansible:latest` (or use the image you built earlier).
3. Run a container from the image: `docker run -id --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro artis3n/docker-arch-ansible:latest`.
4. Use Ansible inside the container:
   1. `docker exec -t [container_id] ansible --version`
   2. `docker exec -t [container_id] ansible-playbook /path/to/ansible/playbook.yml --syntax-check`
