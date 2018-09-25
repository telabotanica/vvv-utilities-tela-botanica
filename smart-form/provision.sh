#!/usr/bin/env bash
# Download and configure smart-form
if [[ ! -d "/srv/www/smart-form" ]]; then
	echo -e "\nDownloading smart-form, see https://github.com/telabotanica/smart-form"
	cd /srv/www
	git clone --depth=1 "https://github.com/telabotanica/smart-form"

	# install
	cd smart-form
	npm install
	cp services/config.ini-dist services/config.ini
	cp js/config/config.js-dist js/config/config.js

	# tweaking config (just for basic usage, gonna be overload by tb-plugin)
	old_path='http:\/\/www.tela-botanica.org\/wikini\/eFloreRedactionTest'
	new_path='http:\/\/local\.tela-botanica\.test'
	sed -i "s/$old_path/$new_path/" services/config.ini
	old_path='http:\/\/localhost'
	new_path='http:\/\/local\.tela-botanica\.test'
	sed -i "s/$old_path/$new_path/g" services/config.ini

else
	echo "smart-form already installed, trying to upgrade"
	cd /srv/www/smart-form
	if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
		git pull
		npm install
	else
		echo "cannot pull, please commit first"
	fi
fi
