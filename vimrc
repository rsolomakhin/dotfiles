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

syntax on
filetype plugin indent on

call plug#begin('~/.vim/plugged')
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all --no-update-rc'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/ListToggle'
Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --gocode-completer --tern-completer'}
Plug 'w0ng/vim-hybrid'
if filereadable(glob("~/chrome/src/tools/vim/ninja-build.vim"))
  Plug '~/chrome/src/tools/vim/mojom'
  source ~/chrome/src/tools/vim/filetypes.vim
  source ~/chrome/src/tools/vim/ninja-build.vim
endif
call plug#end()

" vim-hybrid
set t_Co=256
set background=dark
colorscheme hybrid

" YouCompleteMe
let g:ycm_global_ycm_extra_conf =
      \ expand('~/chrome/src/tools/vim/chromium.ycm_extra_conf.py')

" vim-fugitive
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" fzf.vim
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>t :GFiles<CR>

" vim-codefmt
nnoremap <leader>= :FormatLines<CR>

" http://eclim.org/vim/code_completion.html
let g:EclimCompletionMethod = 'omnifunc'

let &colorcolumn='+' . join(range(1, 1), ',+')
set autoindent
set backspace=indent,eol,start
set completeopt= " Turn off YCM's previews on top
set cursorline
set encoding=utf-8
set expandtab
set nofixeol
set formatoptions+=j " Remove comment characters when joining lines.
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L
set hidden
set ignorecase
set incsearch
set laststatus=2
set nocompatible
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
set tabstop=2
set timeout
set timeoutlen=1000
set ttimeoutlen=0
set viminfo='100,<100,:100,s100,h,%,n~/.viminfo
set wildmenu

if has('win32')
  set spellfile=~/vimfiles/spell/en.utf-8.add
  set directory=~/vimfiles/swap,.
else
  set spellfile=~/.vim/spell/en.utf-8.add
  set directory=~/.vim/swap,.
endif

augroup custom
  autocmd!
  autocmd BufRead,BufNewFile /tmp/cl_description* set filetype=gitcommit

  autocmd FileType cpp,c,html,javascript,sh,zsh,vim,python,go,dosbatch,proto
        \ setlocal textwidth=80

  autocmd FileType cpp nnoremap <C-]> :YcmCompleter GoTo<CR>
  autocmd FileType cpp setlocal cinoptions=N-s,g.5s,h.5s

  autocmd FileType gitcommit setlocal spell
  autocmd FileType gitcommit setlocal textwidth=72

  autocmd FileType java setlocal shiftwidth=4
  autocmd FileType java setlocal softtabstop=4
  autocmd FileType java setlocal tabstop=4
  autocmd FileType java setlocal textwidth=100

  autocmd FileType xml setlocal shiftwidth=4
  autocmd FileType xml setlocal softtabstop=4
  autocmd FileType xml setlocal tabstop=4
  autocmd FileType xml setlocal textwidth&

  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup end
