" syntax file to visualize LIFE

" TODO: Also do definitions for gvim 
" some color definitions
hi LCode ctermbg=0 ctermfg=2 
hi LScript ctermbg=8 ctermfg=2 
hi Definition cterm=standout ctermfg=8 
hi Link cterm=standout,underline ctermbg=11 guibg=11
hi Done ctermbg=10 ctermfg=8 
hi LToDo ctermbg=1 ctermfg=3 
hi IM cterm=bold ctermbg=0 ctermfg=4 
hi LSpace ctermbg=0 ctermfg=0 

" old top-level items
" hi LTop cterm=underline,bold ctermfg=0 ctermbg=7
" syntax match ltop /^[a-zA-Z_].*/

" top level items, from vim help syntax
syn match aStar contained "\*"
syn match aBar contained "|"

syn match ljump	/\\\@<!|[^|]\+|/ contains=aBar
syn match ltop	/\\\@<!\*[^*]\+\*/ contains=aStar

"syn match ltop	"\*[^"*|]\+\*\s"he=e-1 contains=aStar
"syn match ltop	"\*[^"*|]\+\*$" contains=aStar
"syn match ljump "\\\@<!|[^"*|]\+|" contains=aBar

highlight link aStar LineNr
highlight link aBar Question
highlight link ltop String
highlight link ljump Identifier

""""
syntax match lsub /^.*\n\t*===\+/
highlight link lsub WarningMsg

syntax match llist /^\s\+\zs[>\-=*]>\? /
highlight link llist ErrorMsg

" lines ending with ':'
syntax match lsub2 /[a-zA-Z].*:$/
highlight link lsub2 WarningMsg

" the \ is for latex one liners
syntax match lcmd /^\t*\zs[$:\\].*/
highlight link lcmd LCode

" # script, " vi, % latex
syntax match lcmt /^\t\+[#"%].*/
highlight link lcmt Comment

" s\? -> for https :)
syntax match llink @[a-z][a-z][a-z][a-z]s\?://\S\+@
highlight link llink Statement

syntax match lemail /\S\+@\S\+/
highlight link lemail Identifier

syntax match ldone /[Dd][Oo][Nn][Ee]/
highlight link ldone Done

syntax match ltodo /[Tt][Oo][Dd][Oo]/
highlight link ltodo LToDo

" we don't like highlighting leading space
syntax match lspace /^\s\+/ contained
highlight link lspace LSpace

syntax region ldef start=@'''@hs=s+3 end=@'''@he=s-1 contains=lspace
highlight link ldef Definition

syntax region lcode start=/\[\[\[/hs=s+3 end=/\]\]\]/he=s-3 contains=lspace
highlight link lcode LCode

syntax region lim start=@{{{@hs=s+3 end=@}}}@he=s-3 contains=lspace
highlight link lim IM

syntax region lscript start=@(((@hs=s+3 end=@)))@he=s-3 contains=lspace
highlight link lscript LScript
