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
  Plug 'bling/vim-airline'
  Plug 'edkolev/promptline.vim'
  Plug 'edkolev/tmuxline.vim'
  Plug 'kien/ctrlp.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-unimpaired'
  Plug 'vim-scripts/argtextobj.vim'
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

let g:promptline_preset = {
      \'a': [ '$(print INSERT)' ],
      \'b': [ promptline#slices#cwd() ],
      \'c': [ promptline#slices#vcs_branch() ],
      \'options': {
      \'left_sections': ['a', 'b', 'c' ],
      \'right_sections': []}}
let g:tmuxline_preset = {
      \'b'    : '#(whoami)',
      \'c'    : '#h',
      \'win'  : '#I #W',
      \'cwin' : '#I #W'}

let g:airline_powerline_fonts = 1

if !has("win32")
  let g:ycm_global_ycm_extra_conf =
        \ expand('~/chrome/src/tools/vim/chromium.ycm_extra_conf.py')
  set directory=~/.vim/swap,.
  set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 12
else
  set directory=~/vimfiles/swap,.
  set guifont=Ubuntu_Mono_derivative_Powerlin:h12:cANSI
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
