#!/bin/bash

sudo apt update

sudo apt install -y apache2

sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod ssl

git clone https://github.com/gabrielecirulli/2048.git
sudo cp -R 2048/* /var/www/html

sudo service apache2 restart
