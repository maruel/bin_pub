## Windows

1. Système > Pour les développeurs > Mode développeur
2. Set Terminal as default.
3. Setup python by running `python3` and installing with the Microsoft Store.
4. Download ssh key.
5. Install git: `winget install --id Git.Git -e --source winget`
    1. This install make use of git's ssh client. Use `start-ssh-agent` to start the agent.
6. In Powershell as admin to unblock normal (non-git) ssh:
    1. `Get-Service -Name ssh-agent | Set-Service -StartupType Automatic`
    2. `Start-Service ssh-agent`
7. `git clone --recurse git@github.com:maruel/bin`
8. Get VSCode https://code.visualstudio.com/download User Installer.
    1. Install python, git, go extensions by opening a file.
    1. Settings, EOL
9. `python3 bin\bin_pub\setup_scripts\update_config.py`
    - This is important as it sets LF EOL for git.
10. `python3 bin\bin_pub\setup_scripts\install_golang.py`
11. Setting PATH (setx is risky), better to add from the UI: Right-click PC, Advanced system settings, Environment variables
    - `%USERPROFILE%\bin\bin_pub`
    - `%USERPROFILE%\bin\bin_pub\win`
    - go\bin will be added by the script install_golang.py.
    - `PYTHONUTF8=1` until [python3.15](https://docs.python.org/3/library/os.html#utf8-mode)
12. Enable DEP: Right-click PC, Advanced system settings, Performance Settings, Data execution prevention, enable for all programs.
13. Windows Explorer
    1. View, Compact
    1. View, More, File extension
    1. 3 dots, Options, View
        1. Expand up to current folder
        1. Show full directory name
14. Disk
    1. Ensure bitlocker is enabled
    1. Reduce primary partition size
    1. Do not forget to close the disk manager and windows explorer.
    1. Settings, System, Storage, Disk and Volumes, [Create a dev drive](https://learn.microsoft.com/en-us/windows/dev-drive/), use unused space. Use letter `S:`
15. `mkdir s:\venv`
16. `cd /d s:\venv`
17. `python3 -m venv .`
18. `s:\venv\Scripts\activate`


## Chromium

Ref: https://chromium.googlesource.com/chromium/src/+/main/docs/windows_build_instructions.md

```
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
cd depot_tools
gclient
cd ..
mkdir chromium
cd chromium
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
..\depot_tools\fetch chromium
```

TODO:
- Offload packfile
- Rewrite URL to authenticate. Albeit at home I'm still in the 50~70MiB/s range unauthenticated. (!!)


## Swift

Ref: https://github.com/compnerd/swift-build/blob/main/docs/WindowsQuickStart.md

```
curl.exe -sLo repo https://storage.googleapis.com/git-repo-downloads/repo
mkdir swift
cd swift
python3 ..\repo init -u https://github.com/compnerd/swift-build
python3 ..\repo sync -j 8
```
