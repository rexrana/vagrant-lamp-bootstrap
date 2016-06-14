#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
MYSQL_ROOT_PWD='12345678'

##### PROVISION CHECK ######

# The provision check is intented to not run the full provision script when a box has already been provisioned.
# At the end of this script, a file is created on the vagrant box, we'll check if it exists now.
echo "Checking if the box was already provisioned..."

if [ -e "/home/vagrant/.provisioned" ]
then
    echo "Provisioning already completed. Skipping..."
    exit 0
else
    echo "Provisioning web server..."
fi

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache 2.5 and php 5.5
sudo apt-get install -y apache2
sudo apt-get install -y php5

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PWD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PWD"
sudo apt-get -y install mysql-server
sudo apt-get install php5-mysql

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
service apache2 restart

# install git
sudo apt-get -y install git

# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Install node.js
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Gulp and Grunt task runners (requires node.js)
npm install -g grunt-cli
npm install -g gulp-cli

# Intall Bower (front-end package manager)
npm install -g bower

# Install LESS css preprocessor (requires node.js)
npm install -g less

# Install Ruby
sudo apt-get -y install ruby-full

# Install Sass (requires Ruby)
sudo su -c "gem install sass"

find /home/vagrant -name "*.sh" -exec chmod +x {} \;

# Install Drupal Console and Drush (used for Drupal development)
/home/vagrant/drupal.sh

# Install WP-CLI (used for WordPress development)
/home/vagrant/wordpress.sh

# virtual hosts
#/home/vagrant/vhost-drupal.sh
#/home/vagrant/vhost-wordpress.sh

# Create .provisioned for the script to check on during a next vargant up.
cd /home/vagrant
touch .provisioned
echo "Provisioning completed..."
