" Copyright 2015 Rouslan Solomakhin
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

silent! if plug#begin()
  if !has("win32")
    Plug 'junegunn/fzf', {
          \ 'dir': '~/.fzf',
          \ 'do': 'yes \| ./install' }
    if !has("win32unix")
      Plug 'Valloric/YouCompleteMe', {
            \ 'do': './install.sh --clang-completer' }
    endif
  endif
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-unimpaired'
  call plug#end()
endif

let &colorcolumn="+" . join(range(1, 300), ",+")
set autoindent
set backspace=indent,eol,start
set completeopt=
set encoding=utf-8
set expandtab
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set nocompatible
set nojoinspaces
set nospell
set ruler
set shiftwidth=2
set showcmd
set showmode
set smartcase
set smartindent
set smarttab
set softtabstop=2
set tabstop=2
set timeout
set timeoutlen=1000
set ttimeoutlen=0
set viminfo='100,<100,:20,%,n~/.viminfo
set wildmenu

set statusline=%<%f\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}
      \\ %m%r\ %=%-14.(%l,%c%V%)\ %P

if !has("win32")
  let g:ycm_global_ycm_extra_conf =
        \ expand('~/chrome/src/tools/vim/chromium.ycm_extra_conf.py')
  let g:ycm_complete_in_strings = 0

  " Shortcuts from https://github.com/junegunn/fzf/wiki/Examples-(vim)
  " \-b - buffers.
  " \-t - find files.
  " \-r - recent files.
  " \-s - search text within all open files.

  " List of buffers
  function! BufList()
    redir => ls
    silent ls
    redir END
    return split(ls, '\n')
  endfunction

  function! BufOpen(e)
    execute 'buffer '. matchstr(a:e, '^[ 0-9]*')
  endfunction

  nnoremap <silent> <Leader>b :call fzf#run({
        \ 'source' : reverse(BufList()),
        \ 'sink'   : function('BufOpen'),
        \ 'options': '+m',
        \ 'down'   : '40%' })<CR>

  nnoremap <silent> <Leader>t :FZF<CR>

  nnoremap <silent> <Leader>r :call fzf#run({
        \ 'source': v:oldfiles,
        \ 'sink' : 'e ',
        \ 'options' : '-m' })<CR>

  function! s:line_handler(l)
    let keys = split(a:l, ':\t')
    exec 'buf ' . keys[0]
    exec keys[1]
    normal! ^zz
  endfunction

  function! s:buffer_lines()
    let res = []
    for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
      call extend(res, map(getbufline(b,0,"$"),
            \ 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
    endfor
    return res
  endfunction

  nnoremap <silent> <Leader>s :call fzf#run({
        \ 'source' : <sid>buffer_lines(),
        \ 'sink'   : function('<sid>line_handler'),
        \ 'options': '--extended --nth=3..',
        \ 'down'   : '60%' })<CR>
  set directory=~/.vim/swap,.
  set guifont=Ubuntu\ Mono\ 12
else
  set directory=~/vimfiles/swap,.
  set guifont=Consolas:h12
endif

if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  au BufNewFile,BufRead */WebKit/*
        \ setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth&
  au BufReadPost * call setpos(".", getpos("'\""))
endif

" Colors from http://pln.jonas.me/xterm-colors
hi DiffAdd               ctermbg=193 guibg=#d7ffaf
hi DiffChange            ctermbg=229 guibg=#ffffaf
hi DiffDelete            ctermbg=223 guibg=#ffd7af
hi DiffText              ctermbg=228 guibg=#ffff87
hi ColorColumn           ctermbg=255 guibg=#eeeeee
hi SignColumn            ctermbg=255 guibg=#eeeeee
hi StatusLine            ctermfg=67  guifg=#5f87af
