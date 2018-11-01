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

call plug#begin('~/.vim/plugged')
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all --no-update-rc'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'tpope/vim-dispatch'
Plug 'w0ng/vim-hybrid'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/ListToggle'
if v:version >= 800 && has('python')
  Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --gocode-completer --tern-completer'}
endif
if filereadable(glob("~/chrome/src/tools/vim/ninja-build.vim"))
  Plug '~/chrome/src/tools/vim/mojom'
  source ~/chrome/src/tools/vim/filetypes.vim
  source ~/chrome/src/tools/vim/ninja-build.vim
endif
call plug#end()

" vim-hybrid
let g:hybrid_custom_term_colors = 0
let g:hybrid_reduced_contrast = 0
if filereadable(glob("~/.godark"))
  set bg=dark
else
  set bg=light
endif
colorscheme hybrid

" vim-prettier
let g:prettier#autoformat = 0

" YouCompleteMe
let g:ycm_global_ycm_extra_conf =
      \ expand('~/chrome/src/tools/vim/chromium.ycm_extra_conf.py')

" fzf.vim
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>t :GFiles<CR>

" glaive
call glaive#Install()

" vim-codefmt
" \== FormatLines
" \=b FormatBuffer
Glaive codefmt plugin[mappings]

" http://eclim.org/vim/code_completion.html
let g:EclimCompletionMethod = 'omnifunc'

" tidy
command! Thtml :%!tidy -config tidyconfig.txt -q --show-errors 0
command! ThtmlWithoutConfig :%!tidy -q --show-errors 0 -indent -wrap 80 -omit --tidy-mark false -access 3 -clean

" Don't highlight the matching paren.
let loaded_matchparen = 1

let &colorcolumn='+' . join(range(1, 1), ',+')
runtime macros/matchit.vim
set autoindent
set backspace=indent,eol,start
set completeopt= " Turn off YCM's previews on top
set cursorline
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
set path+=third_party/WebKit/Source
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

  autocmd FileType
        \ cpp,c,html,javascript,sh,zsh,vim,python,go,dosbatch,proto,objcpp,
        \haskell setlocal textwidth=80

  autocmd FileType cpp nnoremap <C-]> :YcmCompleter GoTo<CR>
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

  autocmd FileType bzl AutoFormatBuffer buildifier
  "autocmd FileType c,cpp,proto AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType python AutoFormatBuffer yapf

  "autocmd BufWritePre *.css,*.json,*.js Prettier

  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup end
