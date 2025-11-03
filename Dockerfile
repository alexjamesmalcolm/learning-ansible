# Dockerfile.rocky
FROM rockylinux:9

ENV container=docker

# Systemd, SSH, Python, sudo
RUN dnf -y update && \
    dnf -y install systemd systemd-udev openssh-server sudo python3 python3-pip which && \
    dnf clean all && rm -rf /var/cache/dnf

# OpenSSH setup
RUN mkdir -p /var/run/sshd && \
    ssh-keygen -A && \
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo 'PermitRootLogin no' >> /etc/ssh/sshd_config

# vagrant user with passwordless sudo
RUN useradd -m -s /bin/bash vagrant && \
    echo "vagrant:vagrant" | chpasswd && \
    echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant && \
    chmod 0440 /etc/sudoers.d/vagrant

# Make "python" resolve to python3 (optional)
RUN alternatives --set python /usr/bin/python3 || ln -sf /usr/bin/python3 /usr/bin/python

# Recommended systemd cleanups for containers
RUN systemctl mask getty@.service systemd-logind.service && \
    systemctl set-default multi-user.target

EXPOSE 22
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
