---
name: bash
description: Skill for managing and improving Bash configuration files.
---

# Bash configuration skill

This skill covers the customization of the Bash shell, including aliases,
prompts, and integration with external tools like fzf.

## Finalization steps

After modifying Bash configuration:

1.  Ensure changes work on both Linux and MacOS.
2.  Verify that `common.sh` works for both Bash and Zsh.
3.  Ensure changes are compatible with Bash 3.2+ (default on MacOS).
4.  Ensure modular files are being used rather than dumping everything in
    `bashrc`.
5.  Document every new alias or function clearly.
6.  Ensure the setup does not break if fzf is not installed on the system.
