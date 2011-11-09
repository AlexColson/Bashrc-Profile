#!/bin/bash

echo "Installing files ..."

# save old files
mv -f ~/.bashrc ~/.bashrc.save
mv -f ~/.bash_profile ~/.bash_profile.save
mv -f ~/.profile ~/.profile.save

# install new files
cp bash_profile ~/.bash_profile
pushd $HOME 1>/dev/null
ln -s .bash_profile .bashrc
ln -s .bash_profile .profile
pushd +1 1>/dev/null

# install supporting directory
cp -Rf bashrc.d ~/.bashrc.d

echo "Install done. Don't forget to logoff/login."
