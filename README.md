Marc-Antoine Ruel's utils
=========================

Use at your own risk.

See [LICENSE](https://github.com/maruel/bin_pub/blob/master/LICENSE) for
licensing information.


Tmux Screenshots
-----------

How it looks on Ubuntu:

![Ubuntu](/screenshots/ubuntu.png)

How it looks on OSX:

![OSX](/screenshots/osx.png)


FAQ
---

You should use this directory structure:

-   *~/bin* containing all your private scripts, configuration files and
    whatnot.  It can be a git repository but it doesn't needs to be. If it is a
    git checkout, you can use git submodule to fetch bin_pub automatically.
-   *~/bin/bin_pub* references to this repository, containing public scripts and
    configuration files.

Then you can just *git pull computer:bin* from all your workstations to keep
your workstations all in sync, and using git submodule to fetch public
repositories like git-prompt.


Setup steps
-----------

git prior version 1.7.4 must call git submodule manually:

```bash
cd ~
git init bin
cd bin
git submodule add git://github.com/maruel/bin_pub.git bin_pub
cd bin_pub
git submodule init
git submodule update
cd ..
mkdir configs
echo "This is private" > configs/my_private_script
git commit -a -m "Initial commit into my private repo"
```


Enable ssh login via public key authentication with encrypted home directory with ecryptfs
------------------------------------------------------------------------------------------

If you don't want to be owned, you probably already set
*"PasswordAuthentication no"* in your */etc/ssh/sshd_config*. But then ecryptfs
encrypted home directory can't reach your *.ssh/authorized_keys* unless you were
already logged in, which is annoying. Here's how to enable it back.

Some background first so you understand what you are doing: when a user has an
ecryptfs'ed home directory, he has in fact 3 personal directories:

- */home/$USER*: The real directory, which is **not** accessible as soon as the
  ecrypted directory is mounted. This directory should always be mode 500, e.g.
  read-only by its user only.
- */home/$USER*: The virtual decrypted directory, which is mapped automatically
  on X login or with the command *ecryptfs-mount-private* in Ubuntu.
- */home/.ecryptfs/$USER*: The datastore for the virtual */home/$USER*
  directory.  The content is located at */home/.ecryptfs/$USER/.Private*. This
  directory is accessible by the user all the time, unlike the two directories
  above. We'll use this as a gateway to store files that must be accessible at
  all times.  Each files in the virtual home directory are stored encrypted with
  */home/.ecryptfs/maruel/.ecryptfs/wrapped-passphrase* and the filenames are
  encrypted too.


### Goals

1. Create a *.ssh/authorized_keys* that is always accessible. Then make sure
   that */home/$USER/.ssh/authorized_keys* points to it, independent of the fact
   your encrypted home directory is mounted or not. We'll use symlinks for that.
2. Create a *.profile* and in your real */home/$USER* directory that
   automatically decrypt your virtual home directory on first login through ssh
   and umount on your last login. Note that keeping a screen session active or
   an X session active will keep your virtual home directory mounted.

### Commands to run blindly on your workstation

You trust me, right? Go ahead:

1. Restart your workstation.
2. At the login screen, press Ctrl-Alt-F1 to login in text mode.
3. Login with your account.

```bash
sudo apt-get install ecryptfs-utils

# Preparation work: make .ssh/authorized_keys always accessible.
mkdir /home/.ecryptfs/$USER/.ssh
mv .ssh/authorized_keys /home/.ecryptfs/$USER/.ssh/authorized_keys
chmod 400 /home/.ecryptfs/$USER/.ssh/authorized_keys
chmod 500 /home/.ecryptfs/$USER/.ssh
ln -s /home/.ecryptfs/$USER/.ssh/authorized_keys $HOME/.ssh/authorized_keys

# Unmount the encrypted home directory to see the real unencrypted home
# directory.
ecryptfs-umount-private
# Jump to the real /home/$USER. It's mostly empty except with 2 symlinks. Add
# the necessary .ssh/ file.
cd $HOME
chmod 700 .
mkdir .ssh
ln -s /home/.ecryptfs/$USER/.ssh/authorized_keys $HOME/.ssh/authorized_keys
chmod 500 .ssh

# Create the auto-mount script so you can easily mount your encrypted home
# directory via ssh.
cat << EOF > .profile
/usr/bin/ecryptfs-mount-private
cd
source ~/.bashrc
EOF
chmod 400 .profile

# Important: secure the real /home/$USER back.
chmod 500 .
# Reboot and try to ssh with public key authentication without logging in first
# via X.
```

### Notes

- ecryptfs has side channel leakage, the filenames do not have independent IV,
  so you easily can deduce the approximate filename length. Oh well.
- The commands above assume
  - Ubuntu
  - bash
  - Your home directory lives in /home/$USER.
