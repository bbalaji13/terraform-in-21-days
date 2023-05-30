#!/bin/bash

sudo apt update

sudo apt install -y apache2

sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod ssl

sudo service apache2 restart
