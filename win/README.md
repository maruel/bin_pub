## Windows

1. Système > Pour les développeurs > Mode développeur
2. Set Terminal as default.
3. Install git: `winget install --id Git.Git -e --source winget`
    1. TODO: make it use the right ssh client.
5. In Powershell en admin:
    1. `Get-Service -Name ssh-agent | Set-Service -StartupType Automatic`
    2. `Start-Service ssh-agent`
6. Download ssh key
7. git clone --recurse git@github.com:maruel/private

Setting PATH:
`<SRC>` be the path to scripts, then:
`PATH=<SRC>\bin\bin_pub\git_utils;<SRC>\bin\bin_pub\win;<SRC>\b\depot_tools`

### TODO

1. Investigate https://learn.microsoft.com/en-us/windows/dev-drive/
