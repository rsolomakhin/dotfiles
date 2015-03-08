rmdir /S/Q                %USERPROFILE%\vimfiles
xcopy /Y/S/I vim          %USERPROFILE%\vimfiles
copy  /Y     cvsignore    %USERPROFILE%\.cvsignore
copy  /Y     gitconfig    %USERPROFILE%\.gitconfig
copy  /Y     bashrc       %USERPROFILE%\.bashrc
copy  /Y     bash_aliases %USERPROFILE%\.bash_aliases
copy  /Y     profile      %USERPROFILE%\.profile
