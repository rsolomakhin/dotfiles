copy  /Y     bash_profile %USERPROFILE%\.bash_profile
copy  /Y     bashrc       %USERPROFILE%\.bashrc
copy  /Y     cvsignore    %USERPROFILE%\.cvsignore
copy  /Y     gitconfig    %USERPROFILE%\.gitconfig
copy  /Y     vimrc        %USERPROFILE%\.vimrc
del                       %USERPROFILE%\.bash_aliases
del                       %USERPROFILE%\.profile
rmdir /S/Q                %USERPROFILE%\vimfiles
xcopy /Y/S/I vim          %USERPROFILE%\vimfiles
