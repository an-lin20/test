#!/bin/bash

echo "Updating package lists..."
sudo apt update -y

echo "Installing OpenSSH Server..."
sudo apt install -y openssh-server

echo "Enabling and starting SSH service..."
sudo systemctl enable ssh
sudo systemctl start ssh

echo "Checking SSH service status..."
sudo systemctl status ssh --no-pager

echo "Configuring firewall to allow SSH..."
sudo ufw allow ssh
sudo ufw reload

echo "Firewall status:"
sudo ufw status

echo "Getting current IP address..."
ip addr | grep inet | grep -v '127.0.0.1' | awk '{print $2}'

echo "Setup complete! Try connecting to your server using the displayed IP address."
