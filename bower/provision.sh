#!/usr/bin/env bash
# Télécharge et configure bower
if [ 0 -eq $(npm list --depth 1 --global bower 2>/dev/null | grep -c "bower@") ]; then
	echo "Installing bower..."
	npm install bower -g --unsafe-perm;

	echo '{ "allow_root": true }' > /root/.bowerrc
else
	echo "bower already installed."
fi
