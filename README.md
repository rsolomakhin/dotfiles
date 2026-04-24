# README

[![Windows build status](https://ci.appveyor.com/api/projects/status/y9929cmeqn390syq/branch/master?svg=true)](https://ci.appveyor.com/project/rsolomakhin/dotfiles/branch/master)

> We deliberate not about ends but about means. For a doctor does not deliberate
> whether he shall heal, nor an orator whether he shall persuade, nor a
> statesman whether he shall produce law and order, nor does any one else
> deliberate about his end. They assume the end and consider how and by what
> means it is to be attained.

-- Aristotle, Nicomachean Ethics

## Installation

### Linux and macOS

The `install` script on Linux and macOS will take files from `src/` and symlink
to them from the `$HOME` directory, with a leading dot added. For example,
`src/vimrc` in the repository becomes `~/.vimrc`, and `src/vim/coc.vim` becomes
`~/.vim/coc.vim`.

### Windows

The `windows/install.bat` on Windows will copy files from `src/` to the
`%USERPROFILE%` directory. For example, `src/cvsignore` becomes
`%USERPROFILE%\.cvsignore` and `src/vimrc` becomes `%USERPROFILE%\.vimrc`. Note
that `src/vim/coc.vim` is copied to `%USERPROFILE%\vimfiles\coc.vim`.

## Vim Shortcuts for coc.nvim

If Node.js is installed and `coc.nvim` is active, the following shortcuts are
available:

-   `[g` : Navigate to previous diagnostic (error/warning).
-   `]g` : Navigate to next diagnostic (error/warning).
-   `<leader>d` : Go to definition of symbol under cursor.
-   `<leader>e` : Show references to symbol under cursor.
-   `<leader>f` : Format selected code.
-   `<leader>k` : Show documentation hover for symbol under cursor.
-   `<TAB>` : Accept auto-completion suggestion.
