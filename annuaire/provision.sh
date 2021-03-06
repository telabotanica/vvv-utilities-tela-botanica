#!/usr/bin/env bash
# Download and configure l'annuaire
if [[ ! -d "/srv/www/annuaire" ]]; then
	echo -e "\nDownloading annuaire, see https://github.com/telabotanica/annuaire"
	cd /srv/www
	git clone --depth=1 "https://github.com/telabotanica/annuaire"

	# install
	cd annuaire
	su vagrant -c "composer install"
	cp config/config.default.json config/config.json
	cp config/service.default.json config/service.json
	cp config/clef-auth.defaut.ini config/clef-auth.ini

	# tweaking config
	old_path="\/home\/stuff\/www\/wordpress"
	new_path="\/srv\/www\/tela-botanica\/public_html"
	sed -i "s/$old_path/$new_path/" config/config.json
	sed -i 's/"base": "wordpress"/"base": "wordpress_tb"/' config/config.json
	sed -i 's/"prefixe": "wp_"/"prefixe": ""/' config/config.json
	sed -i 's/"login": ""/"login": "wp"/' config/config.json
	sed -i 's/"mdp": ""/"mdp": "wp"/' config/config.json
	sed -i 's/"nom_cookie": "tb_auth"/"nom_cookie": "tb_auth_local_dev"/' config/config.json
	# tweaking service
	sed -i 's/"domain_root": "localhost"/"domain_root": "api\.tela-botanica\.test"/' config/service.json
	sed -i 's/"base_uri": "\/service:annuaire-ng"/"base_uri": "\/service:annuaire"/' config/service.json
	sed -i 's/"curl_soft_ssl": false/"curl_soft_ssl": true/' config/service.json
	sed -i 's/"domaine_cookie": ".*"/"domaine_cookie": "tela-botanica.test"/' config/service.json
else
	echo "annuaire already installed, trying to upgrade"
	cd /srv/www/annuaire
	if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
		git pull
		su vagrant -c "composer install"
	else
		echo "cannot pull, please commit first"
	fi
fi
