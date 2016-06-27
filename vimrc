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

if !has('win32unix')
  execute pathogen#infect()
endif

syntax on
filetype plugin indent on

let &colorcolumn='+' . join(range(1, 1), ',+')
set autoindent
set backspace=indent,eol,start
set completeopt= " Turn off YCM's previews on top
set encoding=utf-8
set expandtab
set formatoptions+=j " Remove comment characters when joining lines.
set hidden
set ignorecase
set incsearch
set laststatus=2
set nocompatible
set nocursorline
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

" Format inside of the text paragraph or a block of code.
nnoremap<leader> f gqip<CR>

if has("win32")
  set spellfile=~/vimfiles/spell/en.utf-8.add
  set directory=~/vimfiles/swap,.
else
  set spellfile=~/.vim/spell/en.utf-8.add
  set directory=~/.vim/swap,.
endif

set t_Co=256
set background=dark

if !has('win32unix')
  " Colorschemes
  colorscheme hybrid
  function! ToggleLightDarkBackground()
    if (&background == "dark")
      set background=light
      let g:solarized_termcolors=256
      colorscheme solarized
    else
      set background=dark
      colorscheme hybrid
    endif
  endfunction

  " YCM
  let g:ycm_global_ycm_extra_conf =
        \ expand('~/chrome/src/tools/vim/chromium.ycm_extra_conf.py')

  " vim-fugitive
  set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

  " Syntastic
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
  let g:syntastic_auto_loc_list = 0
  let g:syntastic_check_on_wq = 0
  let g:syntastic_javascript_checkers = ['eslint']
  let g:syntastic_javascript_eslint_args = '-c google --env browser'
  let g:syntastic_mode_map = {
        \  'mode': 'passive',
        \  'active_filetypes': [],
        \  'passive_filetypes': []}
  let s:syntastic_mode='passive'
  function! ToggleSyntastic()
    if (s:syntastic_mode == 'passive')
      echom 'syntastic on'
      let s:syntastic_mode='active'
      call SyntasticCheck()
    else
      echom 'syntastic off'
      let s:syntastic_mode='passive'
      call SyntasticReset()
    endif
  endfunction

  " FZF
  function! s:line_handler(l)
    let keys = split(a:l, ':\t')
    exec 'buf' keys[0]
    exec keys[1]
    normal! ^zz
  endfunction
  function! s:buffer_lines()
    let res = []
    for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
      call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
    endfor
    return res
  endfunction
  command! FZFMru call fzf#run({
        \  'source':  v:oldfiles,
        \  'sink':    'e',
        \  'options': '-m -x +s',
        \  'down':    '40%'})

  nnoremap <leader>b :call ToggleLightDarkBackground()<CR>
  nnoremap <leader>r :FZFMru<CR>
  nnoremap <leader>s :call ToggleSyntastic()<CR>
  nnoremap <leader>t :FZF<CR>
endif

nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap [l :lprevious<CR>
nnoremap <leader>l :lwindow<CR>
nnoremap <leader>q :cwindow<CR>

if filereadable(glob("~/chrome/src/tools/vim/ninja-build.vim"))
  source ~/chrome/src/tools/vim/ninja-build.vim
endif

if filereadable(glob("~/chrome/src/tools/vim/filetypes.vim"))
  source ~/chrome/src/tools/vim/filetypes.vim
endif

augroup custom
  autocmd!
  autocmd BufRead,BufNewFile *.idl set filetype=widl
  autocmd BufRead,BufNewFile .tern-project set filetype=json
  autocmd BufRead,BufNewFile /tmp/cl_description* set filetype=gitcommit

  autocmd FileType cpp,c,html,javascript,sh,zsh,vim,python,go,dosbatch,proto
        \ setlocal textwidth=80

  autocmd FileType cpp nnoremap <C-]> :YcmCompleter GoTo<CR>
  autocmd FileType cpp setlocal cinoptions=N-s,g.5s,h.5s
  autocmd FileType cpp setlocal formatprg=clang-format\ -style=Chromium

  autocmd FileType gitcommit setlocal spell
  autocmd FileType gitcommit setlocal textwidth=72

  autocmd FileType java setlocal shiftwidth=4
  autocmd FileType java setlocal softtabstop=4
  autocmd FileType java setlocal tabstop=4
  autocmd FileType java setlocal textwidth=100

  autocmd BufNewFile,BufRead */WebKit/* setlocal shiftwidth=4
  autocmd BufNewFile,BufRead */WebKit/* setlocal softtabstop=4
  autocmd BufNewFile,BufRead */WebKit/* setlocal tabstop=4
  autocmd BufNewFile,BufRead */WebKit/* setlocal textwidth&
  autocmd BufNewFile,BufRead */WebKit/* setlocal
        \ formatprg=clang-format\ -style=WebKit

  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup end
