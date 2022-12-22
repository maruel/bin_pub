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
