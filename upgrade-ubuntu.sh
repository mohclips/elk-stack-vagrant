#!/bin/bash
echo "++ OS Upgrade"
sudo apt-get update
# this fixes the naff grub pc interactive mode we dont want.
export DEBIAN_FRONTEND=noninteractive 
# requires sudo -E to import ENV VARS
sudo -E apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

