#!/bin/bash

echo "Starting setup for public web server..."

echo "Updating package lists and installing Nginx..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y nginx

echo "Enabling and starting Nginx service..."
sudo systemctl enable nginx
sudo systemctl start nginx

echo "Configuring static IP..."
cat <<EOF | sudo tee /etc/netplan/00-installer-config.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      dhcp4: false
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
EOF

echo "Applying network configuration..."
sudo netplan apply

echo "Configuring firewall to allow HTTP and HTTPS traffic..."
sudo ufw allow 'Nginx Full'
sudo ufw enable -y

echo "Fetching public IP address..."
PUBLIC_IP=$(curl -s ifconfig.me)
echo "Your public IP address is: $PUBLIC_IP"

echo "Setup complete!"
echo "Your website should now be accessible locally at http://192.168.1.100 and publicly at http://$PUBLIC_IP"
echo "Please configure port forwarding on your router for ports 80 and 443 to 192.168.1.100 for public access."
