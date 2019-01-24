#!/usr/bin/env bash
# Download and configure cumulus

DIR=`dirname $0`

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
	old_path='"storage_root": ".*"'
	new_path='"storage_root": "\/srv\/www\/cumulus-documents"'
	sed -i "s/$old_path/$new_path/" config/config.json
	old_path='"annuaireURL": ".*"'
	new_path='"annuaireURL": "http:\/\/api\.tela-botanica\.test\/service:annuaire:auth"'
	sed -i "s/$old_path/$new_path/" config/config.json
	sed -i "s/tb_auth/tb_auth_local_dev/" config/config.json
	# tweaking service
	sed -i 's/"domain_root": ".*"/"domain_root": "http:\/\/api\.tela-botanica\.test"/' config/service.json
	sed -i 's/"base_uri": ".*"/"base_uri": "\/service:cumulus:doc"/' config/service.json

	# Make a database for Cumulus, if we don't already have one
	echo -e "\nCreating database 'cumulus' (if it's not already there)"
	mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS cumulus"
	mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON cumulus.* TO wp@localhost IDENTIFIED BY 'wp';"
	echo -e "\n DB operations done.\n\n"

	# initiate cumulus storage
	mkdir -p /srv/www/cumulus-documents/_projets
	tar zxf ${DIR}/projet149.tar.gz --directory /srv/www/cumulus-documents/_projets/
	# Database
	tar xf ${DIR}/cumulus_files.sql.tar.xz
	mysql -u wp -pwp cumulus < cumulus_files.sql
else
	echo "cumulus already installed, trying to upgrade"
	cd /srv/www/cumulus
	if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
		git pull
		composer install
	else
		echo "cannot pull, please commit first"
	fi
fi
