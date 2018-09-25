#!/usr/bin/env bash
# Download and configure chorologie
if [[ ! -d "/srv/www/chorologie" ]]; then
	echo -e "\nDownloading chorologie, see https://github.com/telabotanica/chorologie"
	cd /srv/www
	git clone --depth=1 "https://github.com/telabotanica/chorologie"

	# install
	cd chorologie
	cp configurations/config.defaut.ini configurations/config.ini
	# tweaking chorologie config
	sed -i 's/^domaine = "www\.tela-botanica\.org"/domaine = "local\.tela-botanica\.test"/' configurations/config.ini
	sed -i 's/^base_url_application = "https:/base_url_application = "http:/' configurations/config.ini

	# adds abs path to framework
	cp framework.defaut.php framework.php
	tbframeworkPath="'\/srv\/www\/tb-framework\/Framework\.php';"
	sed -i "s/^require_once.+/require_once $tbframeworkPath/" framework.php
else
	echo "chorologie already installed."
fi
