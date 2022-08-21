## Updating .bash_aliases

OSX won't load .bash_aliases by default, unlike cygwin or Ubuntu's default
.bashrc because no .bashrc or .profile is provided by default.
- .profile is needed when opening a new terminal.
- .bashrc is needed when creating a terminal in screen (non-login session).
Run:

  ~/bin/bin_pub/setup_scripts//fix_bash.sh

## Updating Bash

macOS includes bash 3.2, which is too old for git-prompt. To install bash,
you need brew. Let's install it for the user only. This requires XCode and
command line tools. Once both are installed, run:

  ~/bin/bin_pub/setup_scripts/install_brew.sh
