# M-A's configuration files

Configuration files to be put in `$HOME`.

Hint: use ls -la.

Only the public part is there, the private part is in bin.git which is, well,
private. The script `../setup_scripts/update_config.py` will append whatever
found in `../../configs/` to the files and directories contained here.

pathogen use in vim requires an additional setup:

    cd ~/.vim
    mkdir bundle
    cd bundle
    git clone https://github.com/fatih/vim-go.git
