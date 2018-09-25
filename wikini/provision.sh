#!/usr/bin/env bash
# Download and configure yeswiki
if [[ ! -d "/srv/www/eFloreRedaction" ]]; then
	echo -e "\nDownloading yeswiki, see https://github.com/telabotanica/yeswiki"
	cd /srv/www
	git clone --depth=1 "https://github.com/telabotanica/yeswiki" eFloreRedaction

	# Make a database for yeswiki, if we don't already have one
	echo -e "\nCreating database 'wikini' (if it's not already there)"
	mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS wikini"
	mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON wikini.* TO wp@localhost IDENTIFIED BY 'wp';"
	echo -e "\n DB operations done.\n\n"

	# install
	cd eFloreRedaction
	tar xf wikini.sql.tar.xf
	mysql -u wp -pwp wikini < wikini.sql
	rm wikini.sql

	# write config
	touch wakka.config.php

	cat <<WAKKACONFIG >> wakka.config.php
<?php
// ne changez pas la wikini_version manuellement!

\$wakkaConfig = array (
  'wakka_version' => '0.1.1',
  'wikini_version' => '0.5.0',
  'yeswiki_version' => '0.2',
  'debug' => 'no',
  'mysql_host' => 'localhost',
  'mysql_database' => 'wikini',
  'mysql_user' => 'wp',
  'mysql_password' => 'wp',
  'table_prefix' => 'eFloreRedaction_',
  'root_page' => 'PagePrincipale',
  'wakka_name' => 'eFloreRedaction',
  'base_url' => 'http://local.tela-botanica.test/eFloreRedaction/wakka.php?wiki=',
  'rewrite_mode' => '0',
  'meta_keywords' => '',
  'meta_description' => '',
  'action_path' => 'actions',
  'handler_path' => 'handlers',
  'header_action' => 'header',
  'footer_action' => 'footer',
  'navigation_links' => 'DerniersChangements :: DerniersCommentaires :: ParametresUtilisateur',
  'referrers_purge_time' => 1000000,
  'pages_purge_time' => 1000000,
  'default_write_acl' => '+',
  'default_read_acl' => '*',
  'default_comment_acl' => '+',
  'preview_before_save' => '0',
  'allow_raw_html' => '1',
  'favorite_theme' => 'bootstrap',
  'favorite_style' => 'telabotanica.css',
  'favorite_squelette' => '2cols-left-tb.tpl.html',
  'hide_action_template' => '1',
  'sso_url' => 'http://api.tela-botanica.test/service:annuaire:auth/',
  'use_sso' => '1',
);
?>
WAKKACONFIG

else
	echo "yeswiki already installed, trying to upgrade"
  cd /srv/www/eFloreRedaction
  if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
    git pull
  else
    echo "cannot pull, please commit first"
  fi
fi
