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

setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal textwidth=100

if !exists("clang_format_loaded") && isdirectory(expand('~/chrome'))
  source ~/chrome/src/tools/vim/clang-format.vim
  let clang_format_loaded = 1
endif
