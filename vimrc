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

set nocompatible

" vim-plug.
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Local plugins.
let s:local_plugins = expand('~/.local-plugins.vimrc')
if filereadable(s:local_plugins)
  source ~/.local-plugins.vimrc
endif
call plug#end()

" Local config.
let s:local_vimrc = expand('~/.local.vimrc')
if filereadable(s:local_vimrc)
  source ~/.local.vimrc
endif

" fzf.vim.
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>t :Files<CR>

" Light gray color column to the right of textwidth.
let &colorcolumn='+' . join(range(1, 1), ',+')
highlight ColorColumn ctermbg=LightGray

" Same color for misspellings and error messages.
highlight! link SpellBad ErrorMsg

" Xterm cursor shape:
" 30 - blinking block
" 31 - blinking block also
" 32 - steady block
" 33 - blinking underline
" 34 - steady underline
" 35 - blinking bar
" 36 - steady bar
" Insert mode - blinking bar.
let &t_SI.="\x1b[\x35 q"
" Replace mode - blinking underline.
let &t_SR.="\x1b[\x33 q"
" Normal mode - steady block.
let &t_EI.="\x1b[\x32 q"

augroup FileFormatSettings
  autocmd!
  autocmd BufRead,BufNewFile /tmp/cl_description* set filetype=gitcommit

  autocmd FileType
        \ cpp,c,html,javascript,sh,zsh,vim,python,go,dosbatch,proto,objcpp,
        \haskell setlocal textwidth=80

  autocmd FileType cpp setlocal cinoptions=N-s,g.5s,h.5s

  autocmd FileType gitcommit setlocal spell
  autocmd FileType gitcommit setlocal textwidth=72

  autocmd FileType java setlocal shiftwidth=4
  autocmd FileType java setlocal softtabstop=4
  autocmd FileType java setlocal tabstop=4
  autocmd FileType java setlocal textwidth=100
  autocmd FileType java let b:codefmt_formatter = 'clang-format'

  autocmd FileType xml setlocal shiftwidth=4
  autocmd FileType xml setlocal softtabstop=4
  autocmd FileType xml setlocal tabstop=4
  autocmd FileType xml setlocal textwidth&

  autocmd FileType python setlocal shiftwidth=2
  autocmd FileType python setlocal softtabstop=2
  autocmd FileType python setlocal tabstop=2
  autocmd FileType python setlocal expandtab

  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup end

syntax on
filetype plugin indent on

set autoindent
set backspace=indent,eol,start
set directory=~/.vim/swap,.
set encoding=utf-8
set expandtab
set formatoptions+=j " Remove comment characters when joining lines.
set guioptions-=L
set guioptions-=m
set guioptions-=r
set guioptions-=T
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list listchars=tab:»\ 
set nofixeol
set nojoinspaces
set nonumber
set nospell
set nowrap " Do not soft wrap lines.
set ruler
set scrolloff=5 " Keep 5 lines above/below cursor.
set shiftround
set shiftwidth=2
set showcmd
set smartcase
set smartindent
set smarttab
set softtabstop=2
set spellfile=~/.vim/spell/en.utf-8.add
set tabstop=2
set viminfo='100,<100,:100,s100,h,%,n~/.viminfo
set wildmenu
