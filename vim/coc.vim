" Copyright 2026 Rouslan Solomakhin
"
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at
"
"     http://www.apache.org/licenses/LICENSE-2.0
"
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.

" Only configure if coc.nvim was registered with vim-plug.
if !has_key(g:plugs, 'coc.nvim')
  finish
endif

" --- Mappings ---

" Navigate diagnostics (errors/warnings).
" [g goes to previous diagnostic, ]g goes to next.
nmap [g <Plug>(coc-diagnostic-prev)
nmap ]g <Plug>(coc-diagnostic-next)

" Navigate to locations.
" <leader>d goes to definition of symbol under cursor.
nmap <leader>d <Plug>(coc-definition)
" <leader>e shows references to symbol under cursor.
nmap <leader>e <Plug>(coc-references)

" Code formatting.
" <leader>f formats the selected code.
nnoremap <leader>f <Plug>(coc-format-selected)

" Hover documentation.
" <leader>k shows documentation for symbol under cursor.
nnoremap <silent> <leader>k :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('definitionHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Auto-completion.
" Tab accepts the inline or dropdown suggestion if visible.
" Fallback to normal Tab behavior if no suggestion is visible.
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#select_confirm() : coc#inline#visible() ? coc#inline#accept() : "<TAB>"

" --- Auto commands ---

" Python specific settings.
augroup CocPythonSettings
  autocmd!
  " Use CocAction('formatSelected') for formatexpr to allow gq to format code.
  autocmd FileType python setlocal formatexpr=CocAction('formatSelected')
augroup end
