#!/bin/sh

##
#  Enables sound over xRDP (Hyper-V enhanced-session) for pipewire-based systems
#  Builds and installs https://github.com/neutrinolabs/pipewire-module-xrdp
#  @author Harald Hauknes <harald@hauknes.org>
##

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
echo "Sound should now work (with some grumpy errors in this terminal you can ignore)"
echo "Make sure you add 'exec --no-startup-id /usr/local/libexec/pipewire-module-xrdp/load_pw_modules.sh' to your '~/.config/i3/config'"
