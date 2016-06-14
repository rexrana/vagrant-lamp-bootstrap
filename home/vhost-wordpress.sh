#!/bin/bash

DOMAIN='wordpress.dev'
MYSQL_DB='wordpress'
MYSQL_USER='wordpress'
MYSQL_PWD='wordpress'
SITE_NAME='WordPress development'
SITE_LOCALE='en_CA'
ADMIN_USER='admin'
ADMIN_EMAIL='webmaster@$DOMAIN'
ADMIN_PWD='wordpress'

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

# Create a new WordPress project using WP-CLI
wp core download --PATH="/var/www/$DOMAIN"
cd /var/www/$DOMAIN

# Standard wp-config.php file
wp core config --dbname=$MYSQL_DB --dbuser=$MYSQL_USER --dbpass=$MYSQL_PWD --locale=$SITE_LOCALE
    --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
PHP

wp core install --url="$DOMAIN" --title="$SITE_NAME" --admin_user="$ADMIN_USER"
    --admin_password="$ADMIN_PWD"
    --admin_email="$ADMIN_EMAIL"
    --skip-email

# ENABLE SITE
sudo a2ensite $DOMAIN.conf
sudo service apache2 reload
