#!/usr/bin/env bash
# Download and configure cumulus-front
if [[ ! -d "/srv/www/cumulus-front" ]]; then
	echo -e "\nDownloading cumulus-front, see https://github.com/telabotanica/cumulus-front"
	cd /srv/www
	git clone --depth=1 "https://github.com/telabotanica/cumulus-front"

	# install
	cd cumulus-front
	su vagrant -c "npm install --unsafe-perm"
	su vagrant -c "npm run build"
	cp app/utils/main-config.defaut.js app/utils/main-config.js

	# tweaking config (just for basic usage, gonna be overload by tb-plugin)
	old_path='http:\/\/api\.tela-botanica\.org\/cumulus'
	new_path='http:\/\/api\.tela-botanica\.test\/service:cumulus:doc'
	sed -i "s/$old_path/$new_path/" app/utils/main-config.js
	old_path='https:\/\/www\.tela-botanica\.org\/service:annuaire'
	new_path='http:\/\/api\.tela-botanica\.test\/service:annuaire'
	sed -i "s/$old_path/$new_path/g" app/utils/main-config.js
else
	echo "cumulus-front already installed, trying to upgrade"
	cd /srv/www/cumulus-front
	if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
		git pull
		su vagrant -c "npm install --unsafe-perm"
		su vagrant -c "npm run build"
	else
		echo "cannot pull, please commit first"
	fi
fi
