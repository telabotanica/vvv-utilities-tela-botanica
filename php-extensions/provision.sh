#!/usr/bin/env bash
# Télécharge et configure php-mailparse
if [ 0 -eq $(dpkg-query -W -f='${Status}' php-mailparse 2>/dev/null | grep -c "ok installed") ]; then
	echo "Installing php-mailparse..."
	apt-get -y install php-mailparse;
else
	echo "php-mailparse already installed."
fi

# Télécharge et configure php-intl
if [ 0 -eq $(dpkg-query -W -f='${Status}' php-intl 2>/dev/null | grep -c "ok installed") ]; then
	echo "Installing php-intl..."
	apt-get -y install php-intl;
else
	echo "php-intl already installed."
fi
