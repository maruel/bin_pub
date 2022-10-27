# Making macOS bearable

TL;DR:

```
mkdir ~/bin
git clone --recursive https://github.com/maruel/bin_pub ~/bin/bin_pub
~/bin/bin_pub/mac/install_homebrew.sh
~/bin/bin_pub/mac/fix_bash.sh
~/bin/bin_pub/setup_scripts/update_config.py
~/bin/bin_pub/setup_scripts/install_golang.py
```

## Accelerating UI

Sadly there's no way to accelerate the workspace animation. We can still
accelerate some stuff with:


```
~/bin/bin_pub/setup_scripts/fix_animation_speed.sh
```


## Recent Bash via non-root homebrew

macOS includes bash 3.2, which is too old for git-prompt. To install bash,
you need brew. Let's install it for the *current user* instead of as root. This
requires XCode and command line tools. Once both are installed, run:

```
~/bin/bin_pub/setup_scripts/install_brew.sh
```


## Updating .bash_aliases

macOS now uses zsh instead of bash by default. Even when using bash, macOS won't
load .bash_aliases by default, unlike cygwin or Ubuntu's default .bashrc because
no .bashrc or .profile is provided by default.

- .profile is needed when opening a new terminal.
- .bashrc is needed when creating a terminal in screen (non-login session).

Run:

```
~/bin/bin_pub/setup_scripts/fix_bash.sh
```


## Fixing keyboard


- Open System Preferences / Keyboard.
  - Keyboard tab
    - Check Use F keys as standard keys.
    - Click Modifiers, Map CapsLock to ESC.
  - Shortcuts tab
    - Mission Control, Disable F11 key.


## Registering Automation

This enables improving keyboard shortcuts. This is kind of clunky to setup but
once it's setup, it's magical.

One of the big problem with Automator is that it is very slow, as mentioned at
https://apple.stackexchange.com/questions/175215/how-do-i-assign-a-keyboard-shortcut-to-an-applescript-i-wrote#comment542130_175244

Keyboard Maestro


### Allowing automation

We need to grant "osascript" rights to play with System Events automation.

- Open System Preferences > Security and Privacy > Confidentiality.
- Click Accessibility.
- Click unlock at the bottom left and type your password.
- Click the "+" button.
- Press Shift-Command-G and in Go To Folder dialog, type `/usr/bin/osascript`
  then press Enter.

Further references:
- https://apple.stackexchange.com/a/394983
- https://discussions.apple.com/thread/8660190?answerId=34258386022#34258386022
- https://apple.stackexchange.com/a/377253

Alternative:

```
git clone https://github.com/temochka/Anykey
xcode-select --install
sudo xcode-select --switch /Library/Developer/CommandLineTool
xcodebuild Anykey.xcodeproj
```

### Creating the automations

- Open Automator.
  - Make a new Quick Action.
  - Select "no input" as process input.
  - Double click on Run bash script (dunno what the name is in English).
  - Type: `~/bin/bin_pub/mac/toggle_current_window_fullscreen.js`
  - Press the Run button.
    - This will prompt to grant rights in System Preferences.
    - Click the Unlock button at the bottom and enter your password.
    - Check Automator.
  - Go back to Automator, dismiss the error message.
  - Click the Run button again, it should work now.
    - One time will make it fullscreen, second time will make it windowed. 🎉
  - Menu File, Save, name it "Toggle fullscreen".

It is possible to use the the JavaScript (or AppleScript) execution instead.
What I found is that when this is done, every single application needs to be
granted access to Accessibility, which is annoying.


### Creating keyboard shortcuts

- Open System Preferences / Keyboard.
  - Shortcuts tab
    - Services, scroll down, you'll see General, Toggle fullscreen.
      - If not, quit System Preferences and restart it.
    - Set a shortcut, e.g. shift-command-F.
      - On first time, you will get an error prompt to grant access to System
        Events. Follow the prompt. This time the flow is a bit clunky because
        System Preferences tries to open System Preferences...
      - Click the Unlock button at the bottom and enter your password.
      - Check System Preferences.
    - Still not working? See https://apple.stackexchange.com/a/276839.


### Debugging

```
log stream --debug --predicate 'subsystem == "com.apple.TCC" AND eventMessage` BEGINSWITH "AttributionChain"' | grep --color=always binary_path
```
