#!/usr/bin/env bash
# Provision other tela-botanica apps

# Cloning each tools
tools="annuaire
cumulus
cumulus-front
chorologie
ezmlm-php
ezmlm-forum"

autHeader="Auth"
# domain wide cookie, all subdomains are covered
cookieDomain="tela-botanica.dev"
# wordpress subdomain
wpSubDomain="local"
# annuaire subdomain
annuaireUrl="http://annuaire.tela-botanica.dev/"

for tool in "$tools"
do
  if [[ ! -d "${VVV_PATH_TO_SITE}/$tool" ]]; then

    echo "Downloading $tool, see https://github.com/telabotanica/$tool"
    cd ${VVV_PATH_TO_SITE}
    git clone https://github.com/telabotanica/$tool $tool
    cd ${VVV_PATH_TO_SITE}/$tool

    echo "Configuring $tool"
    if [ "$tool" == "annuaire" ]
      composer install
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
      sed -i 's/"domain_root": "localhost"/"domain_root": "http:\/\/local\.tela-botanica\.test"/' config/service.json
      sed -i 's/"base_uri": "\/service:annuaire-ng"/"base_uri": "\/service:annuaire"/' config/service.json
      sed -i 's/"curl_soft_ssl": false/"curl_soft_ssl": true/' config/service.json
    fi
    if [ "$tool" == "cumulus" ]
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
    fi
    if [ "$tool" == "cumulus-front" ]
      npm install
      cp app/utils/main-config.defaut.js app/utils/main-config.js

      # tweaking config (just for basic usage, gonna be rewriten by tb-plugin tho)
      old_path='http:\/\/api\.tela-botanica\.org\/cumulus'
      new_path='http:\/\/local\.tela-botanica\.test\/service:cumulus:doc'
      sed -i "s/$old_path/$new_path/" app/utils/main-config.js
      old_path='https:\/\/www\.tela-botanica\.org\/service:annuaire'
      new_path='http:\/\/local\.tela-botanica\.test\/service:annuaire'
      sed -i "s/$old_path/$new_path/g" app/utils/main-config.js
    fi
    if [ "$tool" == "chorologie" ]
      cp configurations/config.defaut.ini configurations/config.ini
      # tweaking chorologie config
      sed -i 's/^domaine = "www\.tela-botanica\.org"/domaine = "local\.tela-botanica\.test"/' configurations/config.ini
      sed -i 's/^base_url_application = "https:/base_url_application = "http:/' configurations/config.ini

      # installs tela-botanica framework
      svn checkout http://svn.tela-botanica.net/svn/applications/framework/trunk/framework/ ../tbframework
      cp ../tbframework/config.defaut.ini ../tbframework/config.ini

      # adds abs path to framework
      cp framework.defaut.php framework.php
      tbframeworkPath="'\/srv\/www\/tbframework\/Framework\.php';"
      sed -i "s/^require_once.+/require_once $tbframeworkPath" framework.php
    fi
    if [ "$tool" == "ezmlm-forum" ]
      cp config/config.default.json config/config.json
      bower install
      # tweaking config
      ## set "domainRoot":, "rootUri":, "annuaireURL":, "avatarService":
    fi
    if [ "$tool" == "ezmlm-php" ]
      cp config/config.default.json config/config.json
      cp config/service.default.json service/config.json
      composer install
      # tweaking config
      ## sed "domainsPath":, "domain":, "annuaireURL":,
      # tweaking service
      ## sed domain_root" :
      # copy mailing-list files to local dir from sequoia (scp sequoia:/home/vpopmail/domains/tela-botanica.org/super-test/ /srv/www/vpopmail/super-test)
      # or extract from archive (tar zxvf ezmlm-php/super-test.tar.gz -C /srv/www/vpopmail/local.tela-botanica.test/super-test)
    fi
  fi

done

# Installs eflore-consultation
if [[ ! -d "${VVV_PATH_TO_SITE}/eflore-consultation" ]]; then
  svn checkout http://svn.tela-botanica.net/svn/eflore/applications/eflore-consultation/trunk/ ${VVV_PATH_TO_SITE}/eflore-consultation
  cd ${VVV_PATH_TO_SITE}/eflore-consultation
  cp configurations/config.defaut.ini configurations/config.ini
  sed -i 's/^domaine =.+/domaine = "eflore-consultation\.dev"' configurations/config.ini
  # adds abs path to framework
  cp framework.defaut.php framework.php
  tbframeworkPath="'\/srv\/www\/tbframework\/Framework\.php';"
  sed -i "s/^require_once.+/require_once $tbframeworkPath" framework.php
  # make it work
  ## add redir url : RewriteRule ^(bdtfx|bdtxa|apd|isfan)[-/:]nn[-/:]([1-9][0-9]+)$ https://beta.tela-botanica.org/test/eflore/?referentiel=$1&module=fiche&action=fiche&num_nom=$2&onglet=synthese [QSA,L,R=302]
  ##RewriteRule ^(bdtfx|bdtxa|apd|isfan)[-/:]nn[-/:]([1-9][0-9]+)([-/:]([a-z]+))?$ https://beta.tela-botanica.org/test/eflore/?referentiel=$1&module=fiche&action=fiche&num_nom=$2&onglet=$4 [QSA,L,R=302]
  ## in conf should be wired with eflore prod api : baseUrlApiEflore = "http://api.tela-botanica.org/service:eflore:0.1/{projet}"
  ## same for del : baseUrlApiDel = "http://api.tela-botanica.org/service:del:0.1/"
fi

# Installs coel-consultation
if [[ ! -d "${VVV_PATH_TO_SITE}/coel-consultation" ]]; then
  svn checkout http://svn.tela-botanica.net/svn/eflore/applications/coel-consultation/trunk/ ${VVV_PATH_TO_SITE}/coel-consultation
  cd ${VVV_PATH_TO_SITE}/coel-consultation
  cp configurations/config.default.ini configurations/config.ini
  sed -i 's/^domaine =.+/domaine = "coel-consultation\.dev"' configurations/config.ini
  # install tbframework-0.2
  svn checkout http://svn.tela-botanica.net/svn//applications/framework/branches/v0.2-buhl/framework/ ../tbframework-0.2
  cp ../tbframework-0.2/config.defaut.ini ../tbframework-0.2/config.ini
  # adds abs path to framework
  cp framework.defaut.php framework.php
  tbframeworkPath="'\/srv\/www\/tbframework-0.2\/autoload\.inc\.php';"
  sed -i "s/^require_once.+/require_once $tbframeworkPath" framework.php
fi

# Nginx Logs
mkdir -p ${VVV_PATH_TO_SITE}/log
touch ${VVV_PATH_TO_SITE}/log/error.log
touch ${VVV_PATH_TO_SITE}/log/access.log
