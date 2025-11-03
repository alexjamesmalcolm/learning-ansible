# Dockerfile
FROM alpine:3.20

# Install and configure OpenSSH, Python, and basic tools
RUN apk add --no-cache openssh shadow sudo python3 py3-pip && \
    ssh-keygen -A && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo 'PermitRootLogin no' >> /etc/ssh/sshd_config && \
    mkdir -p /run/sshd

# Create a vagrant user with password "vagrant" and passwordless sudo
RUN useradd -m -s /bin/ash vagrant && \
    echo "vagrant:vagrant" | chpasswd && \
    echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant && \
    chmod 0440 /etc/sudoers.d/vagrant

# Make python3 the default `python` command
RUN ln -sf python3 /usr/bin/python

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]
