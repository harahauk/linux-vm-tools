#!/bin/sh

##
#  If no Window Manager is installed, install i3 as a minimal WM
##

#TODO: Determine user
echo "Deleting any existing .Xauthority and .serverauth* files in the user's home-directory to avoid possible conflicts..."
rm /home/"$SUDO_USER"/.Xauthority /home/"$SUDO_USER"/.serveraut*
#TODO: Determine package manager and install i3
echo "Installing i3 window manager..."
dnf install -y i3 i3status
echo "exec i3" > /home/"$SUDO_USER"/.Xclients
chmod a+x /home/"$SUDO_USER"/.Xclients
cp /etc/X11/xinit/xinitrc /home/"$SUDO_USER"/.xinitrc
ln -s /home/"$SUDO_USER"/.xinitrc /home/"$SUDO_USER"/.xsession
systemctl set-default graphical.target
echo "i3 window manager installed and configured. You should be able to connect using XRDP once X is started provided you've ran the mandatory Powershell-command once."
echo "Run 'startx' to start the X server and i3 window manager."
