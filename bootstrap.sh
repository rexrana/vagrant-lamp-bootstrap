#! /bin/bash

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
echo "Installing git..."
sudo apt-get -y install git

# install Composer
echo "Installing Composer..."
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Install node.js
echo "Installing node.js..."
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Gulp and Grunt task runners (requires node.js)
echo "Installing Gulp and Grunt task runners..."
npm install -g grunt-cli
npm install -g gulp-cli

# Intall Bower (front-end package manager)
echo "Installing Bower..."
npm install -g bower

# Install LESS css preprocessor (requires node.js)
echo "Installing LESS CSS preprocessor..."
npm install -g less

# Install Ruby
echo "Installing Ruby..."
sudo apt-get -y install ruby-full

# Install Sass (requires Ruby)
echo "Installing SASS CSS preprocessor..."
sudo su -c "gem install sass"

# Install Drupal Console and Drush (used for Drupal development)
echo "Installing Drupal development tools..."
# get the latest Drupal Console and Drush:
curl https://drupalconsole.com/installer -L -o drupal.phar
php -r "readfile('http://files.drush.org/drush.phar');" > drush
# Apply executable permissions on the downloaded files:
chmod +x drupal.phar
chmod +x drush
# Accessing from anywhere on your system:
sudo mv drupal.phar /usr/local/bin/drupal
sudo mv drush /usr/local/bin
# Optional. Enrich the bash startup file with completion and aliases.
drush init

# Install WP-CLI (used for WordPress development)
echo "Installing WordPress development tools..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# Create .provisioned for the script to check on during a next vargant up.
cd /home/vagrant
touch .provisioned
echo "Provisioning completed..."
