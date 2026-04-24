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

if not exist %USERPROFILE%\src mkdir %USERPROFILE%\src ^
  || echo "Cannot create src dir" && exit /b 1
if not exist %USERPROFILE%\vimfiles mkdir %USERPROFILE%\vimfiles ^
  || echo "Cannot create vim dir" && exit /b 1
if not exist %USERPROFILE%\vimfiles\spell mkdir %USERPROFILE%\vimfiles\spell ^
  || echo "Cannot create vim spell dir" && exit /b 1
if not exist %USERPROFILE%\vimfiles\swap mkdir %USERPROFILE%\vimfiles\swap ^
  || echo "Cannot create vim swap dir" && exit /b 1
if not exist %USERPROFILE%\vimfiles\autoload mkdir %USERPROFILE%\vimfiles\autoload ^
  || echo "Cannot create vim autoload dir" && exit /b 1

pushd %~dp0 ^
  || echo "Cannot go into the directory of the install script" && exit /b 1

powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni $HOME/vimfiles/autoload/plug.vim -Force" || echo "Cannot download plug.vim" && exit /b 1
if exist %USERPROFILE%\src\env.bat del /q %USERPROFILE%\src\env.bat
mklink %USERPROFILE%\src\env.bat %~dp0env.bat ^
  || echo "Cannot link env.bat" && exit /b 1
if exist %USERPROFILE%\.cvsignore del /q %USERPROFILE%\.cvsignore
mklink %USERPROFILE%\.cvsignore %~dp0..\src\cvsignore ^
  || echo "Cannot link cvsignore" && exit /b 1
if exist %USERPROFILE%\vimfiles\coc.vim del /q %USERPROFILE%\vimfiles\coc.vim
mklink %USERPROFILE%\vimfiles\coc.vim %~dp0..\src\vim\coc.vim ^
  || echo "Cannot link coc config" && exit /b 1
if exist %USERPROFILE%\.vimrc del /q %USERPROFILE%\.vimrc
mklink %USERPROFILE%\.vimrc %~dp0..\src\vimrc ^
  || echo "Cannot link vim config" && exit /b 1

:: Parse arguments for Git identity
:parse_args
if "%~1"=="" goto end_parse
if "%~1"=="--name" (
    set GIT_NAME=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="--email" (
    set GIT_EMAIL=%~2
    shift
    shift
    goto parse_args
)
shift
goto parse_args
:end_parse

if not exist %USERPROFILE%\.gitconfig.user (
    if "%GIT_NAME%"=="" (
        set /p GIT_NAME="Enter your Git name: "
    )
    if "%GIT_EMAIL%"=="" (
        set /p GIT_EMAIL="Enter your Git email: "
    )
    if not "%GIT_NAME%"=="" (
        if not "%GIT_EMAIL%"=="" (
            echo [user]> %USERPROFILE%\.gitconfig.user
            echo 	name = %GIT_NAME%>> %USERPROFILE%\.gitconfig.user
            echo 	email = %GIT_EMAIL%>> %USERPROFILE%\.gitconfig.user
            echo Created %USERPROFILE%\.gitconfig.user with your identity.
        )
    )
)

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

git.exe submodule update --init --recursive ^
  || echo "Cannot update submodules" && exit /b 1

popd ^
  || echo "Cannot return to original directory" && exit /b 1
