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
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
  endif
  if !has("win32") && !has("win32unix") && v:version >=703 && has("patch584")
    Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-completer' }
  endif
  Plug 'jnurmine/Zenburn'
  Plug 'kien/ctrlp.vim'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-unimpaired'
  Plug 'vim-scripts/argtextobj.vim'
  call plug#end()
endif

" \-b - buffers.
nnoremap <silent> <Leader>b :CtrlPBuffer<CR>

" \-q - search quickfix list.
nnoremap <silent> <Leader>q :CtrlPQuickfix<CR>

" \-r - recent files.
nnoremap <silent> <Leader>r :CtrlPMRU<CR>

" \-s - search text within all open files.
nnoremap <silent> <Leader>s :CtrlPLine<CR>

" \-t - find files.
nnoremap <silent> <Leader>t :FZF<CR>

command! ChromiumSource :exec '!google-chrome-unstable
      \ https://code.google.com/p/chromium/codesearch\#chromium/src/%'

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
set mouse=a
set nocompatible
set nocursorline
set nojoinspaces
set nospell
set number
set ruler
set shiftwidth=2
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

if !has("win32")
  let g:ycm_global_ycm_extra_conf =
        \ expand('~/chrome/src/tools/vim/chromium.ycm_extra_conf.py')
  set directory=~/.vim/swap,.
  set guifont=Ubuntu\ Mono\ 12
else
  set directory=~/vimfiles/swap,.
  set guifont=Consolas:h12:cANSI
endif

if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  au BufNewFile,BufRead */WebKit/*
        \ setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth&
  au BufReadPost * call setpos(".", getpos("'\""))
endif

if $TERM == "xterm"
  set t_Co=256
endif
colorscheme zenburn
