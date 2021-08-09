" Copyright 2021 Marc-Antoine Ruel. All Rights Reserved. Use of this
" source code is governed by a BSD-style license that can be found in the
" LICENSE file.
"
" This file sets many settings to make vim bearable. Some of these may be
" historical, I do a clean up ~yearly or so, but parts of vim are still
" inscrutable even to me. If you want to laugh, see https://github.com/wi-ed/wi
"
" Things to remember:
" - ~/.vim/bundle contains the plugins.
" - The rationale for 2 spaces tab & 80 cols is to enable 4-window git-mergetool
"   to not require absurdly wide monitors. See .config/git/config for my setup.

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible


"""" PLUGINS

execute pathogen#infect()

" Enable file type detection.
filetype plugin indent on
filetype plugin on

" Avoid loading MatchParen plugin
let loaded_matchparen = 1


""""" COLORS

" tmux sets TERM=screen, which confuses vim.
set t_Co=256

" Don't request terminal version string (for xterm)
set t_RV=

if &diff
  " Disable syntax highlighting, it's confusing when diffing/merging.
  syntax off
  colorscheme diffing
else
  syntax on
end

" First set Normal to regular white on black text colors:
highlight Normal guifg=White guibg=Black

" Show trailing spaces and tabs as red dots.
set list
set listchars=tab:\·\·,trail:\·,extends:»,precedes:«
highlight SpecialKey ctermfg=Red

" Make 'gw' wrap at 80 columns.
set textwidth=80
" Use a subtle highlight at 80 columns.
set colorcolumn=80
highlight ColorColumn ctermbg=Black guibg=DarkGray

" Syntax highlighting for the primary groups. These only take effect when
" 'syntax on' is used.
" (see :help group-name):
" To print the current scheme: so $VIMRUNTIME/syntax/hitest.vim
highlight Comment    ctermfg=LightBlue
highlight Constant   ctermfg=White
highlight String     ctermfg=DarkGreen
highlight Identifier ctermfg=White
"Keep statements highlighted: highlight Statement  ctermfg=White
highlight PreProc    ctermfg=White
highlight Type       ctermfg=White
highlight Special    ctermfg=DarkGreen

" Highlight changes outside of groups. They take effect even when 'syntax off'
" is used.
highlight Search     ctermfg=Black ctermbg=DarkYellow
highlight IncSearch  ctermfg=Black ctermbg=DarkYellow
highlight treeDir    ctermfg=Cyan
highlight netrwDir   ctermfg=Cyan

" Enable mispell detection.
" zg add to dict
" z= suggestions
set spell

" Change misspell highlighting to be a simple underline. Note that spelling
" highlight even works when 'syntax off' is used.
highlight clear SpellBad
highlight SpellBad term=underline cterm=underline
" This renders weird output, especially when diffing.
highlight SpellCap ctermbg=Black

" Informs sh syntax that /bin/sh is actually bash.
let is_bash=1
" Don't highlight C++ keywords as errors in Java.
let java_allow_cpp_keywords=1
" Highlights method decls in Java (when syntax on).
let java_highlight_functions=1


