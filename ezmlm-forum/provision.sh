#!/usr/bin/env bash
# Download and configure ezmlm-forum
if [[ ! -d "/srv/www/ezmlm-forum" ]]; then
	echo -e "\nDownloading ezmlm-forum, see https://github.com/telabotanica/ezmlm-forum"
	cd /srv/www
	git clone --depth=1 "https://github.com/telabotanica/ezmlm-forum"

	# install
	cd ezmlm-forum
	su vagrant -c "npm install --unsafe-perm"
	su vagrant -c "npm run build"
	cp config/config.default.json config/config.json
	# tweaking config
	## set "domainRoot":, "rootUri":, "annuaireURL":, "avatarService":
else
	echo "ezmlm-forum already installed, trying to upgrade"
	cd /srv/www/ezmlm-forum
	if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
		git pull
		su vagrant -c "npm install --unsafe-perm"
		su vagrant -c "npm run build"
	else
		echo "cannot pull, please commit first"
	fi
fi
