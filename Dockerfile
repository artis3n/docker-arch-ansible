FROM manjarolinux/base:latest
LABEL maintainer="captain-proton"

ENV container="docker"

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
              ansible-core \
              --noconfirm && \
    # Clean up
    pacman -Scc --noconfirm --noprogressbar --quiet && \
    # Fix potential UTF-8 errors with ansible-test.
    locale-gen en_US.UTF-8

COPY container.target /etc/systemd/system/container.target
RUN ln -sf /etc/systemd/system/container.target /etc/systemd/system/default.target \
    && printf "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

ENV term="xterm"

STOPSIGNAL SIGRTMIN+3

VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT  ["/sbin/init"]
CMD ["--log-level=info"]
