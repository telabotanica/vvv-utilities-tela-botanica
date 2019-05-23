#!/usr/bin/env bash
# Download and configure ezmlm-php
if [[ ! -d "/srv/www/ezmlm-php" ]]; then
	echo -e "\nDownloading ezmlm-php, see https://github.com/telabotanica/ezmlm-php"
	cd /srv/www
	git clone --depth=1 "https://github.com/telabotanica/ezmlm-php"

	# install
	cd ezmlm-php
	cp config/service.default.json config/service.json
	cp config/config.default.json config/config.json
	su vagrant -c "composer install"
	# tweaking config
	sed -i 's/"domainsPath": ".*"/"domainsPath": "\/srv\/www\/vpopmail\/domains"/' config/config.json
	sed -i 's/"annuaireURL": ".*"/"annuaireURL": "http:\/\/api.tela-botanica.test\/service:annuaire:auth"/' config/config.json
	#sed -i 's/"headerName": ".*"/"headerName": "Auth"/' config/config.json
	# tweaking service
	sed -i 's/"domain_root": ".*"/"domain_root" : "http:\/\/api.tela-botanica.test"/' config/service.json

	# # replace imported symlink
	# rm /srv/www/tela-botanica/public_html/wp-content/plugins/tela-botanica/outils/forum
	# ln -s /srv/www/ezmlm-php /srv/www/tela-botanica/public_html/wp-content/plugins/tela-botanica/outils/forum
else
	echo "ezmlm-php already installed, trying to upgrade"
	cd /srv/www/ezmlm-php
	if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
		git pull
		su vagrant -c "composer install"
	else
		echo "cannot pull, please commit first"
	fi
fi
