#!/bin/bash

# get the latest WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# make the file executable and move it to somewhere in your PATH
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
