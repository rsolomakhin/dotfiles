---
name: requesting-git-permission
description: Requesting permissions for git operations.
---

# Skill for requesting permissions for git operations

The user should approve all write changes. There is no need to pause and ask the
user for read-only commands.

## Instructions

1.  If there is a need to run the following write commands, then always request
    permission from the user:
    -   `git add`
    -   `git commit`
    -   `git push`

2.  If there is a need to run the following read-only commands, then it is OK to
    execute these commands without requesting user permissions:
    -   `git status`
    -   `git log`
    -   `git diff`
