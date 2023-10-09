# Linux/Ubuntu/Debian


## Default keyboard layout

While Ubuntu does it properly during install, Debian may not always. It's
important to set the default keyboard layout when using full disk encryption
(FDE).

```
sudo dpkg-reconfigure keyboard-configuration
sudo update-initramfs -u
```


## CapsLock -> Escape

Nowadays, it's in the settings both on Gnome and KDE.


## Security

- Edit `/etc/login.defs` so `UMASK 027`
- Disable password based ssh login with:
  ```
  echo "PasswordAuthentication no" | sudo tee /etc/ssh/sshd_config.d/no_password.conf
  ```


## Upgrading Debian

It's always a similar dance for upgrading Debian derived distros. What I always
forget is to do it from a tmux session. Often we get prompts during the upgrade.

```
tmux
sudo apt update
sudo apt dist-upgrade
# Raspbian only:
sudo rpi-update

sudo vim /etc/apt/sources.list
# Change current to next one

sudo apt update
sudo apt dist-upgrade
sudo apt autoclean
sudo reboot
```

In practice it's been hit-or-miss, especially over ssh.


## Host-VM network access when VM uses macvtap

If a VM under KVM uses macvtap networking, the host cannot access the VM over
the network. The trick is to create an isolated network.

### Defining the isolated network

```
cat > isolated.xml <<EOF
<network>
  <name>isolated</name>
  <ip address="192.168.254.1" netmask="255.255.255.0">
    <dhcp>
      <range start="192.168.254.2" end="192.168.254.254"/>
    </dhcp>
  </ip>
</network>
EOF

virsh net-define isolated.xml
rm isolated.xml
virsh net-autostart isolated
virsh net-start isolated
```

### Updating the VM network

```
virsh edit <name_of_guest>
```

Add under `<devices>` close to the network:

```
<interface type="network">
  <source network='isolated'/>
  <model type='virtio'/>
</interface>
```

Restart the guest.

Run `ip addr show` to get the isolated IP. Host will be accessible as
`192.168.254.1.`.
