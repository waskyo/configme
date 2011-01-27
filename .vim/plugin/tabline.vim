if v:version >= 700
else
finish
endif


function! MyTabLine()
let s = ''
for i in range(tabpagenr('$'))
" select the highlighting
if i + 1 == tabpagenr()
let s .= '%#TabLineSel#'
else
let s .= '%#TabLine#'
endif

" set the tab page number (for mouse clicks)
let s .= '%' . (i + 1) . 'T'

" the label is made by MyTabLabel()
let s .= ' %{MyTabLabel(' . (i + 1) . ')} |'
endfor

" after the last tab fill with TabLineFill and reset tab page nr
let s .= '%#TabLineFill#%T'

" right-align the label to close the current tab page
if tabpagenr('$') > 1
let s .= '%=%#TabLine#%999X X'
endif

"echomsg 's:' . s
return s
endfunction

function! MyTabLabel(n)
let buflist = tabpagebuflist(a:n)
let winnr = tabpagewinnr(a:n)
let numtabs = tabpagenr('$')
" account for space padding between tabs, and the "close" button
let maxlen = ( &columns - ( numtabs * 2 ) - 4 ) / numtabs
let tablabel = bufname(buflist[winnr - 1])
while strlen( tablabel ) < 4
let tablabel = tablabel . " "
endwhile
let tablabel = fnamemodify( tablabel, ':t' )
let tablabel = strpart( tablabel, 0, maxlen )
return tablabel
endfunction

set tabline=%!MyTabLine()

set showtabline=1 " 2=always
autocmd GUIEnter * hi! TabLineFill term=underline cterm=underline gui=underline
autocmd GUIEnter * hi! TabLineSel term=bold,reverse,underline
\ ctermfg=11 ctermbg=12 guifg=#ffff00 guibg=#0000ff gui=underline

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
