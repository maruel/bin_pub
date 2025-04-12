# Marc-Antoine Ruel's utils

Use at your own risk but feel free to take what you find useful.

I recommend either taking inspiration from it or forking and mutating as
desired.

See [LICENSE](LICENSE) for licensing information.


## Checkout structure

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


### Creating your own

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


### Public only

For a public workstation without a private *bin*:

```
mkdir ~/bin
git clone --recursive https://github.com/maruel/bin_pub ~/bin/bin_pub
~/bin/bin_pub/setup/apt_get.sh
~/bin/bin_pub/setup/update_config.py
~/bin/bin_pub/setup/install_golang.py
```


## Linux/Ubuntu/Debian

See [linux/README.md](linux/README.md)


## macOS

See [mac/README.md](mac/README.md)


## Windows

See [win/README.md](win/README.md)


## Tmux

My .tmux.conf includes a call to [print_stats](print_stats), which prints the 1s CPU load every 5 seconds,
including MB/s and IO/s for disks, and on linux additionally network KB/s.

How it looks on Ubuntu:

![Ubuntu](/screenshots/ubuntu.png)

How it looks on macOS:

![macOS](/screenshots/osx.png)

On macOS, you need to run `xcode-select --install` which takes half an hour to
complete. Thanks Apple.


## pip

To install as user on POSIX, then activate virtualenv:

```
wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py --user && rm get-pip.py
PATH=$PATH:$HOME/.local/bin
pip3 install --user virtualenv
# Seems like a bootstrapping problem:
pip3 install --user --break-system-packages virtualenvwrapper
mkvirtualenv .
```

PATH will be fixed on next login.


## git

### Large repos

If working in a large git repository (Chromium's src.git, kernel.git, etc), run
the following to make it bearable:

```
git config --local --add bash.showDirtyState false
git config --local --add bash.showUntrackedFiles false
```

### Hard resetting author

This resets the author without changing the dates.

```
git -c rebase.instructionFormat='%s%nexec GIT_COMMITTER_DATE="%cD" GIT_AUTHOR_DATE="%aD" git commit --amend --no-edit --reset-author' rebase -f --root
```

## nvim

See [Neovim.md](Neovim.md) for more information.
