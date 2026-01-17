#!/bin/bash

# This script is for RHEL9-based distros (AlmaLinux, RockyLinux, OracleLinux) to download and install XRDP+XORGXRDP.
# It aims to enable Enhanced Session mode for Hyper-V.
# Major thanks to: https://www.nakivo.com/blog/install-ubuntu-20-04-on-hyper-v-with-enhanced-session
# and to Hinara/linux-vm-tools on Github for maintaining the now archived Microsoft-[repo](https://github.com/microsoft/linux-vm-tools)
#

###############################################################################
# NOTE: This is a full rewrite for RHEL-based OS's, but follows the same
#       structure as the script for Ubuntu. Most commands have been substituted
#       or renamed in place.
###############################################################################

if [ "$(id -u)" -ne 0 ]; then
    echo 'This script must be run with root privileges' >&2
    exit 1
fi

# Enable the EPEL-repository
dnf update -y && dnf install -y epel-release

###############################################################################
# XRDP
#

# Install the XRDP-service and make sure it's not running
dnf install -y xrdp
systemctl stop xrdp
systemctl stop xrdp-sesman

# Configure the installed XRDP ini files.
# use vsock transport.
sed -i_orig -e 's/port=3389/port=vsock:\/\/-1:3389/g' /etc/xrdp/xrdp.ini
# Use RDP-security.
sed -i_orig -e 's/security_layer=negotiate/security_layer=rdp/g' /etc/xrdp/xrdp.ini
# Remove encryption validation.
sed -i_orig -e 's/crypt_level=high/crypt_level=none/g' /etc/xrdp/xrdp.ini
# Disable bitmap compression since its local its much faster
sed -i_orig -e 's/bitmap_compression=true/bitmap_compression=false/g' /etc/xrdp/xrdp.ini

# Add script to setup the RHEL-session properly
# TODO: Determine the system's session manager and adjust accordingly
#if [ ! -e /usr/libexec/xrdp/start-rhel.sh ]; then
#cat >> /usr/libexec/xrdp/start-rhel.sh << EOF
if [ ! -e /usr/libexec/xrdp/start-rhel-bash.sh ]; then
cat >> /usr/libexec/xrdp/start-rhel-bash.sh << EOF
#!/bin/sh
#export XDG_CURRENT_DESKTOP="i3" # In Ubuntu this was still "ubuntu:GNOME" even running i3
#export GNOME_SHELL_SESSION_MODE="ubuntu"
# FIXME: The latter variables are not confirmed relevant and are used in testing
# TODO: Removed this in 2026
#declare -x DESKTOP_SESSION="i3"
#declare -x GDMSESSION="i3"
#declare -x XDG_CURRENT_DESKTOP="i3"
#declare -x XDG_SESSION_DESKTOP="i3"
exec /usr/libexec/xrdp/startwm.sh
EOF
chmod a+x /usr/libexec/xrdp/start-rhel.sh
fi
# Include this script in sesman.ini
sed -i_orig -e 's/startwm/start-rhel/g' /etc/xrdp/sesman.ini

# rename the redirected drives to 'shared-drives'
sed -i -e 's/FuseMountName=thinclient_drives/FuseMountName=shared-drives/g' /etc/xrdp/sesman.ini

# Changed the allowed_users or create the file if nonexisting
if [ ! -e /etc/X11/Xwrapper.config ]; then
echo allowed_users=anybody >> /etc/X11/Xwrapper.config
fi
sed -i_orig -e 's/allowed_users=console/allowed_users=anybody/g' /etc/X11/Xwrapper.config

# Blacklist the vmw module
if [ ! -e /etc/modprobe.d/blacklist-vmw_vsock_vmci_transport.conf ]; then
  echo "blacklist vmw_vsock_vmci_transport" > /etc/modprobe.d/blacklist-vmw_vsock_vmci_transport.conf
fi

#Ensure hv_sock gets loaded
if [ ! -e /etc/modules-load.d/hv_sock.conf ]; then
  echo "hv_sock" > /etc/modules-load.d/hv_sock.conf
fi

# Configure the policy xrdp session
cat > /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla <<EOF
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes
EOF

# Reconfigure the service
systemctl daemon-reload
systemctl enable xrdp
systemctl start xrdp

#
# End XRDP
###############################################################################

echo "Install is complete."
