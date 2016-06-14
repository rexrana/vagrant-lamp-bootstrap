# vagrant-lamp-bootstrap

A development environment setup for a LAMP stack inside Vagrant.

### What this does

This is a basic Vagrant setup which provides all the basic tools for PHP, Drupal and WordPress web development. It will:

* setup a Ubuntu 14.04 LTS "Trusty Tahr" 64bit box
* make the box accessable by the host at IP `192.168.33.22`
* sync 'home' folder to `/home/vagrant`
* sync 'www' folder to `/var/www`
* Provision server with bootstrap.sh

The bootstrap.sh will:

* update, upgrade Ubuntu base packages
* Install LAMP server
* Install development tools: git, Composer, Ruby, LESS, SASS, node.js, Grunt, Gulp, Bower, Drupal Console, Drush, WP-CLI

### How to use

Before using this script, you will need to install [VirtualBox](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com/) on your host OS.
Clone or download this repository. Run a `vagrant up` on the command line, within the root folder.
