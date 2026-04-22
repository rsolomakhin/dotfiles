---
name: Vim Configuration
description: Skill for managing and improving Vim configuration files.
---

# Vim Configuration Skill

This file defines the skill for managing and improving the Vim configuration.

## Description

This skill covers the customization of the Vim text editor, including plugins,
key mappings, and UI settings like cursor shapes.

## Instructions

When modifying Vim configuration:

-   Ensure changes work on both Linux and MacOS.
-   Prefer using native Vim features or well-established plugins.
-   Document every new mapping or plugin clearly.
-   Follow the A-F review protocol for any changes.

### FZF Integration

-   FZF should be used for fuzzy finding files within Vim.
-   Ensure the setup integrates well with the system fzf installation.

### Cursor Shape Management

-   Ensure cursor shape changes correctly between modes.
-   Normal and Visual mode should have a block cursor.
-   Insert mode should have a pipe (line) cursor.

### Environment Variables

-   Be cautious with VIMRUNTIME environment variable updates as it points to
    a versioned directory that changes.
