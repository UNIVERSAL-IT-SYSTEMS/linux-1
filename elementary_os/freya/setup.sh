#!/bin/bash

set -o errexit   # exit on error

# install apps I want
sudo add-apt-repository ppa:webupd8team/java
sudo add-apt-repository ppa:kirillshkrogalev/ffmpeg-next
sudo add-apt-repository ppa:obsproject/obs-studio
sudo add-apt-repository ppa:bartbes/love-stable
sudo apt-get update
sudo apt-get install keepass2 git ncdu htop redshift virtualbox oracle-java8-installer steam ffmpeg obs-studio love screen nano wget curl tree transmission libreoffice gimp gnome-system-monitor wondershaper rar unrar zip unzip bsdgames -y # should already be there: screen, nano, wget, curl, unzip

# Dropbox is special
git clone https://github.com/zant95/elementary-dropbox/
cd elementary-dropbox
bash ./install.sh #TODO figure out if this needs to be launched in a screen
cd ..

# LuaRocks is also special
#TODO write commands to install it here! make sure required dependencies are here! (zip and unzip, build essentials, liblua and lua and all that stuff! openssl and libopenssl I think are required for OpenResty only, but idk for sure, test in a VM!)
VER=2.3.0
sudo apt-get install lua5.1 liblua5.1-0-dev
wget https://keplerproject.github.io/luarocks/releases/luarocks-$VER.tar.gz
tar xvf luarocks-$VER.tar.gz
cd luarocks-$VER
./configure
make build
sudo make install
sudo luarocks install moonscript
sudo luarocks install busted
sudo luarocks install ldoc
cd ..

# Google Chrome! :D
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get -f install # apparently this will fix shit ? idk
sudo dpkg -i google-chrome*.deb

# Atom!
wget https://github.com/atom/atom/releases/download/v1.9.2/atom-amd64.deb
sudo dpkg -i atom-amd64.deb

# Slack!
wget https://downloads.slack-edge.com/linux_releases/slack-desktop-2.1.0-amd64.deb
sudo dpkg -i slack-desktop-2.1.0-amd64.deb

# uninstall apps I don't want
sudo apt-get purge midori-granite -y

# make sure everything is upgraded, and autoremove unused packages
sudo apt-get upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# configure git
git config --global user.name "Paul Liverman III"
git config --global user.email "paul.liverman.iii@gmail.com"
git config --global push.default simple

# set up SSH key for GitHub
ssh-keygen -t rsa -b 4096 -C "paul.liverman.iii@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# stop Bluetooth from starting on boot
# ref: http://elementaryos.stackexchange.com/questions/711/turn-off-bluetooth-by-default-on-start-up
echo "Opening /etc/rc.local"
echo "Put 'rfkill block bluetooth' before the exit command!"
read -p " Press [Enter] to continue"
sudo nano /etc/rc.local
