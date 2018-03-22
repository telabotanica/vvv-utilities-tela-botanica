#!/usr/bin/env bash

DIR=`dirname $0`

if [[ ! -d "/srv/www/vpopmail" ]]; then
	echo -e "\nInstalling vpopmail."

	mkdir -p /srv/www/vpopmail/domains/localhost
	tar xzf ${DIR}/super-test.tar.gz --directory /srv/www/vpopmail/domains/localhost/
else
	echo -e "\nVpopmail already installed."
fi
