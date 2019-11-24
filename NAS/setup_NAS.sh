#!/bin/bash

#install samba
#note: setup to use default
sudo apt-get install samba -y

#append share senttings to settings file
sudo cat share_settings >> file1

#missing auto password
sudo smbpasswd -a pi

#restart samba
sudo service smbd restart

#update firewall rules
sudo apt-get install ufw
sudo ufw allow samba
