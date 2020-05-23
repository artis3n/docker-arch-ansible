FROM archlinux:20200505
LABEL maintainer="Artis3n"

ARG pip_packages="ansible"

RUN pacman -Syu --noconfirm && \
    pacman -S python \
              python-pip \
              systemd \
              sudo \
              cronie \
              git \
              base-devel \
              --noconfirm

RUN locale-gen en_US.UTF-8

COPY initctl_faker .
RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Remove unnecessary getty and udev targets that result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN rm -f /lib/systemd/system/systemd*udev* \
    && rm -f /lib/systemd/system/getty.target

RUN groupadd -r ansible && useradd -r -g ansible ansible
RUN mkdir -p /etc/ansible && chown -R ansible:ansible /etc/ansible
RUN mkdir -p /home/ansible && chown -R ansible:ansible /home/ansible
# Passwordless sudo
RUN echo '%ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ansible

RUN pip3 install $pip_packages
# Install Ansible inventory file
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

ENV term "xterm"

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
