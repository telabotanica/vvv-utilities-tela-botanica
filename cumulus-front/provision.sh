#!/usr/bin/env bash
# Télécharge et configure cumulus-front
if [[ ! -d "/srv/www/cumulus-front" ]]; then
	echo -e "\nDownloading cumulus-front, see https://github.com/telabotanica/cumulus-front"
	cd /srv/www
	git clone --depth=1 "https://github.com/telabotanica/cumulus-front"

	# install
	cd cumulus-front
	npm install
	cp app/utils/main-config.defaut.js app/utils/main-config.js

	# tweaking config (just for basic usage, gonna be overload by tb-plugin)
	old_path='http:\/\/api\.tela-botanica\.org\/cumulus'
	new_path='http:\/\/api\.tela-botanica\.test\/service:cumulus:doc'
	sed -i "s/$old_path/$new_path/" app/utils/main-config.js
	old_path='https:\/\/www\.tela-botanica\.org\/service:annuaire'
	new_path='http:\/\/api\.tela-botanica\.test\/service:annuaire'
	sed -i "s/$old_path/$new_path/g" app/utils/main-config.js
else
	echo "cumulus-front already installed."
fi