"""" KEYBINDINGS

"let mapleader = "\<Space>"
let mapleader = ","

" Allow backspacing over everything
set backspace=indent,eol,start

" Do not copy when pasting by default
xnoremap o pgvy
" xnoremap p pgv"@=v:register.'y'<cr>

" Use F4 to toggle 'paste' mode
set pastetoggle=<F4>

" save changes
map ,s :w<CR>
" exit vim without saving any changes
map ,q :q!<CR>
" exit vim saving changes
map ,w :x<CR>
" switch to upper/lower window quickly
map <C-J> <C-W>j
map <C-K> <C-W>k
" use CTRL-F for omni completion
imap <C-F> ^X^O
" map CTRL-L to piece-wise copying of the line above the current one
imap <C-L> @@@<ESC>hhkywjl?@@@<CR>P/@@@<CR>3s
" map ,f to display all lines with keyword under cursor and ask which one to
" jump to
nmap ,f [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
" use <F6> to toggle line numbers
nmap <silent> <F6> :set number!<CR>
" page down with <Space>
nmap <Space> <PageDown>
" Toggle line numbers
nmap <C-D><C-D> :set invnumber<CR>
" open filename under cursor in a new window (use current file's working
" directory)
nmap gf :new %:p:h/<cfile><CR>
" map <Alt-p> and <Alt-P> to paste below/above and reformat
nnoremap <Esc>P  P'[v']=
nnoremap <Esc>p  p'[v']=
" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Toggle fold with space in normal mode or F8 all the time. Ctrl-space opens all
" inner folds
nnoremap <space> za
" Next file
map <silent> <F10> :bn<CR>
" Previous file
map <silent> <F9> :bp<CR>
" Expand
"map <silent> <F8> :za<CR>
" Collapse
"map <silent> <F7> :zO<CR>
" https://github.com/fatih/vim-go
map <silent> <F5> :GoCoverage<CR>
map <silent> <F6> :GoTestFunc<CR>
"map <silent> <F6> :'<,'>sort<CR>
" Doesn't work: imap <Nul> zO
" map <F7> to toggle Fmt
"nmap <silent> <F7> :Fmt<CR>

" K = doc
" gd = go to definition
" Ctrl-t = go back

" Abbreviations
ab #i #include
ab #d #define

nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

" Fix my <Backspace> key (in Mac OS X Terminal)
" set t_kb=^?
" fixdel


"""" EDITING

" Makes tabs insert "indents" at the beginning of the line
set smarttab
set expandtab

" Reasonable defaults for indentation
set autoindent nocindent nosmartindent

" Round indent to multiple of 'shiftwidth' for > and < commands
set shiftround

" Use 2 spaces for (auto)indent
set shiftwidth=2

" Use 2 spaces for <Tab> and :retab
set tabstop=2

" Single space between sentences.
set nojoinspaces

" Write contents of the file, if it has been modified, on buffer exit
set autowrite

" Write swap file to disk after every 50 characters
set updatecount=50

" Disable annoying dummy vim-go file.
let g:go_template_autocreate = 0


"""" UI

" Use automatic folding but unfolded by default.
set foldmethod=indent
set foldlevel=99

" Always show status line, even for one window
set laststatus=2

" Jump to matching bracket for 2/10th of a second (works with showmatch)
set matchtime=2

" Show line, column number, and relative position within a file in the status line
set ruler

" Scroll when cursor gets within 5 characters of top/bottom edge
set scrolloff=5

" Insert mode completion options
set completeopt=menu,longest,preview

" Use UTF-8 as the default buffer encoding
set enc=utf-8

" Use nicer search.
set smartcase

" Enable incremental search
set incsearch

" Highlight results of a search
set hlsearch

" Show (partial) commands (or size of selection in Visual mode) in the status line
set showcmd

" When a bracket is inserted, briefly jump to a matching one
set showmatch

" Enable mouse.
set ttymouse=xterm2

" Use menu to show command-line completion (in 'full' case)
set wildmenu

" Set command-line completion mode:
"   - on first <Tab>, when more than one match, list all matches and complete
"     the longest common  string
"   - on second <Tab>, complete the next full match and show menu
set wildmode=list:longest,full

" netRW: Open files in a split window
let g:netrw_browse_split = 1


"""" HISTORY

" Go back to the position the cursor was on the last time this file was edited
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")|execute("normal `\"")|endif

" Automatic fold save and restore
" In general, it's not worth the trade-off sadly.
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview

" Remember up to 100 'colon' commands and search patterns
set history=100

" Remember things between sessions
"
" '20  - remember marks for 20 previous files
" \"50 - save 50 lines for each register
" :20  - remember 20 items in command-line history
" %    - remember the buffer list (if vim started without a file arg)
" n    - set name of viminfo file
set viminfo='20,\"50,:20,%,n~/.viminfo


""" PURGATORY

" Enable CTRL-A/CTRL-X to work on octal and hex numbers, as well as characters
set nrformats=octal,hex,alpha

" Set up cscope options
if has("cscope")
    set csprg=/usr/bin/cscope
    set csto=0
    set cst
    set nocsverb
    cs add cscope.out
    set csverb
    map <C-_> :cstag <C-R>=expand("<cword>")<CR><CR>
    map g<C-]> :cs find 3 <C-R>=expand("<cword>")<CR><CR>
    map g<C-\> :cs find 0 <C-R>=expand("<cword>")<CR><CR>
endif
