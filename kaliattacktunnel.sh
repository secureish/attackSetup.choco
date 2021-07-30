#!/bin/bash
sudo apt -y update
sudo apt -y install iptables-persistent netfilter-persistent python3-pip

sudo systemctl disable network-manager.service
echo -en "\n\nauto eth0\niface eth0 inet dhcp\nauto eth1\niface eth1 inet static\n\taddress 192.168.152.100\n\tnetmask 255.255.255.0" | sudo tee -a /etc/network/interfaces
sudo service networking restart

sudo sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf

sudo iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
sudo netfilter-persistent save
sudo systemctl enable netfilter-persistent.service

wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt -y update
sudo apt -y install apt-transport-https
sudo apt -y update
sudo apt -y install dotnet-sdk-3.1 dnsutils
rm packages-microsoft-prod.deb

sudo git clone --recurse-submodules https://github.com/ZeroPointSecurity/Covenant.git /opt/Covenant
sudo git clone https://github.com/rbsec/dnscan.git /opt/dnscan
sudo git clone https://github.com/chinarulezzz/spoofcheck /opt/spoofcheck; cd /opt/spoofcheck; sudo pip3 install -r requirements.txt
sudo git clone https://gist.github.com/superkojiman/11076951 /opt/namemash; sudo chmod +x /opt/namemash/namemash.py
sudo git clone https://github.com/byt3bl33d3r/SprayingToolkit.git /opt/SprayingToolkit; cd /opt/SprayingToolkit; sudo pip3 install -r requirements.txt
sudo git clone https://github.com/FortyNorthSecurity/Egress-Assess.git /opt/Egress-Assess
sudo gem install evil-winrm

sudo systemctl enable ssh.service

echo -en "\nKick Ass and Take Names!\n\n" | sudo tee /etc/motd

sudo reboot