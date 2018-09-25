#!/usr/bin/env bash
# Download and configure sshpass
if [ 0 -eq $(dpkg-query -W -f='${Status}' sshpass 2>/dev/null | grep -c "ok installed") ]; then
	echo "Installing sshpass..."
	apt-get -y install sshpass;
else
	echo "sshpass already installed."
fi
