#!/usr/bin/env bash
# Télécharge et configure ezmlm-php
if [[ ! -d "/srv/www/ezmlm-php" ]]; then
	echo -e "\nDownloading ezmlm-php, see https://github.com/telabotanica/ezmlm-php"
	cd /srv/www
	git clone --depth=1 "https://github.com/telabotanica/ezmlm-php"

	# install
	cd ezmlm-php
	cp config/config.default.json config/config.json
	cp config/service.default.json service/config.json
	composer install
	# tweaking config
	## sed "domainsPath":, "domain":, "annuaireURL":,
	# tweaking service
	## sed domain_root" :
	# copy mailing-list files to local dir from sequoia (scp sequoia:/home/vpopmail/domains/tela-botanica.org/super-test/ /srv/www/vpopmail/super-test)
	# or extract from archive (tar zxvf ezmlm-php/super-test.tar.gz -C /srv/www/vpopmail/local.tela-botanica.test/super-test)
else
	echo "ezmlm-php already installed."
fi
