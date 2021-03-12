" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

"let mapleader = "\<Space>"
let mapleader = ","

execute pathogen#infect()

set runtimepath^=~/bin/bin_pub/ctrlp.vim

" Enable file type detection.
filetype plugin indent on
filetype plugin on

" tmux sets TERM=screen, which confuses vim.
set t_Co=256

if &diff
  colorscheme diffing
  " if you would like to make tabs and trailing spaces visible without syntax
  " highlighting, use this:
  "set listchars=tab:·\ ,trail:\·,extends:»,precedes:«
else
  syntax on
  " show trailing spaces in yellow (or red, for users with dark backgrounds).
  " "set nolist" to disable this.
  " this only works if syntax highlighting is enabled.
  "set list
  set listchars=
  "set listchars=tab:\ \ ,trail:\ ,extends:»,precedes:«
  if &background == "dark"
    highlight SpecialKey ctermbg=Red guibg=Red
  else
    highlight SpecialKey ctermbg=Yellow guibg=Yellow
  end
end


" makes tabs insert "indents" at the beginning of the line
set smarttab

" reasonable defaults for indentation
set autoindent nocindent nosmartindent

let is_bash=1                  " informs sh syntax that /bin/sh is actually bash
let java_allow_cpp_keywords=1  " don't highlight C++ kewords as errors in Java
let java_highlight_functions=1 " highlight method decls in Java (when syntax on)

set expandtab
set modeline
set smartcase
set textwidth=80
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey


" Use automatic folding but unfolded by default.
set foldmethod=indent
set foldlevel=99
" Automatic fold save and restore
" In general, it's not worth the trade-off sadly.
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview

" Simple space betweem sentences.
set nojoinspaces


" Do not copy when pasting by default
xnoremap o pgvy
" xnoremap p pgv"@=v:register.'y'<cr>


"
" http://zmievski.org/2007/02/vim-for-php-programmers-slides-and-resources
"
" http://ubuntuforums.org/showthread.php?t=1112965
"

" Write contents of the file, if it has been modified, on buffer exit
set autowrite

" Allow backspacing over everything
set backspace=indent,eol,start

" Insert mode completion options
set completeopt=menu,longest,preview

" Use UTF-8 as the default buffer encoding
set enc=utf-8

" Remember up to 100 'colon' commmands and search patterns
set history=100

" Enable incremental search
set incsearch

" Always show status line, even for one window
set laststatus=2

" Jump to matching bracket for 2/10th of a second (works with showmatch)
set matchtime=2

" Highlight results of a search
set hlsearch

" Enable CTRL-A/CTRL-X to work on octal and hex numbers, as well as characters
set nrformats=octal,hex,alpha

" Use F4 to toggle 'paste' mode
set pastetoggle=<F4>

" Show line, column number, and relative position within a file in the status line
set ruler

" Scroll when cursor gets within 5 characters of top/bottom edge
set scrolloff=5

" Round indent to multiple of 'shiftwidth' for > and < commands
set shiftround

" Use 2 spaces for (auto)indent
set shiftwidth=2

" Show (partial) commands (or size of selection in Visual mode) in the status line
set showcmd

" When a bracket is inserted, briefly jump to a matching one
set showmatch

" Don't request terminal version string (for xterm)
set t_RV=

" Use 2 spaces for <Tab> and :retab
set tabstop=2

" Write swap file to disk after every 50 characters
set updatecount=50

" Remember things between sessions
"
" '20  - remember marks for 20 previous files
" \"50 - save 50 lines for each register
" :20  - remember 20 items in command-line history
" %    - remember the buffer list (if vim started without a file arg)
" n    - set name of viminfo file
set viminfo='20,\"50,:20,%,n~/.viminfo

" Use menu to show command-line completion (in 'full' case)
set wildmenu

" Set command-line completion mode:
"   - on first <Tab>, when more than one match, list all matches and complete
"     the longest common  string
"   - on second <Tab>, complete the next full match and show menu
set wildmode=list:longest,full

" Go back to the position the cursor was on the last time this file was edited
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")|execute("normal `\"")|endif

" Fix my <Backspace> key (in Mac OS X Terminal)
" set t_kb=^?
" fixdel

" Avoid loading MatchParen plugin
let loaded_matchparen = 1

" netRW: Open files in a split window
let g:netrw_browse_split = 1

" Annoying dummy vim-go file.
let g:go_template_autocreate = 0


"
" MAPPINGS
"
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

" Generic highlight changes
highlight Comment cterm=none ctermfg=LightBlue
highlight IncSearch cterm=none ctermfg=Black ctermbg=DarkYellow
highlight Search cterm=none ctermfg=Black ctermbg=DarkYellow
highlight String cterm=none ctermfg=DarkGreen
highlight treeDir cterm=none ctermfg=Cyan
highlight treeUp cterm=none ctermfg=DarkYellow
highlight treeCWD cterm=none ctermfg=DarkYellow
highlight netrwDir cterm=none ctermfg=Cyan

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



" MARUEL
set ttymouse=xterm2

" zg add to dict
" z= suggestions
set spell
highlight clear SpellBad
" highlight SpellBad term=standout ctermfg=1
highlight SpellBad term=underline cterm=underline

nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>
