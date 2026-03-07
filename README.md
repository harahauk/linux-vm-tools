# Enhanced Session Mode for Linux
Scripts to configure `Enhanced session`-mode for guest virtual machines running `Linux` under `Hyper-V`.

## History
This repository was originally maintained by **Microsoft** and that original code is archived [here](https://github.com/microsoft/linux-vm-tools).  
Also see the original [README.md](./README.original.md) from the original repository.  
It seems that *Microsoft* is moving away from maintaining these scripts in favor of *premade VMs* accessible through Hyper-VM manager and presumable other Azure Dev Tools.

For a time the code was steadily maintained by [Hinara](https://github.com/Hinara) in [this Github-repo](https://github.com/Hinara/linux-vm-tools).  
I am not affiliated or in communication with this author, but it seems to me that maintenance has halted.  
This installment of the repository endevours to keep `Enhanced Session` working for as many major Linux-distributions as I can. as the pre-made VMs maintained by Microsoft does not fit my requirements.  
ddddI will try to credit any solutions sourced from other authors.


## Usage
- Check out this code to the guest operating system
- Determine which subfolder corresponds to your operating system and run the `linux-vm-tools/os-family/version/install.sh`-script.
- If needed run the installation-script for a window-manager and/or the script to enable sound 
- Turn off the VM and enable `HVSocket` as the communication protocol between your host and the guest (by running the command in the example below in an elevated Powershell-promt).


### Example for enabling Enchanced-session on AlmaLinux 9
Terminal inside your guest VM:
```bash
git clone https://github.com/harahauk/linux-vm-tools
chmod +x linux-vm-tools/rhel/9/install.sh
sudo linux-vm-tools/rhel/9/install.sh
# Optional if you already have a supported Window Manager
chmod +x linux-vm-tools/common/install_i3.sh
sudo linux-vm-tools/common/install_i3.sh
# Optional utility-script to enable sound over XRDP using pipewire
./linux-vm-tools/common/enable_sound_xorg_pipewire.sh
sudo shutdown -h now
```


### Step to complete for all Linux-distributions 
- The Guest-machine must be powered off.
- Start Elevated Powershell-promt on your host:
```powershell
Set-VM -EnhancedSessionTransportType HvSocket -VMName <your_guests_vm_name>
```
- Then boot the guest and press the Enhanced-session button if does not already default to it.


## Working distributions
| Family    | Version | Window Manager  |
| --------- | ------- | --------------- |
| AlmaLinux |       9 |          X11/i3 |
| Fedora    |      43 |         X11/i3* |

\*) an denoted asterix means the operating system must be re-configured to using `Xorg` either via installing the `base`-version of the OS and then running the scripts provided here or by configuring `Xorg` in an exisisting `Wayland`-based distribution.  


## Non-working distributions
As a rule of thumb, no `Wayland`-distribution is supported
| Family    | Version | Window Manager  |
| --------- | ------- | --------------- |
| Fedora    |      43 | Wayland / Gnome |
| AlmaLinux |      10 | Wayland / Gnome |


## Difficulties and Considerations

### General Security
The modifications made to the guests is suspected to carry some serious security risks.  I do not condone or propose exposing any guests changed by these scripts to public-facing network-segments or to use any guest modified by these scripts in a production environment.  

### Wayland (Fedora 43, AlmaLinux 10, etc..)
Wayland is undoubtably the future in favor of the seriously dated X11/Xorg-server.  
However getting enhanced-session to play nice with Wayland is proving a challenge.  
Since most desktop flavors of modern Linux-distributions are being shipped without `X11` in favor of `Wayland` some serious re-design of this solution is needed for a working and "supported" enhanced session.  

xrdp still seems to be working, but the session crashes after login.
For now I have no solution that is not ugly as sin, will look into [WayVNC] and similar implementations.  

