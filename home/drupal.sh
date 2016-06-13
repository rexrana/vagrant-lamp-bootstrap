#!/usr/bin/env bash

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
