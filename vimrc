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

let &colorcolumn='+' . join(range(1, 1), ',+')
set autoindent
set backspace=indent,eol,start
set completeopt=
set encoding=utf-8
set expandtab
set guioptions=
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set mouse=
set nocompatible
set nocursorline
set nojoinspaces
set nonumber
set nospell
set ruler
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

silent! if plug#begin()
  if !has("win32")
    Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': 'yes \| ./install'}
  else
    Plug 'kien/ctrlp.vim', {'on': ['CtrlPBuffer', 'CtrlPMRU', 'CtrlP']}
  endif

  if !has("win32") && !has("win32unix") && v:version >=703 && has("patch584")
    Plug 'Valloric/YouCompleteMe',
          \ {'do': './install.sh --clang-completer --gocode-completer'}
    let g:ycm_global_ycm_extra_conf =
          \ expand('~/chrome/src/tools/vim/chromium.ycm_extra_conf.py')
  endif

  Plug 'google/vim-maktaba' | Plug 'google/vim-glaive' |
        \ Plug 'google/vim-codefmt'

  " Colorschemes
  Plug 'altercation/vim-colors-solarized'
  Plug 'jnurmine/Zenburn'
  Plug 'nanotech/jellybeans.vim'
  Plug 'sjl/badwolf'
  Plug 'w0ng/vim-hybrid'

  Plug 'ntpeters/vim-better-whitespace'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-fugitive'

  Plug 'fatih/vim-go'
  if has("win32")
    Plug 'Blackrush/vim-gocode'
  endif

  call plug#end()
endif

" FZF/ctrlp.vim
if !has("win32")
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
  nnoremap <silent> <Leader>t :FZF<CR>
else
  nnoremap <Leader>b :CtrlPBuffer<CR>
  nnoremap <Leader>r :CtrlPMRU<CR>
  nnoremap <Leader>t :CtrlP<CR>
endif

" Colorscheme
try
  colorscheme hybrid
catch
endtry

" vim-better-whitespace
highlight ExtraWhitespace ctermbg=red

" vim-codefmt
if exists("*glaive#Install")
  call glaive#Install()
  Glaive codefmt plugin[mappings]
endif

" vim-fugitive
if exists("*fugitive#statusline")
  set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
endif

command! ChromiumSource :exec '!google-chrome-unstable
      \ https://code.google.com/p/chromium/codesearch\#chromium/src/%'

augroup custom
  autocmd!
  autocmd BufRead,BufNewFile *.DEPS set filetype=python
  autocmd BufRead,BufNewFile *.gypi set filetype=python
  autocmd BufRead,BufNewFile *.gyp  set filetype=python
  autocmd BufRead,BufNewFile /tmp/cl_description* set filetype=gitcommit

  autocmd FileType cpp,c,html,javascript,sh,zsh,vim,python,go
        \ setlocal textwidth=80
  autocmd FileType cpp,c,html,javascript,java,python
        \ if exists(":CrBuild") != 2 && isdirectory(expand('~/chrome/src'))
        \ | source ~/chrome/src/tools/vim/ninja-build.vim
        \ | endif
  autocmd FileType cpp nnoremap <buffer><silent> <C-]> :YcmCompleter GoTo<CR>
  autocmd FileType cpp setlocal cinoptions=N-s,g.5s,h.5s
  autocmd FileType gitcommit setlocal spell
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType java let b:codefmt_formatter = 'clang-format'
  autocmd FileType java setlocal shiftwidth=4
  autocmd FileType java setlocal softtabstop=4
  autocmd FileType java setlocal tabstop=4
  autocmd FileType java setlocal textwidth=100

  autocmd BufNewFile,BufRead */WebKit/* setlocal shiftwidth=4
  autocmd BufNewFile,BufRead */WebKit/* setlocal softtabstop=4
  autocmd BufNewFile,BufRead */WebKit/* setlocal tabstop=4
  autocmd BufNewFile,BufRead */WebKit/* setlocal textwidth&

  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup end
