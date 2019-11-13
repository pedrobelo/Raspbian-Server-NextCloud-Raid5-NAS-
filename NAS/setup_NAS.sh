#!/bin/bash

#install samba
sudo apt-get install samba

www-data

#append share senttings to settings file
sudo cat share_settings >> file1

#restart samba
sudo service smbd restart

#update firewall rules
sudo apt-get install ufw
sudo ufw allow samba