#!/usr/bin/env bash
# Télécharge et configure cumulus
if [[ ! -d "/srv/www/cumulus" ]]; then
	echo -e "\nDownloading cumulus, see https://github.com/telabotanica/cumulus"
	cd /srv/www
	git clone --depth=1 "https://github.com/telabotanica/cumulus"

	# install
	cd cumulus
	composer install
	cp config/config.default.json config/config.json
	cp config/service.default.json config/service.json

	# tweaking config
	sed -i 's/"username": ""/"username": "wp"/' config/config.json
	sed -i 's/"password": ""/"password": "wp"/' config/config.json
	old_path='"storage_root": "\/home\/fernand\/path\/to\/storage"'
	new_path='"storage_root": "\/srv\/www\/tela-botanica-tools\/cumulus-documents"'
	sed -i "s/$old_path/$new_path/" config/config.json
	old_path='"annuaireURL": "https:\/\/localhost/service:annuaire:auth"'
	new_path='"annuaireURL": "http:\/\/local\.tela-botanica\.test\/service:annuaire:auth"'
	sed -i "s/$old_path/$new_path/" config/config.json
	# tweaking service
	sed -i 's/"domain_root": "http:\/\/localhost"/"domain_root": "http:\/\/local\.tela-botanica\.test"/' config/service.json
	sed -i 's/"base_uri": "\/cumulus"/"base_uri": "\/service:cumulus"/' config/service.jsononfig.yaml

	# Make a database for Cumulus, if we don't already have one
	echo -e "\nCreating database 'cumulus' (if it's not already there)"
	mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS cumulus"
	mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON cumulus.* TO wp@localhost IDENTIFIED BY 'wp';"
	echo -e "\n DB operations done.\n\n"

	# initiate cumulus storage
	## mkdir _projets/149 tar xcvf projet149.tar.gz _projets/149
	## mysql -u wp -p cumulus < cumulus_files.sql
else
	echo "cumulus already installed."
fi
