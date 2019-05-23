#!/usr/bin/env bash
# Download and configure bower
if [ 0 -eq $(npm list --depth 1 --global bower 2>/dev/null | grep -c "bower@") ]; then
	echo "Installing bower..."
	su vagrant -c "npm install bower -g --unsafe-perm"

	echo '{ "allow_root": true }' > /root/.bowerrc
else
	echo "bower already installed."
fi
