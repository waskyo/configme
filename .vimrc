syntax on
set showmatch
set fo=crol
set ttymouse=xterm

" some terminals (terminator, m$ dos, cygwin) can't handle 16 color
if $TERM =~ 'xterm' | set t_Co=16 | endif
if $TERM =~ 'rxvt' | set t_Co=16 | endif
if $TERM =~ 'rxvt-unicode' | set t_Co=16 | endif
if $TERM =~ 'cygwin' | set t_Co=8 | endif
if $TERM =~ 'terminator' | set t_Co=8 | endif

filetype on
filetype indent on
filetype plugin on
set ttyfast
set nohlsearch

set incsearch
set history=500

set vb t_vb=

" make backspace always work
set backspace=indent,eol,start

" for gvimrc
set guifont=Bitstream\ Vera\ Sans\ Mono\ 8

autocmd FileType c set autoindent cindent shiftwidth=8 ts=8 foldmethod=indent
autocmd FileType cpp set autoindent cindent shiftwidth=8 ts=8 foldmethod=indent
autocmd FileType lisp set autoindent nocindent shiftwidth=4 ts=4
autocmd FileType java set autoindent cindent shiftwidth=4 ts=4 foldmethod=indent et
autocmd FileType xhtml set autoindent cindent shiftwidth=2 ts=2 foldmethod=indent
autocmd FileType python set nocindent shiftwidth=4 ts=4 foldmethod=indent expandtab
autocmd FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType tex set tw=72 spell spelllang=en_us
autocmd FileType bib set nospell
autocmd FileType xml set foldmethod=indent ts=2 sw=2 et
autocmd FileType javascript set autoindent shiftwidth=4 ts=4 foldmethod=indent expandtab
autocmd FileType lua set foldmethod=indent ts=4 shiftwidth=4 expandtab

autocmd BufRead LIFE* set ts=2 shiftwidth=2 foldmethod=indent nocindent smartindent ignorecase syntax=life iskeyword=@,33-41,43-64,162-255 keywordprg=/opt/firefox/firefox noexpandtab
autocmd BufRead NOTAS* set ts=2 shiftwidth=2 foldmethod=indent nocindent smartindent ignorecase syntax=life iskeyword=@,33-41,43-64,162-255 noexpandtab

autocmd BufRead admin.log* set expandtab
autocmd BufRead *xbindkeysrc* set expandtab ts=2 shiftwidth=2

set tabline=%!MyTabLine()

set showtabline=1 " 2=always
autocmd GUIEnter * hi! TabLineFill term=underline cterm=underline gui=underline
autocmd GUIEnter * hi! TabLineSel term=bold,reverse,underline
\ ctermfg=11 ctermbg=12 guifg=#ffff00 guibg=#0000ff gui=underline

" i hate plaintex
let g:tex_flavor="latex"

" so yank behaves like delete, i.e. Y == D
map Y y$

"evoke a web browser with the contents of the passed line
function! Browser (line0)
    "let line0 = getreg ("*") 
    let line = matchstr (a:line0, "http[^ ]*")
    :if line==""
      let line = matchstr (a:line0, "ftp[^ ]*")
    :endif
    :if line==""
      let line = matchstr (a:line0, "file[^ ]*")
    :endif
    let line = escape (line, "#?&;|%")
    ":if line=="" 
    "  let line = "\"" . (expand("%:p")) . "\"" 
    ":endif 
    exec ':silent !iceweasel ' . "\"" . line . "\""
endfunction

" couple of mmappings for Browser. first one opens the current line, second
" one opens the selection. careful with the second one, if it has a newline
" at the end (e.g. if you selected with f$) it'll give an error.
map ,w :call Browser (getline("."))<CR>
map ,W :call Browser (getreg("*"))<CR>

set title

if has("cscope")
	autocmd VimEnter */wordpress/* cs add /home/ricardo/code/android/wordpress/src/cscope
endif

autocmd BufRead *.tac set filetype=python
