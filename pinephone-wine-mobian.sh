#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt install figlet
figlet Wine on Pinephone Installer

echo "This script will install wine on your Pinephone. It should take less than 2 hours depending on you internet connection speed."
echo"You need to input your root password. This is used to set the same password for the chroot root account."
read -p "Password: " password
echo "First we need to install some dependencies."

apt install -y schroot deboostrap

echo "Creating folders"
mkdir /srv/chroot
mkdir /srv/chroot/debian-armhf


echo "Running debootstrap"
sudo debootstrap --arch armhf --foreign buster /srv/chroot/debian-armhf http://debian.xtdv.net/debian

echo "Entering chroot jail"
sudo chroot "/srv/chroot/debian-armhf" /debootstrap/debootstrap --second-stage

echo "Creating configuration files"
cp debian-armhf.conf /etc/schroot/chroot.d
cp nssdatabases /etc/schroot/desktop/nssdatabases
cp stateoverride /srv/chroot/debian-armhf/var/lib/dpkg/statoverride
echo -e 'export LANGUAGE="C" /n export LC_ALL="C" /n export DISPLAY=:0' | tee -a ~/.bashrc >/dev/null

echo "Setting password for chroot."
echo "root:$password" | chpasswd