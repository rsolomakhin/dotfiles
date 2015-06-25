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

@echo off
if not exist %SYSTEMDRIVE%\src mkdir %SYSTEMDRIVE%\src ^
  || echo "Cannot create src dir" && exit /b 1

pushd %~dp0 ^
  || echo "Cannot go into the directory of the install script" && exit /b 1

copy /Y drmemory-env.bat %SYSTEMDRIVE%\src\ ^
  || echo "Cannot copy drmemory-env.bat" && exit /b 1
copy /Y env.bat %SYSTEMDRIVE%\src\ ^
  || echo "Cannot copy env.bat" && exit /b 1

copy /Y ..\bash_profile %USERPROFILE%\.bash_profile ^
  || echo "Cannot copy bash_profile" && exit /b 1
copy /Y ..\bashrc %USERPROFILE%\.bashrc ^
  || echo "Cannot copy bashrc" && exit /b 1
copy /Y ..\cvsignore %USERPROFILE%\.cvsignore ^
  || echo "Cannot copy cvsignore" && exit /b 1
copy /Y ..\vimrc %USERPROFILE%\.vimrc ^
  || echo "Cannot copy vimrc" && exit /b 1
copy /Y ..\zshrc %USERPROFILE%\.zshrc ^
  || echo "Cannot copy zhsrc" && exit /b 1
xcopy /Y/S/I ..\emacs.d %USERPROFILE%\.emacs.d ^
  || echo "Cannot copy emacs.d dir" && exit /b 1
xcopy /Y/S/I ..\vim %USERPROFILE%\vimfiles ^
  || echo "Cannot copy vimfiles dir" && exit /b 1

popd ^
  || echo "Cannot return to original directory" && exit /b 1

git.exe config --global --replace-all alias.br branch ^
  || echo "Cannot set git br alias" && exit /b 1
git.exe config --global --replace-all alias.brv "branch -vv" ^
  || echo "Cannot set git brv alias" && exit /b 1
git.exe config --global --replace-all alias.can "commit -a --amend --no-edit" ^
  || echo "Cannot set git can alias" && exit /b 1
git.exe config --global --replace-all alias.co checkout ^
  || echo "Cannot set git co alias" && exit /b 1
git.exe config --global --replace-all alias.ls ls-files ^
  || echo "Cannot set git ls alias" && exit /b 1
git.exe config --global --replace-all alias.st status ^
  || echo "Cannot set git st alias" && exit /b 1
git.exe config --global --replace-all alias.sub ^
  "submodule update --init --recursive" ^
  || echo "Cannot set git sub alias" && exit /b 1
git.exe config --global --replace-all color.ui auto ^
  || echo "Cannot set git color preference" && exit /b 1
git.exe config --global --replace-all core.autocrlf false ^
  || echo "Cannot set git line termination preference" && exit /b 1
git.exe config --global --replace-all ^
  core.excludesfile %USERPROFILE%\.cvsignore ^
  || echo "Cannot set git excludes file" && exit /b 1
git.exe config --global --replace-all core.filemode false ^
  || echo "Cannot set git file mode preference" && exit /b 1
git.exe config --global --replace-all ^
  http.cookiefile %USERPROFILE%\.gitcookies ^
  || echo "Cannot set git cookie file location" && exit /b 1
git.exe config --global --replace-all push.default simple ^
  || echo "Cannot set git push preferences" && exit /b 1
git.exe config --global --replace-all user.name "Rouslan Solomakhin" ^
  || echo "Cannot set git user name preference" && exit /b 1
git.exe config --global --get user.email
if errorlevel 1 (
  git.exe config --global --replace-all user.email ^
    "rouslan.solomakhin@gmail.com" ^
    || echo "Cannot set global git email address" && exit /b 1
)
git.exe config --replace-all user.email "rouslan.solomakhin@gmail.com" ^
  || echo "Cannot set this repository's git email address" && exit /b 1

emacs.exe -nw -f install-my-packages --kill ^
  || echo "Cannot install emacs packages" && exit /b 1
vim.exe -c ":PlugInstall" -c ":qa" ^
  || echo "Cannot install vim plugins" && exit /b 1
