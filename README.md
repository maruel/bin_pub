# Marc-Antoine Ruel's utils

Use at your own risk but feel free to take what you find useful.

See [LICENSE](https://github.com/maruel/bin_pub/blob/master/LICENSE) for
licensing information.


## Tmux

My .tmux.conf includes a call to print_load, which prints the 1s CPU load every
5 seconds, including MB/s and IO/s for disks, and on linux additionally network
KB/s.

How it looks on Ubuntu:

![Ubuntu](/screenshots/ubuntu.png)

How it looks on macOS:

![macOS](/screenshots/osx.png)


## Ubuntu

For a public workstation without a private *bin*:

```
mkdir ~/bin
git clone --recursive https://github.com/maruel/bin_pub ~/bin/bin_pub
~/bin/bin_pub/setup/apt_get.sh
~/bin/bin_pub/setup/update_config.py
~/bin/bin_pub/setup/install_golang.py
```

### CapsLock -> Escape

Edit `/usr/share/X11/xkb/symbols/pc`, add:

    key <CAPS> { [ Escape ] };

and comment out:

    // key <CAPS> { [ Caps_Lock ] };
    // modifier_map Lock { Caps_Lock };


## macOS

See [mac/README.md](mac/README.md)


## FAQ

You should use this directory structure:

- *~/bin* containing all your private scripts, configuration files and
  whatnot.  It can be a git repository but it doesn't needs to be. If it is a
  git checkout, you can use git submodule to fetch bin_pub automatically.
- *~/bin/bin_pub* references to this repository, containing public scripts and
  configuration files.

Then you can just *git pull computer:bin* from all your workstations to keep
your workstations all in sync, and using git submodule to fetch public
repositories like git-prompt. You can also create a *bin* private repository on
github.


## Initial setup steps

If you want to use this, or a similar flow, here's the recipe:

```bash
git init ~/bin
cd ~/bin
git submodule add git://github.com/maruel/bin_pub.git bin_pub
cd bin_pub
git submodule init
git submodule update
cd ..
mkdir configs
echo "This is private" > configs/my_private_script
git commit -a -m "Initial commit into my private repo"
```


## Security

- Edit `/etc/login.defs` so `UMASK 027`
- Disable password based ssh login with: `sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' $ROOT_PATH/etc/ssh/sshd_config`


## Upgrading debian

It's always a similar dance for upgrading debian derived distros. What I always
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

## pip

To install as user on linux

```
wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py --user
pip install --user virtualenv
```
