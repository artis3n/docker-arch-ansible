# docker-arch-ansible

Arch Linux Docker container for Ansible playbook and role testing. Inspired by <https://github.com/geerlingguy/docker-ubuntu2004-ansible>.

## How to Use

1. [Install Docker](https://docs.docker.com/engine/installation/).
2. Pull this image from Docker Hub: `docker pull artis3n/docker-arch-ansible:latest` (or use the image you built earlier, e.g. `arch-ansible:latest`).
3. Run a container from the image: `docker run --detach --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro artis3n/docker-arch-ansible:latest`.
4. Use Ansible inside the container:
a. `docker exec --tty [container_id] ansible --version`
b. `docker exec --tty [container_id] ansible-playbook /path/to/ansible/playbook.yml --syntax-check`
