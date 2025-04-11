# Neovim

## Context and Preferences

- I often ssh from Windows/macOS/Linux/ChromeOS into a Linux/macOS server, or use it locally. The
  configuration has to work everywhere.
- _I just want an editor that works_. How hard can that be?
- I almost always use nvim inside tmux
  - I configured tmux to support [256 colors](configs/.tmux.conf).
  - I don't use tmux windows.
- I don't use neovim windows much.
- I don't mind quitting and restarting nvim often. I require nvim startup time to be unnoticeable.
- I'm fine with doing git operations in a separate tmux pane.


## Config files

- [configs/.config/nvim/init.lua](configs/.config/nvim/init.lua)
- [configs/.config/nvim/lua/plugins/](configs/.config/nvim/lua/plugins/)


## Keybindings

| Key          | Description |
| ------------ | ----------- |
| `F4`         | Git blame |
| `F5`         | Go coverage |
| `F7`         | Toggle paste |
| `F8`         | Toggle word wrap |
| `F9`, `C-h`  | Previous buffer |
| `F10`, `C-l` | Next buffer |
| `<leader>df` | Delete current file |
| `<leader>ff` | [Telescope](https://github.com/nvim-telescope/telescope.nvim) find files |
| `<C-h>`      | Toggle hiden files |
| `<leader>fg` | [Telescope](https://github.com/nvim-telescope/telescope.nvim) live grep |
| `<C-q>`      | Send to quickfix list and open list |
| `<leader>fb` | [Telescope file browser](https://github.com/nvim-telescope/telescope-file-browser.nvim) |
| `<C-j>`      | Accept [Copilot](https://github.com/github/copilot.vim) suggestion |
| `<leader>a`  | [CodeCompanion chat](https://codecompanion.olimorris.dev/configuration/chat-buffer.html) |
| `<C-s>`      | Send CodeCompanion chat |
| `<leader>s`  | [CodeCompanion action palette](https://codecompanion.olimorris.dev/configuration/action-palette.html) |
| `gg`         | Go to top of file [(default)](https://neovim.io/doc/user/motion.html#gg) |
| `G`          | Go to end of file [(default)](https://neovim.io/doc/user/motion.html#G) |
| `gd`         | LSP: Go to definition |
| `grn`        | LSP: rename current symbol [(global default)](https://neovim.io/doc/user/lsp.html#_global-defaults) |
| `grr`        | LSP: list current symbol references [(global default)](https://neovim.io/doc/user/lsp.html#_global-defaults) |
| `gO`         | LSP: list all symbols in current file [(global default)](https://neovim.io/doc/user/lsp.html#_global-defaults) |
| `gq`         | Format current selection [(buffer default)](https://neovim.io/doc/user/lsp.html#_buffer-local-defaults) |
| `gw`         | Word wrap (or unwrap) current selection [(buffer default)](https://neovim.io/doc/user/lsp.html#_buffer-local-defaults) |
| `K`          | Show hover [(buffer default)](https://neovim.io/doc/user/lsp.html#_buffer-local-defaults) |

Inline edit:
- `V` to select a code block
- `:cc <question>` to ask a question to the LLM to edit the code
- `ga` to accept the suggestion, `gr` to reject it

See additional default keymappings at:
- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#default-mappings
- https://github.com/nvim-telescope/telescope-file-browser.nvim?tab=readme-ov-file#mappings


## Useful commands

- `:Copilot status`
- `:checkhealth codecompanion`
- `:checkhealth lsp`
