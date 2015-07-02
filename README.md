Quick start steps to setup my Chromium development environment.

# Linux

```sh
$ git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
$ ssh-keygen -t rsa -b 4096 -f ~/.ssh/github -C "rouslan@example.com"
$ eval "$(ssh-agent -s)"
$ ssh-add ~/.ssh/github
$ git clone git@github.com:rsolomakhin/dotfiles.git .dotfiles
$ .dotfiles/install
$ source .bashrc
```

# Mac

- Install [Xcode]
- Same steps as Linux

# Windows

- Extract [depot_tools.zip] in `c:\src\depot_tools`

- Install [GitHub Windows] and clone this
  repository in `c:\src\dotfiles`

- Extract Vim [runtime files], [GUI executable], and [Win32 console executable]
  in `c:\vim`

- Extract [Emacs] in `c:\emacs`

- Install [Visual Studio Community]

```sh
c:\src\depot_tools> gclient.bat
c:\src\dotfiles\windows> install.bat
c:\src> env.bat
```

[Xcode]: https://developer.apple.com/xcode/
[depot_tools.zip]: https://src.chromium.org/svn/trunk/tools/depot_tools.zip
[GitHub Windows]: https://windows.github.com/
[runtime files]: ftp://ftp.vim.org/pub/vim/pc/vim74rt.zip
[GUI executable]: ftp://ftp.vim.org/pub/vim/pc/gvim74.zip
[Win32 console executable]: ftp://ftp.vim.org/pub/vim/pc/vim74w32.zip
[Emacs]: https://ftp.gnu.org/gnu/emacs/windows/emacs-24.4-bin-i686-pc-mingw32.zip
[Visual Studio Community]: https://www.visualstudio.com/

# Vim and Emacs

| Vim                                  | Emacs                                |
|--------------------------------------|--------------------------------------|
| Plugins are plentiful and work well. | No modes and intuitive key bindings. |
