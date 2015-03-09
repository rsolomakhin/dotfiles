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
          \ 'do': 'yes \| ./install',
          \ 'on': 'FZF' }
    Plug 'Valloric/YouCompleteMe', {
          \ 'do': './install.sh --clang-completer',
          \ 'for': ['c', 'cpp'] }
  endif
  Plug 'airblade/vim-gitgutter'
  Plug 'junegunn/vim-oblique'
  Plug 'junegunn/vim-peekaboo'
  Plug 'junegunn/vim-pseudocl'
  Plug 'tpope/vim-fugitive'
  call plug#end()
endif

set autoindent
set backspace=indent,eol,start
set colorcolumn=+1
set encoding=utf-8
set expandtab
set hidden
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
set statusline=%<%f\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}
      \\ %m%r\ %=%-14.(%l,%c%V%)\ %P
set tabstop=2
set textwidth=80
set wildmenu

au BufNewFile,BufRead */WebKit/*
      \ setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth&

au BufReadPost *
      \ call setpos(".", getpos("'\""))

if has("win32")
  set viminfo='10,\"100,:20,%,n~/_viminfo
  set directory=~/vimfiles/swap,.
else
  set viminfo='10,\"100,:20,%,n~/.viminfo
  set directory=~/.vim/swap,.
endif

if isdirectory(expand('~/chrome'))
  source ~/chrome/src/tools/vim/clang-format.vim
  source ~/chrome/src/tools/vim/filetypes.vim
endif

let g:gitgutter_highlight_lines = 1
let g:ycm_global_ycm_extra_conf =
      \ expand('~/chrome/src/tools/vim/chromium.ycm_extra_conf.py')

" Colors from http://pln.jonas.me/xterm-colors
hi DiffAdd               ctermbg=193 guibg=#d7ffaf
hi DiffChange            ctermbg=229 guibg=#ffffaf
hi DiffDelete            ctermbg=223 guibg=#ffd7af
hi DiffText              ctermbg=228 guibg=#ffff87
hi GitGutterAdd          ctermbg=255 guibg=#eeeeee ctermfg=2 guifg=#008000
hi GitGutterChange       ctermbg=255 guibg=#eeeeee ctermfg=3 guifg=#808000
hi GitGutterDelete       ctermbg=255 guibg=#eeeeee ctermfg=1 guifg=#800000
hi ColorColumn           ctermbg=255 guibg=#eeeeee
hi SignColumn            ctermbg=255 guibg=#eeeeee

if has("gui_running")
  if has("win32")
    set guifont=Source\ Code\ Pro:h10
  else
    set guifont=Source\ Code\ Pro\ 10
  endif
endif
