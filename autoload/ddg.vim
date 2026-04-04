" autoload/ddg.vim - Implementation for ddg.vim
" Loaded on first use; not at Vim startup.

let s:save_cpo = &cpoptions
set cpoptions&vim

" ----------------------------------------------------------------------------
" Internal helpers
" ----------------------------------------------------------------------------

" s:URLEncode({str})
"   Percent-encodes {str} for use as a query-string value.
"   Spaces become '+' (application/x-www-form-urlencoded).
"   Uses Python 3 when available for correct multi-byte handling; falls back
"   to a pure-Vimscript byte loop via str2list() (Vim 7.4.2122+).
function! s:URLEncode(str) abort
  if has('python3')
    return py3eval('__import__("urllib.parse", fromlist=["quote_plus"]).quote_plus(' . string(a:str) . ')')
  endif
  " str2list(str, 1) returns raw UTF-8 byte values, which is exactly what
  " percent-encoding requires.
  let l:result = ''
  for l:b in str2list(a:str, 1)
    if (l:b >= 65 && l:b <= 90)
      \ || (l:b >= 97 && l:b <= 122)
      \ || (l:b >= 48 && l:b <= 57)
      \ || l:b == 45
      \ || l:b == 95
      \ || l:b == 46
      \ || l:b == 126
      let l:result .= nr2char(l:b)
    elseif l:b == 32
      let l:result .= '+'
    else
      let l:result .= printf('%%%02X', l:b)
    endif
  endfor
  return l:result
endfunction

" s:OpenBrowser({url})
"   Opens {url} in the system default browser.
"   Respects g:ddg_open_command if set; otherwise auto-detects the platform.
function! s:OpenBrowser(url) abort
  let l:cmd = get(g:, 'ddg_open_command', '')
  if empty(l:cmd)
    if has('mac') || has('macunix')
      let l:cmd = 'open'
    elseif has('win32') || has('win64')
      let l:cmd = 'cmd /c start ""'
    elseif executable('xdg-open')
      let l:cmd = 'xdg-open'
    else
      echoerr 'ddg.vim: cannot determine how to open a browser; set g:ddg_open_command'
      return
    endif
  endif
  silent! call system(l:cmd . ' ' . shellescape(a:url))
endfunction

" ----------------------------------------------------------------------------
" Public API
" ----------------------------------------------------------------------------

" ddg#Search({query})
"   Validates {query}, builds the DuckDuckGo URL, and opens the browser.
function! ddg#Search(query) abort
  let l:query = trim(a:query)
  if empty(l:query)
    echoerr 'ddg.vim: search query must not be empty'
    return
  endif
  call s:OpenBrowser('https://duckduckgo.com/?q=' . s:URLEncode(l:query))
endfunction

" ddg#SearchWord()
"   Searches DuckDuckGo for the word under the cursor.
function! ddg#SearchWord() abort
  let l:word = expand('<cword>')
  if empty(l:word)
    echoerr 'ddg.vim: no word under cursor'
    return
  endif
  call ddg#Search(l:word)
endfunction

" ddg#SearchVisual()
"   Searches DuckDuckGo for the current visual selection.
"   Preserves the unnamed register.
function! ddg#SearchVisual() abort
  let [l:reg, l:regtype] = [getreg('"'), getregtype('"')]
  normal! gvy
  let l:selection = getreg('"')
  call setreg('"', l:reg, l:regtype)
  call ddg#Search(l:selection)
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
