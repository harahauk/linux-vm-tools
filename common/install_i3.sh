#!/bin/sh

##
#  If no Window Manager is installed, install i3 as a minimal WM
##

#TODO: Determine user
echo "Deleting any existing .Xauthority and .serverauth* files in the user's home-directory to avoid possible conflicts..."
sudo -u "$SUDO_USER" rm ~/.Xauthority ~/.serveraut*
#TODO: Determine package manager and install i3
echo "Installing i3 window manager..."
dnf install -y i3 i3status
echo "exec i3" > /home/"$SUDO_USER"/.Xclients
chmod a+x /home/"$SUDO_USER"/.Xclients
cp /etc/X11/xinit/xinitrc /home/"$SUDO_USER"/.xinitrc
ln -s /home/"$SUDO_USER"/.xinitrc /home/"$SUDO_USER"/.xsession