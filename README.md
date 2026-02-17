# Enhanced Session Mode for Linux
Scripts to configure **enhanced-session** mode for **Hyper-V** guests.

## History
This repository was originally maintained by **Microsoft** and that original code is archived [here](https://github.com/microsoft/linux-vm-tools).  
Also see the original [README.md](./README.original.md) by the implementers.  
It seems that *Microsoft* is moving away from maintaining these scripts in favor of *premade VMs* accessible through Hyper-VM manager and presumable other Azure Dev Tools.
I assume  the code was then picked up and steadily maintained by [Hinara](https://github.com/Hinara) in [this Github-repo](https://github.com/Hinara/linux-vm-tools).  
I am not affiliated or in communication with this author, but it seems to me that maintenance has since gone stale?  
I endevour to keep this code working for as many major distributions as I can as the pre-made VMs maintained by Microsoft does not fit my requirements.  
I will try to credit any solutions sourced from other authors.


## Usage
Check out this code to the guest, change directory to the relevant folder for your distrubution and run the `install.sh`-script. Turn off the VM and enable HVSocket as the communication protocol between your host and the guest by running the Powershell-command in the example below in an elevated Powershell-promt.


### Example
Terminal inside your guest VM:
```bash
git clone https://github.com/harahauk/linux-vm-tools
chmod +x linux-vm-tools/rhel/9/install.sh
sudo linux-vm-tools/rhel/9/install.sh
# Optional if you already have a supported Window Manager
chmod +x linux-vm-tools/common/install_i3.sh
sudo linux-vm-tools/common/install_i3.sh
sudo shutdown -h now
```
Elevated Powershell-promt on your host:
```powershell
Set-VM -VMName <your_guests_vm_name> -EnhancedSessionTransportType HvSocket
```
Then boot the guest and press the Enhanced-session button if does not already default to it.


## Working distributions
| Family    | Version | Window Manager  |
| --------- | ------- | --------------- |
| AlmaLinux |       9 |          X11/i3 |
| Fedora    |      43 |         X11/i3* |

\*) an denoted asterix means the operating system must be re-configured to using `Xorg` either via installing the `base`-version of the OS and then running the scripts provided here or by configuring `Xorg` in an exisitng `Wayland`-based distro.  


## Non-working distributions
In general, no `Wayland`-distro is supported
| Family    | Version | Window Manager  |
| --------- | ------- | --------------- |
| Fedora    |      43 | Wayland / Gnome |
| AlmaLinux |      10 | Wayland / Gnome |


## Difficulties and considerations

### General Security
The modifications made to the guests carries serious security risks. I do not condone exposing any guests changed by these scripts to public network-segments. 

### Wayland (Fedora 43, AlmaLinux 10)
Wayland is undoubtably the future in favor of the seriously dated X11/Xorg-server. However getting enhanced-session to play nice with Wayland is proving a challenge.  
Since more and more Desktop flavors of modern Linux-distribution are is being shipped without `X11` in favor of `Wayland` some serious re-design of this solution is needed for a working enchanced session. xrdp still seems to be working, but the session crashes after login.

For now I have no solution that is not ugly as sin, will look into [WayVNC] and similar implementations.  

