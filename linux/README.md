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


## Windows on KVM

- Get Windows 11 ISO from
  https://www.microsoft.com/software-download/windows11
- Get virtio-win from
  https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/
- VM configuration:
  - Load Windows ISO as first CD-ROM.
  - Load virtio ISO as second CD-ROM.
  - Install TPM v2.0 Type Emulated CRB / version 2.0 before booting.
  - Disable network during installation will simplify your life w.r.t. creating a
    local account.
- After installation, remove the two CD-ROM and reenable network, then run Windows
  Update 2~3 times.


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


## Build cpython

e.g. if contributing a change to Home Assistant...

```
sudo apt-get install build-essential gdb lcov pkg-config \
    libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
    libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
    lzma lzma-dev tk-dev uuid-dev zlib1g-dev
git clone https://github.com/python/cpython
cd cpython
git checkout $(git tag -l --sort=v:refname | grep -v '0[a-z]\+[0-9]\+$' | tail -1)
./configure --enable-optimizations --with-lto
make -s -j
ln -s python python3
cd ..
mkdir venv
cd venv
../cpython/python3 -m venv .
source bin/activate
python3 --version
```

More info at https://devguide.python.org/getting-started/setup-building/

## Resize LVM encrypted partition.

```
# To fix the GPT partition and extend it. It uses cryptsetup resize underneat.
gparted
# To resize the LVM physical volume.
sudo pvresize /dev/mapper/vda4_crypt
# To resize the LVM logical volume.
sudo lvresize -l +100%FREE /dev/mapper/vgubuntu-root
# To resize the ext4 file system.
sudo resize2fs /dev/mapper/vgubuntu-root
```
