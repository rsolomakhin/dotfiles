---
name: harmonizing-bash
description: Ensures shell configurations remain consistent, portable, and
resilient across different Bash versions, Zsh, and operating systems.
---

# Harmonizing bash

## Goals

1.  Prevent environment breakage across different platforms or shell versions
2.  Maintain a high standard of configuration quality where scripts are:
    1.  Functional.
    2.  Modular.
    3.  Well-documented.
    4.  Capable of gracefully handling:
        1.  Missing dependencies.
        2.  Older shell versions (like Bash 3.2 on MacOS).

## Finalization steps

After modifying Bash configuration:

1.  Ensure changes work on both Linux and MacOS.
2.  Verify that `common.sh` works for both Bash and Zsh.
3.  Ensure changes are compatible with Bash 3.2+ (default on MacOS).
4.  Ensure modular files are being used rather than dumping everything in
    `bashrc`.
5.  Document every new alias or function clearly.
6.  Ensure the setup does not break if fzf is not installed on the system.
