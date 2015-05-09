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

copy /Y env.bat c:\src\
call c:\src\env.bat

pushd c:\src\dotfiles\
mkdir %APPDATA\Console\
copy /Y third_party\console2\console.xml %APPDATA%\Console\

copy  /Y     cvsignore    %USERPROFILE%\.cvsignore
copy  /Y     emacs        %USERPROFILE%\.emacs
copy  /Y     gitconfig    %USERPROFILE%\.gitconfig
copy  /Y     vimrc        %USERPROFILE%\.vimrc
copy  /Y     zshrc        %USERPROFILE%\.zshrc

xcopy /Y/S/I emacs.d      %USERPROFILE%\.emacs.d
xcopy /Y/S/I third_party  %USERPROFILE%\.third_party
xcopy /Y/S/I vim          %USERPROFILE%\vimfiles
popd

git config --global --replace-all alias.br branch
git config --global --replace-all alias.brv "branch -vv"
git config --global --replace-all alias.can "commit -a --amend --no-edit"
git config --global --replace-all alias.co checkout
git config --global --replace-all alias.ls ls-files
git config --global --replace-all alias.st status
git config --global --replace-all alias.sub "submodule update --init --recursive"
git config --global --replace-all color.ui true
git config --global --replace-all core.autocrlf false
git config --global --replace-all core.excludesfile %USERPROFILE%\.cvsignore
git config --global --replace-all core.filemode false
git config --global --replace-all http.cookiefile %USERPROFILE%\.gitcookies
git config --global --replace-all push.default simple
git config --global --replace-all user.name "Rouslan Solomakhin"

setlocal
pushd %USERPROFILE%\.emacs.d
cask install
popd
endlocal
