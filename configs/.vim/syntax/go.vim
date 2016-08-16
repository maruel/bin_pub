" M-A's preferences.
setlocal tabstop=2
setlocal shiftwidth=2
setlocal textwidth=0
setlocal noexpandtab
set listchars=
set nolist
let g:go_fmt_command = "goimports"

map <F1> :GoDoc<CR>
nnoremap <leader>v :vsp <CR>:exe "GoDef" <CR>
nnoremap <leader>s :sp <CR>:exe "GoDef"<CR>
nnoremap <leader>t :tab split <CR>:exe "GoDef"<CR>

source $GOPATH/src/golang.org/x/tools/cmd/oracle/oracle.vim
"let w:m2=matchdelete(w:m1)
