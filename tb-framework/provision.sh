#!/usr/bin/env bash
# Download and configure tb-framework
if [[ ! -d "/srv/www/tb-framework" ]]; then
	echo -e "\nDownloading tb-framework, see http://svn.tela-botanica.net/svn/applications/framework"
	cd /srv/www
	svn checkout "http://svn.tela-botanica.net/svn/applications/framework/trunk/framework/" tb-framework

	# install
	cd tb-framework
	cp config.defaut.ini config.ini
else
	echo "tb-framework already installed."
fi
