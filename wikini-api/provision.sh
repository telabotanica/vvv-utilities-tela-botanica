#!/usr/bin/env bash
# Download and configure wikini-api
if [[ ! -d "/srv/www/wikini-api" ]]; then

  echo -e "\nDownloading wikini-api, see https://github.com/telabotanica/wikini-api"
  cd /srv/www
  git clone --depth=1 "https://github.com/telabotanica/wikini-api"

	# install api
	cd wikini-api
  ln -s /srv/www/wikini-api/api /srv/www/eFloreRedaction/api
  ln -s /srv/www/wikini-api/api.php /srv/www/eFloreRedaction/api.php
  cp api/scripts/configurations/config.defaut.ini api/scripts/configurations/config.ini
  cp api/rest/configurations/config.defaut.ini api/rest/configurations/config.ini
  # theme and other stuff
  ln -s /srv/www/wikini-api/themes/bootstrap /srv/www/eFloreRedaction/themes/bootstrap
  ln -s /srv/www/wikini-api/setup/doc/* /srv/www/eFloreRedaction/setup/doc/
  # templates folder already exists in destination folder
  mv tools/templates .
  # link other folders
  ln -s /srv/www/wikini-api/tools/* /srv/www/eFloreRedaction/tools/
  # return templates to origin folder and link stuff
  mv templates tools/templates
  ln -s /srv/www/wikini-api/tools/templates/actions/barreredaction.php /srv/www/eFloreRedaction/tools/templates/actions/
  # moteurrecherche_basic.tpl.html already exists, have to replace it
  mv /srv/www/eFloreRedaction/tools/templates/presentation/templates/moteurrecherche_basic.tpl.html /srv/www/eFloreRedaction/tools/templates/presentation/templates/moteurrecherche_basic.tpl.html.bak
  ln -s /srv/www/wikini-api/tools/templates/presentation/templates/moteurrecherche_basic.tpl.html /srv/www/eFloreRedaction/tools/templates/presentation/templates/moteurrecherche_basic.tpl.html

  # config
  old='http://www.tela-botanica.org/service:annuaire-test:utilisateur/identite-par-courriel/'
  new='http://local.tela-botanica.test/service:annuaire:utilisateur/identite-par-courriel/'
  sed -i "s/$old/$new/" api/scripts/configurations/config.ini
  old='/yeswiki/api/rest/'
  new='/eFloreRedaction/api/rest/'
  sed -i "s/$old/$new/g" api/rest/configurations/config.ini

  # adds abs path to framework
  cp api/scripts/framework.defaut.php api/scripts/framework.php
  tbframeworkPath="'\/srv\/www\/tb-framework\/Framework\.php';"
  sed -i "s/^require_once.+/require_once $tbframeworkPath/" api/scripts/framework.php


else
	echo "wikini-api already installed, trying to upgrade"
  cd /srv/www/wikini-api
  if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
    git pull
  else
    echo "cannot pull, please commit first"
  fi
fi
