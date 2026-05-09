---
name: committing-git-changes
description: Committing git changes.
---

# Skill for committing git changes

This skill allows for reliable execution of the steps to commit and push
changes.

## Instructions

1.  Request explicit user approval.
2.  Execute:

    ```bash
    ./skills/committing-git-changes/scripts/batch_commit.py --message \
        "Message that was approved by the user"`
    ```

The `batch_commit.py` script adds files, tests changes, commits them, and pushes
the update to GitHub.
