# Neovim

## Context and Preferences

- _I just want an editor that works_. How hard can that be?
- I don't have infinite memory, so I can only memorize so many keybindings.
- I often ssh from Windows/macOS/Linux/ChromeOS into a Linux/macOS server, or use it locally. The
  configuration has to work everywhere.
- I almost always use nvim inside tmux
  - I configured tmux to support [256 colors](configs/.tmux.conf).
  - I don't use [tmux panes](https://github.com/tmux/tmux/wiki/Getting-Started#sessions-windows-and-panes) at
    all.
- I don't use [neovim windows](https://neovim.io/doc/user/windows.html) much.
- I don't mind quitting and restarting nvim often.
  - I require nvim startup time to be unnoticeable.
- I'm fine with doing git operations in a separate tmux pane.


## Config files

- Global config: [configs/.config/nvim/init.lua](configs/.config/nvim/init.lua)
- Language specific: [configs/.config/nvim/ftplugin/](configs/.config/nvim/ftplugin/)
- Plugins: [configs/.config/nvim/lua/plugins/](configs/.config/nvim/lua/plugins/)


## Keybindings

| Key              | Source                               | Description |
| ---------------- | ------------------------------------ | ----------- |
| `F3`             | [init.lua](configs/.config/nvim/init.lua) | Toggle sign column |
| `F4`             | [init.lua](configs/.config/nvim/init.lua) | Git blame |
| `F5`             | [init.lua](configs/.config/nvim/init.lua) | Go coverage |
| `F7`             | [init.lua](configs/.config/nvim/init.lua) | Toggle paste |
| `F8`             | [init.lua](configs/.config/nvim/init.lua) | Toggle word wrap |
| `F9`             | [init.lua](configs/.config/nvim/init.lua) | Previous buffer |
| `F10`            | [init.lua](configs/.config/nvim/init.lua) | Next buffer |
| `<C-h>`          | [init.lua](configs/.config/nvim/init.lua) | Previous buffer |
| `<C-l>`          | [init.lua](configs/.config/nvim/init.lua) | Next buffer |
| `<C-W> h`        | [neovim window default](https://neovim.io/doc/user/vimindex.html#CTRL-W) | Move focus to window on the right |
| `<C-W> l`        | [neovim window default](https://neovim.io/doc/user/vimindex.html#CTRL-W) | Move focus to window on the left |
| `<C-W> 5<`       | [neovim window default](https://neovim.io/doc/user/vimindex.html#CTRL-W) | Reduce width
by 5 columns |
| `<C-W> 5-`       | [neovim window default](https://neovim.io/doc/user/vimindex.html#CTRL-W) | Reduce height
by 5 rows |
| `<leader>df`     | [init.lua](configs/.config/nvim/init.lua) | Delete current file |
| `<leader>ff`     | [init.lua](configs/.config/nvim/init.lua) | [Telescope](https://github.com/nvim-telescope/telescope.nvim) find files |
| ↪ `<C-h>`        | [Telescope file browser](https://github.com/nvim-telescope/telescope-file-browser.nvim#mappings)  | Toggle hidden files |
| `<leader>fg`     | [init.lua](configs/.config/nvim/init.lua)                                                         | [Telescope](https://github.com/nvim-telescope/telescope.nvim) live grep |
| ↪ `<C-q>`        | [Telescope](https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#default-mappings) | Send to [quickfix](https://neovim.io/doc/user/quickfix.html) list and open list |
| `<leader>n`      | [init.lua](configs/.config/nvim/init.lua) | Next quickfix |
| `<leader>p`      | [init.lua](configs/.config/nvim/init.lua) | Previous quickfix |
| `<leader>fb`     | [init.lua](configs/.config/nvim/init.lua) | [Telescope file browser](https://github.com/nvim-telescope/telescope-file-browser.nvim) |
| `<C-f>`          | [init.lua](configs/.config/nvim/init.lua) | [Namu](https://github.com/bassamsdata/namu.nvim) Go to symbol fuzy search |
| `<C-j>`          | [init.lua](configs/.config/nvim/init.lua) | Accept [Copilot](https://github.com/github/copilot.vim) suggestion |
| `<leader>a`      | [init.lua](configs/.config/nvim/init.lua) | [CodeCompanion chat](https://codecompanion.olimorris.dev/configuration/chat-buffer.html) |
| ↪ `<C-s>`        | [CodeCompanion default](https://codecompanion.olimorris.dev/configuration/chat-buffer.html#keymaps) | Send CodeCompanion chat |
| ↪ `<C-c>`        | [CodeCompanion default](https://codecompanion.olimorris.dev/configuration/chat-buffer.html#keymaps) | Close CodeCompanion chat |
| `<leader>s`      | [init.lua](configs/.config/nvim/init.lua)                                           | [CodeCompanion action palette](https://codecompanion.olimorris.dev/configuration/action-palette.html) |
| `b`              | [neovim motion default](https://neovim.io/doc/user/motion.html#b)                   | Previous word |
| `B`              | [neovim motion default](https://neovim.io/doc/user/motion.html#B)                   | Previous words |
| `w`              | [neovim motion default](https://neovim.io/doc/user/motion.html#w)                   | Next word |
| `W`              | [neovim motion default](https://neovim.io/doc/user/motion.html#W)                   | Next words |
| `e`              | [neovim motion default](https://neovim.io/doc/user/motion.html#e)                   | End of word |
| `E`              | [neovim motion default](https://neovim.io/doc/user/motion.html#E)                   | End of words |
| `[[`             | [neovim motion default](https://neovim.io/doc/user/motion.html#%5B%5B)              | Previous section |
| `]]`             | [neovim motion default](https://neovim.io/doc/user/motion.html#%5D%5D)              | Next section |
| `gg`             | [neovim motion default](https://neovim.io/doc/user/motion.html#gg)                  | Go to top of file |
| `G`              | [neovim motion default](https://neovim.io/doc/user/motion.html#G)                   | Go to end of file |
| `g``"`           | [neovim motion default](https://neovim.io/doc/user/motion.html#g%60a)               | Last position |
| `ma`             | [neovim motion default](https://neovim.io/doc/user/motion.html#m)                   | Set mark a |
| `'a`             | [neovim motion default](https://neovim.io/doc/user/motion.html#')                   | Go to mark a |
| `za`             | [neovim fold default](https://neovim.io/doc/user/fold.html#za)                      | Toggle fold |
| `grn`            | [neovim LSP global default](https://neovim.io/doc/user/lsp.html#_global-defaults)   | LSP: Rename current symbol |
| `grr`            | [neovim LSP global default](https://neovim.io/doc/user/lsp.html#_global-defaults)   | LSP: List current symbol references |
| `gO`             | [neovim LSP global default](https://neovim.io/doc/user/lsp.html#_global-defaults)   | LSP: List all symbols in current file |
| `<C-]>`          | [neovim buffer default](https://neovim.io/doc/user/lsp.html#_buffer-local-defaults) | LSP: Go to definition |
| `gq`             | [neovim buffer default](https://neovim.io/doc/user/lsp.html#_buffer-local-defaults) | LSP: Format current selection |
| `gw`             | [neovim buffer default](https://neovim.io/doc/user/lsp.html#_buffer-local-defaults) | LSP: Word wrap (or unwrap) current selection |
| `K`              | [neovim buffer default](https://neovim.io/doc/user/lsp.html#_buffer-local-defaults) | LSP: Show hover information |
| `<C-x>`, `<C-o>` | [neovim buffer default](https://neovim.io/doc/user/lsp.html#_buffer-local-defaults) | LSP: Auto complete |
| `u`              | [neovim undo default](https://neovim.io/doc/user/undo.html#u)                       | Undo |
| `U`              | [init.lua](configs/.config/nvim/init.lua)                                           | Redo |


### Default keymappings references

- https://neovim.io/doc/user/fold.html
- https://neovim.io/doc/user/insert.html
- https://neovim.io/doc/user/motion.html
- https://neovim.io/doc/user/undo.html
- https://neovim.io/doc/user/various.html
- https://neovim.io/doc/user/vimindex.html
- https://github.com/nvim-telescope/telescope.nvim#default-mappings
- https://github.com/nvim-telescope/telescope-file-browser.nvim#mappings
- https://codecompanion.olimorris.dev/usage/chat-buffer/#keymaps
- https://codecompanion.olimorris.dev/usage/inline-assistant.html#diff-mode


## Use cases


### Normal editing

- `i` to insert text
- Add a comment to explain what to do
- `C-j` to accept copilot suggestion


### Chatting

- `<leader>a` to open the CodeCompanion chat buffer
  - _Write unit test for function foo in #buffer_
- `<C-s>` to send the message
- `<C-c>` to close the chat buffer
- `gy` to paste the last code block generated from the LM chat into the current buffer


### Inline edit

- `V` to select a code block
- `:cc <question>` to ask a question to the LLM to edit the code
- `ga` to accept the suggestion, `gr` to reject it

Still flaky, doesn't help with unit tests in Go, since they are in a separate file.


### Find and replace

- `V`, select a text block
- `:s/foo/bar/g`
  - `gg`, `V`, `G`, `:s/ \+$//g` removes all trailing spaces.
  - `gg`, `V`, `G`, `:s/\r//g` converts Windows line endings to Unix line endings.


### Find and replace in many files

- `<space>fg` to open Telescope live_grep
- Type regexp
- `<C-q>` to send files to quickfix
- `:cfdo :%s/Foo/Bar/g | update | bd` 
  - `cfdo` opens each file in QuickFix, run the commands.
  - `update` is like `write` but doesn't write if there's no change.
  - `bd` closes the buffer (file).


## Configuration

- Install: [linux/get_nvim.sh](linux/get_nvim.sh), [mac/get_nvim.sh](mac/get_nvim.sh) or
  [Windows](https://github.com/neovim/neovim/blob/master/INSTALL.md)
- Copilot
  - Require nodejs: [linux/get_nodejs.sh](linux/get_nodejs.sh), [mac/get_nodejs.sh](mac/get_nodejs.sh)
  - `:Copilot setup`
- CodeCompanion
  - Set environment variable with API keys
- Install [Go toolchain](https://go.dev)


### Health chekcs

- `:Copilot status`
- `:checkhealth codecompanion`
- `:checkhealth lsp`


## Wish list

- [ ] Cursor-like whole repo refactoring.
    - [ ] MCP based tooling, e.g. [ravitemer/mcphub.nvim](https://github.com/ravitemer/mcphub.nvim).
    - [ ] RAG based on LSP, e.g. [Davidyz/VectorCode](https://github.com/Davidyz/VectorCode).
- [ ] Go imports to work all the time (it got flaky, I don't know why).
- [ ] Multi-cursor support
  ([example](https://github.com/olimorris/dotfiles/blob/main/.config/nvim/lua/config/keymaps.lua)).
- [ ] Learn how to use quickfix effectively, e.g. [kevinhwang91/nvim-bqf](https://github.com/kevinhwang91/nvim-bqf).
