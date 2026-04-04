" ddg.vim - Search DuckDuckGo from Vim's command mode
" Maintainer: digitalby
" License:    MIT
" Repository: https://github.com/digitalby/ddg-vim

if exists('g:loaded_ddg')
  finish
endif
let g:loaded_ddg = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" ----------------------------------------------------------------------------
" Commands
" ----------------------------------------------------------------------------

" :DDG {query}   Search DuckDuckGo for the given query.
" :DDGWord       Search DuckDuckGo for the word under the cursor.
command! -nargs=+ DDG     call ddg#Search(<q-args>)
command! -nargs=0 DDGWord call ddg#SearchWord()

" ----------------------------------------------------------------------------
" <Plug> targets
" ----------------------------------------------------------------------------

nnoremap <silent> <Plug>(ddg-search-word)   :<C-u>call ddg#SearchWord()<CR>
xnoremap <silent> <Plug>(ddg-search-visual) :<C-u>call ddg#SearchVisual()<CR>

" ----------------------------------------------------------------------------
" Default mappings  (disable with: let g:ddg_no_mappings = 1)
" ----------------------------------------------------------------------------

if !get(g:, 'ddg_no_mappings', 0)
  if !hasmapto('<Plug>(ddg-search-word)', 'n')
    nmap <Leader>dg <Plug>(ddg-search-word)
  endif
  if !hasmapto('<Plug>(ddg-search-visual)', 'x')
    xmap <Leader>dg <Plug>(ddg-search-visual)
  endif
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo
