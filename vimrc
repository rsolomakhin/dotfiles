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

let &colorcolumn='+' . join(range(1, 300), ',+')
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
set showcmd
set smartcase
set smartindent
set smarttab
set softtabstop=2
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
set tabstop=2
set timeout
set timeoutlen=1000
set ttimeoutlen=0
set viminfo='100,<100,:100,s100,h,%,n~/.viminfo
set wildmenu

if $TERM == "xterm"
  set t_Co=256
endif

if has("win32")
  set directory=~/vimfiles/swap,.
  set guifont=Consolas:h11:cANSI
else
  set directory=~/.vim/swap,.
  set guifont=Ubuntu\ Mono\ 12
endif

let g:ycm_global_ycm_extra_conf =
      \ expand('~/chrome/src/tools/vim/chromium.ycm_extra_conf.py')

silent! if plug#begin()
  if !has("win32")
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
  else
    Plug 'kien/ctrlp.vim'
  endif
  if !has("win32") && !has("win32unix") && v:version >=703 && has("patch584")
    Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-completer' }
  endif
  Plug 'altercation/vim-colors-solarized'
  Plug 'google/vim-codefmt'
  Plug 'google/vim-glaive'
  Plug 'google/vim-maktaba'
  Plug 'jnurmine/Zenburn'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'scrooloose/nerdcommenter'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-fugitive'
  call plug#end()
endif

call glaive#Install()
Glaive codefmt plugin[mappings]

colorscheme zenburn

if has("win32")
  nnoremap <Leader>b :CtrlPBuffer<CR>
  nnoremap <Leader>q :CtrlPQuickfix<CR>
  nnoremap <Leader>r :CtrlPMRU<CR>
  nnoremap <Leader>s :CtrlPLine<CR>
else
  function! s:buflist()
    redir => ls
    silent ls
    redir END
    return split(ls, '\n')
  endfunction
  function! s:bufopen(e)
    execute 'buffer' matchstr(a:e, '^[ 0-9]*')
  endfunction
  nnoremap <silent> <Leader>b :call fzf#run({
        \ 'source': reverse(<sid>buflist()),
        \ 'down': '20%',
        \ 'sink': function('<sid>bufopen')})<CR>
  nnoremap <silent> <Leader>r :call fzf#run({
        \ 'source': v:oldfiles,
        \ 'down': '20%',
        \ 'sink': 'e '})<CR>
  nnoremap <silent> <Leader>t :call fzf#run({
        \ 'source': 'find -L . \(
        \     -path "*/\.*" -o
        \     -path "\./out*" -o
        \     -fstype "dev" -o
        \     -fstype "proc"
        \   \) -prune -o
        \   -type f -print -o
        \   -type d -print -o
        \   -type l -print',
        \ 'down': '20%',
        \ 'sink': 'e '})<CR>
endif

if exists(":CrBuild") != 2 && isdirectory(expand('~/chrome/src'))
  source ~/chrome/src/tools/vim/ninja-build.vim
endif

if exists(":ChromiumSource") != 2
  command ChromiumSource :exec '!google-chrome-unstable
        \ https://code.google.com/p/chromium/codesearch\#chromium/src/%'
endif

if !exists("autocommands_loaded")
  let autocommands_loaded = 1

  au FileType cpp nnoremap <buffer><silent> <C-]> :YcmCompleter GoTo<CR>
  au FileType cpp setlocal textwidth=80 cinoptions=N-s,g.5s,h.5s
  au FileType c setlocal textwidth=80
  au FileType gitcommit setlocal textwidth=72 spell
  au FileType html setlocal textwidth=80
  au FileType java let b:codefmt_formatter = 'clang-format'
  au FileType javascript setlocal textwidth=80
  au FileType java setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=100
  au FileType sh setlocal textwidth=80
  au FileType vim setlocal textwidth=80
  au FileType zsh setlocal textwidth=80

  au BufNewFile,BufRead */WebKit/*
        \ setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth&

  au BufReadPost * call setpos(".", getpos("'\""))
endif
