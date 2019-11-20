#!/bin/bash

echo "Installing Nextcloud"
exit

NEXTCLOUD_DIRECTORY=/var/nextcloud/data #/media/usb #/dev/md0

#do system updates
sudo apt-get update -y
sudo apt-get upgrade -y

#install apache2, mariaDB and php
sudo apt-get install apache2 mariadb-server libapache2-mod-php7.3 php7.3-gd php7.3-json php7.3-mysql php7.3-curl php7.3-mbstring php7.3-intl php-imagick php7.3-xml php7.3-zip -y

#download nextcloud
wget https://download.nextcloud.com/server/releases/nextcloud-17.0.1.tar.bz2
sudo tar -xjf nextcloud-17.0.1.tar.bz2
sudo cp -r nextcloud /var/www


#set config file from apache2
sudo cp nextcloud.conf /etc/apache2/sites-available/nextcloud.conf

#Additional Apache configurations
sudo a2ensite nextcloud.conf
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod env
sudo a2enmod dir
sudo a2enmod mime

#restart apache
sudo service apache2 restart


#enable ssl
sudo a2enmod ssl
sudo a2ensite default-ssl
sudo service apache2 reload

#change the ownership on your Nextcloud directories to your HTTP user
sudo chown -R www-data:www-data /var/www/nextcloud/


#secure MariaDB
echo -e "\n\n${MYSQL_ROOT_PASSWORD}\n${MYSQL_ROOT_PASSWORD}\nn\n\n\n\n" | sudo mysql_secure_installation 2>/dev/null

#login into MariDB and create a user
#database = nextclouddb
#user = nextcloud
#password = 
sudo mysql -u root -p${MYSQL_ROOT_PASSWORD} <<MY_QUERY
CREATE DATABASE nextclouddb;
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY '${DATABASE_PASSWORD}';
GRANT ALL PRIVILEGES ON nextclouddb.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
MY_QUERY

#setup nextcloud account
sudo -u www-data php occ  maintenance:install --database "mysql" --database-name "nextclouddb"  --database-user "nextcloud" --database-pass "${DATABASE_PASSWORD}" --admin-user "${ADMIN}" --admin-pass "${ADMIN_PASSWORD}"

#Set SSL certificate
echo -e "${EMAIL}\nA\nN\n${DOMAIN}" | sudo apt-get install certbot python-certbot-apache -y 2>/dev/null

#review
echo -e "2\n" | sudo certbot --apache

#sudo -u www-data php /var/www/nextcloud/occ files:scan --all