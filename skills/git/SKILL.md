---
name: git
description: Git command skill.
---

# Git Skill

This skill defines the rules for using Git commands in this repository.

## Rules

- Explicit Approval Required: Always request explicit approval from the user
  before executing `git add`, `git commit`, or `git push`.
- Allowed Discovery: `git status`, `git diff`, and `git log` are always allowed
  and should be used to gather context.

## Workflow

When asked to commit or "wrap up" changes, follow this specific workflow:

1. Context Gathering: Run `git status && git diff HEAD && git log -n 3` to see
   pending changes and match the project's commit message style.
2. Commit Proposal:
   - Provide a clear diff of the changes.
   - Propose a draft commit message that explains "why" the change was made, not
     just "what" changed.
   - Ask for confirmation before proceeding.
3. Batch Execution: Upon approval, execute the following in a single turn:
   - `git add <files>`
   - `git commit -m "<message>"`
   - `git push` (if a push was requested)
4. Final Verification: Always run `git status` after the operation to confirm
   the workspace is clean and the push was successful.
