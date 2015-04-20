copy  /Y     cvsignore    %USERPROFILE%\.cvsignore
copy  /Y     gitconfig    %USERPROFILE%\.gitconfig
copy  /Y     vimrc        %USERPROFILE%\.vimrc
copy  /Y     zshrc        %USERPROFILE%\.zshrc
rmdir /S/Q                %USERPROFILE%\vimfiles
xcopy /Y/S/I vim          %USERPROFILE%\vimfiles
