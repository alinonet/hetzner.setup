#!/bin/bash

# Run this script as root to initialize a new Hetzner Cloud server

# Update repositories and system
apt update && apt upgrade -y # # apt-get update && apt-get upgrade -y

# Enable SSH with private keys only
echo 'Press Enter and add the public keys ("ssh-rsa...")...' && read key
nano ~/.ssh/authorized_keys
echo 'Press Enter and modify "PasswordAuthentication no"...' && read key
nano /etc/ssh/sshd_config
mv /etc/ssh/sshd_config.d/50-cloud-init.conf /etc/ssh/sshd_config.d/50-cloud-init.conf~
service ssh restart # systemctl restart ssh.service

# Fix locale settings (to sort correctly)
localectl set-locale C.UTF-8

# (Optional) Add a normal user with sudo priviledges and SSH access
read -n 1 -p "Add the user 'ubuntu'? [Y/n] " key && [[ -z $key ]] && echo
[[ $key =~ [nN] ]] && exit
adduser ubuntu
adduser ubuntu sudo # usermod -aG sudo ubuntu
echo 'Press Enter and add "ubuntu ALL=(ALL) NOPASSWD:ALL"...' && read key
visudo -f /etc/sudoers.d/90-cloud-init-users
mkdir /home/ubuntu/.ssh
cp /root/.ssh/authorized_keys /home/ubuntu/.ssh
chown -R ubuntu:ubuntu /home/ubuntu/.ssh
cd /home/ubuntu/.ssh
su ubuntu

# Tested on
# Ubuntu 20.04.6 LTS
# Ubuntu 22.04.2 LTS
