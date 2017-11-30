#!/usr/bin/env bash
# Télécharge et configure eflore-consultation
if [[ ! -d "/srv/www/eflore-consultation" ]]; then
	echo -e "\nDownloading eflore-consultation, see http://svn.tela-botanica.net/svn/eflore/applications/eflore-consultation"
	cd /srv/www
	svn checkout "http://svn.tela-botanica.net/svn/eflore/applications/eflore-consultation/trunk/" eflore-consultation

	# install
	cd eflore-consultation
	cp configurations/config.default.ini configurations/config.ini
	sed -i 's/^domaine =.+/domaine = "local\.tela-botanica\.test"/' configurations/config.ini

	# adds abs path to framework
	cp framework.defaut.php framework.php
	tbframeworkPath="'\/srv\/www\/tb-framework-0.2\/autoload\.inc\.php';"
	sed -i "s/^require_once.+/require_once $tbframeworkPath/" framework.php
else
	echo "eflore-consultation already installed."
fi
