#!/usr/bin/env bash
# Télécharge et configure ezmlm-forum
if [[ ! -d "/srv/www/ezmlm-forum" ]]; then
	echo -e "\nDownloading ezmlm-forum, see https://github.com/telabotanica/ezmlm-forum"
	cd /srv/www
	git clone --depth=1 "https://github.com/telabotanica/ezmlm-forum"

	# install
	cd ezmlm-forum
	cp config/config.default.json config/config.json
	bower install
	# tweaking config
	## set "domainRoot":, "rootUri":, "annuaireURL":, "avatarService":
else
	echo "ezmlm-forum already installed."
fi
