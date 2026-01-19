# Enhanced Session Mode for Linux
Scripts to configure **enhanced-session** mode for **Hyper-V** guests.

## History
This repository was originally maintained by *Microsoft* and the original code is archived [here](https://github.com/microsoft/linux-vm-tools).  
Also see the original [README.md](./README.original.md) by the original implementers.  
It seems that *Microsoft* is moving away from maintaining these scripts in favor of *premade VMs* accesible through Hyper-VM manager and presumable other Azure Dev Tools.
As per my knowledge it was then picked up and semi-steadily maintained by [Hinara](https://github.com/Hinara) in [this Github-repo](https://github.com/Hinara/linux-vm-tools).  
I am not affiliated or in communication with this author, but it seems to me that maintenance has since gone stale.  
I endevour to keep this code working for as many major distributions as I can as the pre-made VMs maintained by Microsoft does not fit my requirements. I will try to credit any solutions sourced from other authors.


## Usage
Check out this code to the guest, change directory to the relevant folder for your distrubution and run the `install.sh`-script. Turn off the VM and enable HVSocket as the communication protocol between your host and the guest by running the command in the example below in an elevated Powershell-promt.

### Example
Terminal inside your guest VM:
```bash
git clone https://github.com/harahauk/linux-vm-tools
chmod +x linux-vm-tools/rhel/9/install.sh
cd linux-vm-tools/rhel/9
sudo ./install.sh
sudo shutdown -h now
```
Elevated Powershell-promt on your host:
```powershell
Set-VM -VMName <your_guests_vm_name> -EnhancedSessionTransportType HvSocket
```
Then boot the guest and press the Enhanced-session button if does not already default to it.


## Working distributions
| Family    | Version | Window Manager |
| --------- | ------- | -------------- |
| AlmaLinux |       9 |         X11/i3 |


## Non-working distributions
| Family    | Version | Window Manager  |
| --------- | ------- | --------------- |
| Fedora    |      43 | Wayland / Gnome |
| AlmaLinux |      10 | Wayland / Gnome |


## Difficulties and considerations

### General Security
The modifications made to the guests carries serious security risks. I do not condone exposing any guests changed by these scripts to public network-segments. 

### Wayland (Fedora 43, AlmaLinux 10)
Wayland is udoubtably the future in favor of the seriously dated X11/Xorg-server. However getting enhanced-session to play nice with Wayland is proving a challenge.  
Since Fedora `43` is being shipped without `X11` in favor of `Wayland` some serious re-design of this solution is needed for a working enchanced session. xrdp still seems to be working, but xvnc is proving harder to convince.
For now I have no solution that is not ugly as sin, will look into [WayVNC] and similar implementations.  
Since Fedora 42 is EOL in about three months no effort will be made to support Fedora on X11. AlmaLinux 9 is still supported for 6 years.

