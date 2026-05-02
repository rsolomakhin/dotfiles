---
name: markdown
description: Skill for managing and improving Markdown files in this repository.
---

# Markdown files skill

## Finalization steps

After modifying Markdown files, follow these steps:

1.  Convert all absolute path to be relative to `$HOME` or the root of this
    repository. For example:
    -   Path: `/example/home/rouslan/.vimrc'
        -   Replace with: `~/.vimrc`
    -   Path: `/example/home/rouslan/dotfiles/install`
        -   Replace with: `./install`
2.  Verify that lists are start with a newline (leave a blank line before the
    list).
3.  Verify that section and subsection titles are followed by a newline.
4.  Surround file names and code symbols with backticks (`).
    -   For example: `print("Hello World!")`
5.  Bullet points should use `-`.
    -   Example bullet point 1.
    -   Example bullet point 2.
6.  Remove bold text formatting from markdown files.
7.  Format markdown files to 80 characters per line.
