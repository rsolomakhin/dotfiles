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
./scripts/format_proposal.py \
    --title="Title of prpposal" \
    --suggestion="Suggestion to change X to Y" \
    --existing-code="print('Hello world')" \
    --issue="Desribe issue with X",
    --proposed-code="print('Hello World!')" \
    --improvement="Describe how Y is better than X" \
    --alternatives="Describe other alternatives considered to X and Y"
```
