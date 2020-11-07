FROM archlinux:latest
LABEL maintainer="Artis3n"

ENV container="docker"
ARG pip_packages="ansible"

RUN pacman -Syu --noconfirm && \
    pacman -S python \
              python-pip \
              python-wheel \
              python-setuptools \
              systemd \
              sudo \
              git \
              base \
              base-devel \
              --noconfirm && \
    # Clean up
    pacman -Scc --noconfirm --noprogressbar --quiet && \
    # Fix potential UTF-8 errors with ansible-test.
    locale-gen en_US.UTF-8

COPY container.target /etc/systemd/system/container.target
RUN ln -sf /etc/systemd/system/container.target /etc/systemd/system/default.target

RUN pip3 install $pip_packages
# Install Ansible inventory file
RUN mkdir /etc/ansible && \
    printf "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

ENV term="xterm"

STOPSIGNAL SIGRTMIN+3

VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT  ["/sbin/init"]
CMD ["--log-level=info"]
