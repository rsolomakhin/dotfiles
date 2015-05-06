copy  /Y     cvsignore    %USERPROFILE%\.cvsignore
copy  /Y     emacs        %USERPROFILE%\.emacs
copy  /Y     gitconfig    %USERPROFILE%\.gitconfig
copy  /Y     vimrc        %USERPROFILE%\.vimrc
copy  /Y     zshrc        %USERPROFILE%\.zshrc
rmdir /S/Q                %USERPROFILE%\.third_party
rmdir /S/Q                %USERPROFILE%\vimfiles
xcopy /Y/S/I third_party  %USERPROFILE%\.third_party
xcopy /Y/S/I vim          %USERPROFILE%\vimfiles
