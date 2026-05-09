---
name: proposing-changes
description: Provides a structured and transparent review process for all
engineering improvements.
---

# Skill for proposing changes

When proposing file changes, break down complex tasks into clear steps
methodically and follow the strict review protocol for transparency, using the
helper script `./skills/proposing-changes/scripts/format_proposal.py`.

Example usage:

```bash
echo '{
  "title": "Title of proposal",
  "suggestion": "Suggestion to change X to Y",
  "existing_code": "print('\''Hello world'\'')",
  "issue": "Describe issue with X",
  "proposed_code": "print('\''Hello World!'\'')",
  "improvement": "Describe how Y is better than X",
  "alternatives": "Describe other alternatives considered"
}' | ./skills/proposing-changes/scripts/format_proposal.py
```
