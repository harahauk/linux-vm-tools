#!/bin/sh

##
#  Enables sound over XRDP (Hyper-V enhanced-session) for pipewire-based systems
#  Builds and installs https://github.com/neutrinolabs/pipewire-module-xrdp
#  @author Harald Hauknes <harald@hauknes.org>
##

#TODO: If ran as root, check the SUDO_USER variable to run some commands de-escalated
if [ "$(id -u)" -eq 0 ]; then
  echo "This script is designed to be executed as a sudo-enabled user and asks for escalation when neccesary."
  echo "You ran it as root. Please run with your normal user or comment out the first part of this script (this code)."
  echo "Will now exit.."
  exit 1
fi

echo "Installing pipewire-utils for Xorg and CLI"
sudo dnf install -y pipewire-module-x11 pipewire-pulseaudio pipewire-utils
echo "Installing dependencies for building 'pipewire-module-xrdp'"
sudo dnf install -y git gcc make autoconf libtool automake pkgconfig
echo "Installing libraries sourced under package building"
sudo dnf install -y pipewire-devel
echo "Getting the module from Github"
git clone https://github.com/neutrinolabs/pipewire-module-xrdp /tmp/pipewire-module-xrdp
cd /tmp/pipewire-module-xrdp
# TODO: Get specific working tag or branch, now default to 'devel'
echo "Attempting to build module"
./bootstrap
./configure
make
echo "Installing module"
sudo make install
/usr/local/libexec/pipewire-module-xrdp/load_pw_modules.sh
echo "Sound should now work (with some grumpy errors in this terminal you can ignore).."
# echo "Make sure you add 'exec --no-startup-id /usr/local/libexec/pipewire-module-xrdp/load_pw_modules.sh' to your '~/.config/i3/config'"
echo "Adding 'exec --no-startup-id /usr/local/libexec/pipewire-module-xrdp/load_pw_modules.sh' to your i3-config if it exists. If you are using some other wm you might need to run it manually or add it to the proper config."
awk 'BEGIN{b="\n# Load modules for pipewire-module-xrdp (Enable sound)\nexec --no-startup-id /usr/local/libexec/pipewire-module-xrdp/load_pw_modules.sh\n"} /pipewire-module-xrdp\/load_pw_modules\.sh/{f=1} {l[NR]=$0} END{for(i=1;i<=NR;i++){print l[i]; if(!f&&!d&&l[i]~/^font/){printf "%s",b; d=1}}}' ~/.config/i3/config > ~/.config/i3/config.tmp && mv ~/.config/i3/config.tmp ~/.config/i3/config

