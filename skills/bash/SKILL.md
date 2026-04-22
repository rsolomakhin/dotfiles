---
name: Bash Configuration
description: Skill for managing and improving Bash configuration files.
---

# Bash Configuration Skill

This file defines the skill for managing and improving the Bash configuration.

## Description

This skill covers the customization of the Bash shell, including aliases,
prompts, and integration with external tools like fzf.

## Instructions

When modifying Bash configuration:

-   Ensure changes work on both Linux and MacOS.
-   Ensure changes are compatible with Bash 3.2+ (default on MacOS).
-   Prefer adding modular files or using existing structure rather than
    dumping everything in bashrc.
-   Document every new alias or function clearly.
-   Follow the A-F review protocol for any changes.

### FZF Integration

-   FZF should be used for fuzzy finding files and command history.
-   Ensure the setup does not break if fzf is not installed on the system.
