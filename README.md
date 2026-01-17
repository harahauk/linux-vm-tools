# Enhanced Session Mode for Linux
Scripts to configure enhanced-session mode for Hyper-V guests.

## History
This repository was originally maintained by Microsoft and the original code is archived [here].
Also see the original [README.md] by the original implementers.
As per my knowledge it was then picked up and semi-steadily maintained by [Author] in [this Github-repo].
I endevour to keep this code working for as many major distributions as I can

## Usage
Check out this code to the guest, change directory to the relevant folder for your distrubution and run the install.sh-script. Turn off the VM and enable HVSocket as the communication protocol between your host and the guest by running <command> in an elevated Powershell-promt.

Example
```bash
git clone https://github.com/harahauk/linux-vm-tools
cd linux-vm-tools/rhel
sudo ./install.sh
sudo shutdown -h now
```
```powershell

```

## Working distributions
| Family | Version | Window Manager |
| ------ | ------- | -------------- |


## Non-working distributions
| Family | Version | Window Manager  |
| ------ | ------- | --------------- |
| Fedora |      43 | Wayland / Gnome |


## Difficulties and considerations

### Fedora
Since Fedora '43' is being shipped without X11 in favor of Wayland some serious re-design of this solution is needed for a working enchanced session. xrdp still seems to be working, but xvnc is proving harder to convince.
For now I have no solution, will look into [WayVNC] and similar implementations.

