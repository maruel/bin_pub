" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

if &diff
  syntax off
  " if you would like to make tabs and trailing spaces visible without syntax
  " highlighting, use this:
  set listchars=tab:·\ ,trail:\·,extends:»,precedes:«
else
  syntax on
  " show trailing spaces in yellow (or red, for users with dark backgrounds).
  " "set nolist" to disable this.
  " this only works if syntax highlighting is enabled.
  set list
  set listchars=tab:\ \ ,trail:\ ,extends:»,precedes:«
  if &background == "dark"
    highlight SpecialKey ctermbg=Red guibg=Red
  else
    highlight SpecialKey ctermbg=Yellow guibg=Yellow
  end
end

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
endif " has("autocmd")


" makes tabs insert "indents" at the beginning of the line
set smarttab

" reasonable defaults for indentation
set autoindent nocindent nosmartindent

let is_bash=1                  " informs sh syntax that /bin/sh is actually bash
let java_allow_cpp_keywords=1  " don't highlight C++ kewords as errors in Java
let java_highlight_functions=1 " highlight method decls in Java (when syntax on)

set textwidth=80
set expandtab
set modeline
set smartcase
" Too bad this isn't updated when textwidth is changed.
let w:m1=matchadd('ErrorMsg', '\%>'.&textwidth.'v.\+', -1)


"
" http://zmievski.org/2007/02/vim-for-php-programmers-slides-and-resources
"
" http://ubuntuforums.org/showthread.php?t=1112965
"

" Write contents of the file, if it has been modified, on buffer exit
"set autowrite

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

" Use F10 to toggle 'paste' mode
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

" Use 8 spaces for <Tab> and :retab
set tabstop=8

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


"
" NERDTree configuration
"

" Increase window size to 35 columns
let NERDTreeWinSize=35

" map <F7> to toggle NERDTree window
nmap <silent> <F7> :NERDTreeToggle<CR>

let Tlist_GainFocus_On_ToggleOpen = 1


" MARUEL
set ttymouse=xterm2
