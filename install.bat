rmdir /S/Q                %USERPROFILE%\vimfiles
xcopy /Y/S/I vim          %USERPROFILE%\vimfiles
copy  /Y     vimrc        %USERPROFILE%\.vimrc
copy  /Y     cvsignore    %USERPROFILE%\.cvsignore
copy  /Y     gitconfig    %USERPROFILE%\.gitconfig
copy  /Y     profile      %USERPROFILE%\.profile
