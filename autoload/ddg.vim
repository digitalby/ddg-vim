" autoload/ddg.vim - Implementation for ddg.vim
" Loaded on first use; not at Vim startup.
scriptencoding utf-8

let s:save_cpo = &cpoptions
set cpoptions&vim

" ----------------------------------------------------------------------------
" Internal helpers
" ----------------------------------------------------------------------------

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

" s:CpToUTF8Pct({codepoint})
"   Returns the percent-encoded UTF-8 byte sequence for a Unicode codepoint.
"   e.g. 0xE9 (é) -> '%C3%A9', 0x65E5 (日) -> '%E6%97%A5'
function! s:CpToUTF8Pct(cp) abort
  if a:cp < 0x80
    return printf('%%%02X', a:cp)
  elseif a:cp < 0x800
    return printf('%%%02X%%%02X',
      \ 0xC0 + a:cp / 64,
      \ 0x80 + a:cp % 64)
  elseif a:cp < 0x10000
    return printf('%%%02X%%%02X%%%02X',
      \ 0xE0 + a:cp / 4096,
      \ 0x80 + (a:cp / 64) % 64,
      \ 0x80 + a:cp % 64)
  else
    return printf('%%%02X%%%02X%%%02X%%%02X',
      \ 0xF0 + a:cp / 262144,
      \ 0x80 + (a:cp / 4096) % 64,
      \ 0x80 + (a:cp / 64) % 64,
      \ 0x80 + a:cp % 64)
  endif
endfunction

" ----------------------------------------------------------------------------
" Public API
" ----------------------------------------------------------------------------

" ddg#URLEncode({str})
"   Percent-encodes {str} for use as a query-string value.
"   Spaces become '+' (application/x-www-form-urlencoded).
"   str2list(str, 1) yields Unicode codepoints; s:CpToUTF8Pct converts each
"   non-ASCII codepoint to its percent-encoded UTF-8 byte sequence.
function! ddg#URLEncode(str) abort
  let l:result = ''
  for l:cp in str2list(a:str, 1)
    if (l:cp >= 65 && l:cp <= 90)
      \ || (l:cp >= 97 && l:cp <= 122)
      \ || (l:cp >= 48 && l:cp <= 57)
      \ || l:cp == 45
      \ || l:cp == 95
      \ || l:cp == 46
      \ || l:cp == 126
      let l:result .= nr2char(l:cp)
    elseif l:cp == 32
      let l:result .= '+'
    else
      let l:result .= s:CpToUTF8Pct(l:cp)
    endif
  endfor
  return l:result
endfunction

" ddg#Search({query})
"   Validates {query}, builds the DuckDuckGo URL, and opens the browser.
function! ddg#Search(query) abort
  let l:query = trim(a:query)
  if empty(l:query)
    echoerr 'ddg.vim: search query must not be empty'
    return
  endif
  call s:OpenBrowser('https://duckduckgo.com/?q=' . ddg#URLEncode(l:query))
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
