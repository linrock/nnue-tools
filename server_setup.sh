#!/bin/bash

# Install nvidia drivers
sudo apt install -y nvidia-headless-535 nvidia-utils-535
# sudo apt install nvidia-driver-510-server

# Unload open-source drivers and load the official nvidia drivers
sudo rmmod nouveau
sudo modprobe nvidia

# Set up apt repo for Docker
# https://docs.docker.com/engine/install/ubuntu/
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Set up apt repo for Nvidia container toolkit
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
  && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/experimental/$distribution/libnvidia-container.list | \
     sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
     sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Install docker and nvidia container toolkit
sudo apt update
sudo apt install -y docker-ce docker-ce-cli
sudo apt install -y nvidia-docker2

# Enable running docker commands without sudo
sudo groupadd docker
sudo usermod -aG docker $(whoami)
newgrp docker

# Need to restart docker after installing nvidia-docker2 package
sudo systemctl restart docker
