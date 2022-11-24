#!/bin/bash

# Install nvidia drivers
sudo apt install nvidia-headless-520 nvidia-utils-520
# sudo apt install nvidia-driver-510-server

# Install docker and enable running without sudo
sudo apt install docker.io
sudo usermod -aG docker $(whoami)

# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
  && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/experimental/$distribution/libnvidia-container.list | \
     sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
     sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt install nvidia-docker2

# Need to restart docker after installing nvidia-docker2 package
sudo systemctl restart docker
