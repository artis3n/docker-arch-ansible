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
RUN ln -sf /etc/systemd/system/container.target /etc/systemd/system/default.target \
    && mkdir /etc/ansible \
    && printf "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

ENV term="xterm"

RUN pip3 install --no-cache-dir --break-system-packages $pip_packages

STOPSIGNAL SIGRTMIN+3

VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT  ["/sbin/init"]
CMD ["--log-level=info"]
