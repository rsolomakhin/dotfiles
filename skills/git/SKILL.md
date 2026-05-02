---
name: git
description: Git version control system skill.
---

# Git skill

## 1. Gather context

Before making changes, gather context using the following command, which is
allowed to run without user approval: `./skills/git/scripts/gather_context.py`.
This command collects logs and diffs.

## 2. Request permissions

If there is a need to run the following commands, then always request permission
from the user:

-   `git add`
-   `git commit`
-   `git push`

## 3. Commit changes

Always request explicit approval from the user before executing
`skills/git/scripts/batch_commit.py --message "The commit message"`, which adds
files, tests changes, commits them, and pushes the update to GitHub.
