Marc-Antoine Ruel's utils
=========================

Use at your own risk.

See LICENSE for licensing information.


FAQ
===

You should use this directory structure:

-   ~/bin containing all your private scripts, configuration files and whatnot.
    It can be a git repository but it doesn't needs to be. If it is a git
    checkout, you can use git submodule to fetch bin_pub automatically.
-   ~/bin/bin_pub references to this repository, containing public scripts and
    configuration files.

Then you can just git pull computer:bin from all your workstations to keep your
workstations all in sync, and using git submodule to fetch public repositories
like git-prompt.


Setup steps
===========

git prior version 1.7.4 must call git submodule manually:

    cd ~
    git init bin
    cd bin
    git submodule add git://github.com/maruel/bin_pub.git bin_pub
    git submodule update
    cd bin_pub
    git submodule init
    git submodule update
