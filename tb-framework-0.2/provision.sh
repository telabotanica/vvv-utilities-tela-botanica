#!/usr/bin/env bash
# Télécharge et configure tb-framework-0.2
if [[ ! -d "/srv/www/tb-framework-0.2" ]]; then
	echo -e "\nDownloading tb-framework-0.2, see http://svn.tela-botanica.net/svn/applications/framework"
	cd /srv/www
	svn checkout "http://svn.tela-botanica.net/svn/applications/framework/branches/v0.2-buhl/framework/" tb-framework-0.2

	# install
	cd tb-framework-0.2
	cp config.defaut.ini config.ini
else
	echo "tb-framework-0.2 already installed."
fi
