#!/usr/bin/env bash

DIR=`dirname $0`

if [ -f /home/vagrant/.ssh/known_hosts ] && grep -Fq '10.99.34.5' /home/vagrant/.ssh/known_hosts ; then
    echo -e "\nTrusted hosts already installed."
else
    echo -e "\nInstalling trusted hosts."
    cat ${DIR}/hosts.txt >> /home/vagrant/.ssh/known_hosts
fi
