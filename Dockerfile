FROM terencewestphal/archlinux:latest
LABEL maintainer="Artis3n"

ARG pip_packages="ansible"

RUN pacman -Syu --noconfirm && \
    pacman -S python \
              python-pip \
              systemd-sysvcompat \
              sudo \
              git \
              base-devel \
              --noconfirm && \
    # Clean up
    pacman -Scc --noconfirm --noprogressbar --quiet && \
    # Fix potential UTF-8 errors with ansible-test.
    locale-gen en_US.UTF-8 && \
    systemctl set-default bootstrap.target

STOPSIGNAL SIGRTMIN+3

# Remove unnecessary getty and udev targets that result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
#
# Set permissions on /usr/bin/systemctl
RUN rm -f /lib/systemd/system/systemd*udev* && \
    rm -f /lib/systemd/system/getty.target && \
    chmod 0755 /usr/bin/systemctl

RUN pip3 install $pip_packages
# Install Ansible inventory file
RUN mkdir /etc/ansible && \
    printf "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

ENV term="xterm" \
    container="docker"

VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT ["/usr/sbin/init"]
