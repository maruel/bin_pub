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
9. `python3 bin\bin_pub\setup_scripts\update_config.py`
    - This is important as it sets LF EOL for git.
10. `python3 bin\bin_pub\setup_scripts\install_golang.py`
11. Setting PATH (setx is risky), better to add from the UI: Right-click PC, Advanced system settings, Environment variables
    - `%USERPROFILE%\bin\bin_pub`
    - `%USERPROFILE%\bin\bin_pub\win`
    - go\bin will be added by the script install_golang.py.
12. Enable DEP: Right-click PC, Advanced system settings, Performance Settings, Data execution prevention, enable for all programs.

### TODO

1. Investigate https://learn.microsoft.com/en-us/windows/dev-drive/
