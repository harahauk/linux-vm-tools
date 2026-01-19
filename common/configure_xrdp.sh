#!/bin/sh

##
#  Configure XRDP for Hyper-V Enhanced Session mode
#  This procedure is the same on all linux-distribution supported by this project.
#  This script is sourced from the installation scripts for each distribution.
##

#TODO: If file not found abort and notify user
# Configure the installed XRDP ini files.
# use vsock transport.
sed -i_orig -e 's/port=3389/port=vsock:\/\/-1:3389/g' /etc/xrdp/xrdp.ini
# Use RDP-security.
sed -i_orig -e 's/security_layer=negotiate/security_layer=rdp/g' /etc/xrdp/xrdp.ini
# Remove encryption validation. #TODO: Play around with tighter security
sed -i_orig -e 's/crypt_level=high/crypt_level=none/g' /etc/xrdp/xrdp.ini
# Disable bitmap compression since its local its much faster
sed -i_orig -e 's/bitmap_compression=true/bitmap_compression=false/g' /etc/xrdp/xrdp.ini