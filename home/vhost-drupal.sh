#!/usr/bin/env bash

DOMAIN='drupal8.dev'
MYSQL_DB='drupal8'
MYSQL_USER='drupal8'
MYSQL_PWD='drupal8'
DRUPAL_SITE_NAME='Drupal 8 development'
DRUPAL_ADMIN_USER='admin'
DRUPAL_ADMIN_EMAIL='webmaster@$DOMAIN'
DRUPAL_ADMIN_PWD='drupal8'

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/${DOMAIN}"
    <Directory "/var/www/${DOMAIN}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/$DOMAIN.conf

# MySQL/MariaDB script to create database and user, and grant priveleges
MYSQL_SCRIPT=$(cat <<EOF
CREATE DATABASE $MYSQL_DB CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER $MYSQL_USER@localhost IDENTIFIED BY '$MYSQL_PWD';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES ON $MYSQL_DB.* TO '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PWD';
EOF
)

mysql -u root -p $MYSQL_ROOT_PWD -e "$MYSQL_SCRIPT"

# Create a new Drupal 8 project using Drupal Console
cd /var/www/
drupal site:new $DOMAIN
drupal site:install  standard --langcode="en" --db-type="mysql" --db-host="127.0.0.1"
       --db-name="$MYSQL_DB" --db-user="$MYSQL_USER" --db-pass="$MYSQL_USER" --db-port="3306"
       --site-name="$DRUPAL_SITE_NAME" --site-mail="$DRUPAL_ADMIN_EMAIL"
       --account-name="$DRUPAL_ADMIN_USER" --account-mail="$DRUPAL_ADMIN_EMAIL" --account-pass="$DRUPAL_ADMIN_PWD"
       --no-interaction

# ENABLE SITE
sudo a2ensite $DOMAIN.conf
sudo service apache2 reload
