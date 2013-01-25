" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" For golang plugins.
set rtp+=~/src/golang/misc/vim

" Enable file type detection.
filetype plugin indent on
filetype plugin on

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

" Use automatic folding but unfolded by default.
set foldmethod=indent
set foldlevel=99
" Automatic fold save and restore
" In general, it's not worth the trade-off sadly.
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview


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

" Toggle fold with space in normal mode or F9 all the time. Ctrl-space opens all
" inner folds
nnoremap <space> za
noremap <F9> za
noremap <F8> zO
" Doesn't work: imap <Nul> zO


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

" map <F7> to toggle Fmt
nmap <silent> <F7> :Fmt<CR>

" https://groups.google.com/a/google.com/group/vi-users/browse_thread/thread/294a4f1dc029a876
" Python plugin that shows current context
python << EOF
import vim

def _CountIdent(line):
  i = 0
  while i < len(line) and line[i].isspace():
    # TODO(leviathan): maybe treat tabs and spaces differently?
    i += 1
  return i

#TODO(leviathan): Properly get value from vim.
_current_cmdheight = 1
_needed_cmdheight = 1
_context = []

def _ShowContext():
  global _current_cmdheight, _needed_cmdheight, _context
  cur_line = vim.current.window.cursor[0] - 1
  # skip empty lines
  while cur_line > 0 and vim.current.buffer[cur_line].strip() == '':
    cur_line -= 1
  ident = _CountIdent(vim.current.buffer[cur_line])
  _context = []
  for line_num in xrange(cur_line - 1, -1, -1):
    line = vim.current.buffer[line_num]
    if len(line.strip()) == 0:
      continue
    new_ident = _CountIdent(line)
    if new_ident < ident:
      _context.append(line.rstrip().replace('\\','\\\\').replace('"', '\\"'))
      ident = new_ident
      if ident == 0:
        break
  _needed_cmdheight = len(_context) + 1
  if _needed_cmdheight > _current_cmdheight:
    _current_cmdheight = _needed_cmdheight
  _ResizeCmdAndPrint(_current_cmdheight)

def _ResizeCmdAndPrint(height):
  global _current_cmdheight
  _current_cmdheight = height
  vim.command('set cmdheight=%d' % height)
  # redraw the context after resize.
  vim.command('echo "%s"' % '\\n'.join(reversed(_context)))

def RegisterShowContext():
  vim.command('autocmd show_context CursorMoved,CursorMovedI * :python _ShowContext()')
  vim.command('autocmd show_context CursorHold,CursorHoldI * ' +
    ':python _ResizeCmdAndPrint(_needed_cmdheight)')

def UnregisterShowContext():
  vim.command('set cmdheight=1')
  vim.command('autocmd! show_context')
EOF

augroup show_context
map & :python RegisterShowContext()<CR>
map && :python UnregisterShowContext()<CR>
