Quick start steps to setup my Chromium development environment.

# Cross platform

- Install [JDK] in `~/jdk`
- Install [Eclipse] in `~/eclipse`
- Install [Eclim] only for Java development

# UNIX flavors

```sh
$ git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
$ ssh-keygen -t rsa -b 4096 -f ~/.ssh/github -C "rouslan@example.com"
$ eval "$(ssh-agent -s)"
$ ssh-add ~/.ssh/github
$ git clone git@github.com:rsolomakhin/dotfiles.git .dotfiles
$ .dotfiles/install
$ source .bashrc
```

# Mac specific

- Install [Xcode]

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

# Vim and Emacs

| [Vim][1]                         | [Emacs][2]                                |
|----------------------------------|-------------------------------------------|
| ``ESC j``                        | ``C-n``                                   |
| ``ESC k``                        | ``C-p``                                   |
| ``ESC h``                        | ``C-b``                                   |
| ``ESC l``                        | ``C-f``                                   |
| ``ESC w``                        | ``M-f``                                   |
| ``ESC b``                        | ``M-b``                                   |
| ``ESC ^``                        | ``M-m``                                   |
| ``ESC 0``, ``imap <C-A> <ESC>I`` | ``C-a``                                   |
| ``ESC $``, ``imap <C-E> <ESC>A`` | ``C-e``                                   |
| ``ESC J``                        | ``M-^``                                   |
| ``ESC dw``                       | ``M-del``                                 |
| ``ESC db``,``C-w``               | ``M-backspace``                           |
| ``ESC C-r``-``x``                | ``C-space``-``C-x r k``                   |
| ``ESC C-r``-``y``                | ``C-space``-``C-x r M-w``                 |
| ``ESC C-r``-``c string ESC``     | ``C-space``-``C-x r t string RET``        |
| ``V >>``, ``C-t``                | ``M-i``, ``C-x TAB S-RIGHT``              |
| ``V <<``, ``C-d``                | ``C-x TAB S-LEFT``                        |
| ``ESC : number``                 | ``M-g M-g number``                        |
| ``ESC 4j``                       | ``C-u 4 C-n``, ``C-u C-n``                |
| ``ESC 16j``                      | ``C-u C-u C-n``                           |
| ``ESC W``                        |                                           |
| ``ESC B``                        |                                           |
| ``ESC ciw``                      |                                           |
| ``ESC ca"``                      |                                           |
| ``ESC "1p...``                   | ``C-y M-y M-y M-y``                       |
| ``fzf``                          | ``M-x ido-mode``, ``M-x recentf-open-files`` |
| ``vim-plug``                     | ``M-x list-packges``                      |

[JDK]: http://www.oracle.com/technetwork/java/javase/downloads/index.html
[Eclipse]: http://www.eclipse.org/downloads/index.php
[Eclim]: http://sourceforge.net/projects/eclim/files/eclim/2.4.1/eclim_2.4.1.jar/download
[Xcode]: https://developer.apple.com/xcode/
[depot_tools.zip]: https://src.chromium.org/svn/trunk/tools/depot_tools.zip
[GitHub Windows]: https://windows.github.com/
[runtime files]: ftp://ftp.vim.org/pub/vim/pc/vim74rt.zip
[GUI executable]: ftp://ftp.vim.org/pub/vim/pc/gvim74.zip
[Win32 console executable]: ftp://ftp.vim.org/pub/vim/pc/vim74w32.zip
[Emacs]: https://ftp.gnu.org/gnu/emacs/windows/emacs-24.4-bin-i686-pc-mingw32.zip
[Visual Studio Community]: https://www.visualstudio.com/
[1]: http://vim-adventures.com/
[2]: http://www.gnu.org/software/emacs/tour/
