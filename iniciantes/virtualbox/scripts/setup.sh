#!/bin/bash -eux

# Add vagrant user to sudoers.
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Disable daily apt unattended updates.
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

# Install Ansible repository.
apt -y update && apt-get -y upgrade
apt -y install software-properties-common
apt-add-repository ppa:ansible/ansible

# Install Ansible.
apt -y update
apt -y install screen python-pip python-dev

# Install Docker-py
pip install --upgrade pip
pip install docker-py

# Uninstall Ansible and remove PPA.
apt -y remove --purge ansible
apt-add-repository --remove ppa:ansible/ansible

# Apt cleanup.
apt autoremove
apt update

# Delete unneeded files.
rm -f /home/vagrant/*.sh

# Zero out the rest of the free space using dd, then delete the written file.
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync
