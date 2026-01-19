#!/bin/sh

##
#  Starting from scratch with a new installation procedure
##


# Ensure that script is running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please run with sudo or as root user."
  exit 1
fi

# Package repositories
echo "Adding necessary package repositories (EPEL, CRB) and updating system..."
dnf install -y epel-release
/usr/bin/crb enable # Not sure if actually needed # TODO: review without
dnf update -y

# Installing Xorg/X11 and XRDP
echo "Installing Xorg/X11 and XRDP packages.."
dnf install -y \
  xrdp \
  xorgxrdp \
  xorg-x11-server-Xorg

echo "Configuring XRDP.."
#TODO: Use pwd and omit path if needed
chmod +x ./linux-vm-tools/common/configure_xrdp.sh
./linux-vm-tools/common/configure_xrdp.sh
# Enable and start XRDP service
echo "Enabling and starting XRDP service.."
#TODO: s/config
systemctl enable --now xrdp xrdp-sesman
echo "Backend configured. If you have a working window manager, you should be able to connect after the next step."
echo "Action required once: Run 'Set-VM -VMName <the_name_of_this_VM> -EnhancedSessionTransportType HvSocket' in an elevated Powershell promt while this VM is turned off"
echo "Then start the VM and connect using Enhanced Session Mode."
