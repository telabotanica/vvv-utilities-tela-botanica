#!/usr/bin/env bash
# Télécharge et configure ezmlm-forum
if [[ ! -d "/srv/www/ezmlm-forum" ]]; then
	echo -e "\nDownloading ezmlm-forum, see https://github.com/telabotanica/ezmlm-forum"
	cd /srv/www
	git clone --depth=1 "https://github.com/telabotanica/ezmlm-forum"

	# install
	cd ezmlm-forum
	npm install
	npm run build
	cp config/config.default.json config/config.json
	# tweaking config
	## set "domainRoot":, "rootUri":, "annuaireURL":, "avatarService":
else
	echo "ezmlm-forum already installed, trying to upgrade"
	cd /srv/www/ezmlm-forum
	if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
		git pull
		npm install
		npm run build
	else
		echo "cannot pull, please commit first"
	fi
fi
