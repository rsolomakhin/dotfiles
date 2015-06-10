:: Copyright 2015 Rouslan Solomakhin
::
:: Licensed under the Apache License, Version 2.0 (the "License")
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::     http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.

copy /Y drmemory-env.bat c:\src\
copy /Y env.bat          c:\src\

where git.exe > NUL 2>&1
if errorlevel 1 (
  pushd c:\src
  call env.bat
  popd
  git.exe pull --rebase
  install.bat
)

pushd c:\src
call env.bat
popd

pushd c:\src\dotfiles\
mkdir %APPDATA%\Console\
copy  /Y third_party\console2\console.xml %APPDATA%\Console\
copy  /Y     cvsignore    %USERPROFILE%\.cvsignore
copy  /Y     emacs        %USERPROFILE%\.emacs
copy  /Y     vimrc        %USERPROFILE%\.vimrc
copy  /Y     zshrc        %USERPROFILE%\.zshrc
xcopy /Y/S/I emacs.d      %USERPROFILE%\.emacs.d
xcopy /Y/S/I third_party  %USERPROFILE%\.third_party
xcopy /Y/S/I vim          %USERPROFILE%\vimfiles
popd

git.exe config --global --replace-all alias.br branch
git.exe config --global --replace-all alias.brv "branch -vv"
git.exe config --global --replace-all alias.can "commit -a --amend --no-edit"
git.exe config --global --replace-all alias.co checkout
git.exe config --global --replace-all alias.ls ls-files
git.exe config --global --replace-all alias.st status
git.exe config --global --replace-all alias.sub "submodule update --init --recursive"
git.exe config --global --replace-all color.ui auto
git.exe config --global --replace-all core.autocrlf false
git.exe config --global --replace-all core.excludesfile %USERPROFILE%\.cvsignore
git.exe config --global --replace-all core.filemode false
git.exe config --global --replace-all http.cookiefile %USERPROFILE%\.gitcookies
git.exe config --global --replace-all push.default simple
git.exe config --global --replace-all user.name "Rouslan Solomakhin"
git.exe config --global --get user.email > NUL 2>&1
if errorlevel 1 (
  git.exe config --global --replace-all user.email "rouslan.solomakhin@gmail.com"
)
git.exe config --replace-all user.email "rouslan.solomakhin@gmail.com"

pushd %USERPROFILE%\.emacs.d\
emacs.exe -Q --script %USERPROFILE%\.third_party\cask\cask-cli.el -- install
popd

call vim -c ":PlugInstall" -c ":qa"
