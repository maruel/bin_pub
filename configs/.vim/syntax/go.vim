" source ~/.vim/syntax/go.orig.vim
setlocal tabstop=2
setlocal shiftwidth=2
setlocal textwidth=0
setlocal noexpandtab
set listchars=
set nolist
autocmd BufWritePre *.go :silent Fmt

"let w:m2=matchdelete(w:m1)
