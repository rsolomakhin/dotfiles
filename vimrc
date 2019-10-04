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

if filereadable(expand("~/chrome/src/tools/vim/ninja-build.vim"))
  source ~/chrome/src/tools/vim/ninja-build.vim
endif

" fzf.vim
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>t :GFiles<CR>

set autoindent
set backspace=indent,eol,start
set completeopt= " Turn off YCM's previews on top
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
set nocompatible
set nofixeol
set nojoinspaces
set nonumber
set nospell
set ruler
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

augroup custom
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

  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup end
