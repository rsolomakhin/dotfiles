---
name: git
description: Git command skill.
---

# Git Skill

This skill defines the rules for using Git commands in this repository.

## Rules

-   Explicit Approval Required: Always request explicit approval from the user
    before executing:
    - `git add`
    - `git commit`
    - `git push`
-   Include Diff: Each request for approval must include a clear diff of what is
    being added, committed, or pushed.
-   Allowed Commands: The following command always allowed and does not require
    explicit approval:
    - `git diff`
