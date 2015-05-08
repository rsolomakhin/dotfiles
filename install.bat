copy  /Y     cvsignore    %USERPROFILE%\.cvsignore
copy  /Y     emacs        %USERPROFILE%\.emacs
copy  /Y     gitconfig    %USERPROFILE%\.gitconfig
copy  /Y     vimrc        %USERPROFILE%\.vimrc
copy  /Y     zshrc        %USERPROFILE%\.zshrc
rmdir /S/Q                %USERPROFILE%\.emacs.d
rmdir /S/Q                %USERPROFILE%\.third_party
rmdir /S/Q                %USERPROFILE%\vimfiles
xcopy /Y/S/I emacs.d      %USERPROFILE%\.emacs.d
xcopy /Y/S/I third_party  %USERPROFILE%\.third_party
xcopy /Y/S/I vim          %USERPROFILE%\vimfiles
pushd %USERPROFILE%\.emacs.d
%USERPROFILE%\.third_party\cask\bin\cask.bat install
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
git config --global --replace-all path.default simple
git config --global --replace-all user.name "Rouslan Solomakhin"
git config --global --replace-all user.email "rouslan.solomakhin@gmail.com"