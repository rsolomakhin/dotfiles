#!/usr/bin/env python3
#
# Copyright 2026 Rouslan Solomakhin.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import json
import os
import sys
from typing import Optional


_SUCCESS = 0
_FAILURE = 1


def format_proposal(data: dict) -> Optional[str]:
  """Format a proposal from data.

  Args:
    data: Dictionary containing title, suggestion, existing_code, issue,
      proposed_code, improvement, and alternatives.

  Returns:
    The formatted proposal string, or None on error.
  """
  required_keys = [
      "title", "suggestion", "existing_code", "issue", "proposed_code",
      "improvement", "alternatives"
  ]
  for key in required_keys:
    if key not in data:
      print(f"Error: Missing required key: {key}", file=sys.stderr)
      return None

  # Find template relative to script.
  script_dir = os.path.dirname(os.path.abspath(__file__))
  template_path = os.path.join(script_dir, "../resources/proposal_template.md")

  if not os.path.exists(template_path):
    print(f"Error: Template not found at {template_path}", file=sys.stderr)
    return None

  with open(template_path, "r") as f:
    template = f.read()

  try:
    return template.format(**data)
  except KeyError as e:
    print(f"Error: Template key mismatch: {e}", file=sys.stderr)
    return None


def main() -> int:
  """Main entry point.

  Returns:
    0 for success, 1 for failure.
  """
  try:
    data = json.load(sys.stdin)
  except json.JSONDecodeError as e:
    print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
    return _FAILURE

  output = format_proposal(data)
  if output is None:
    return _FAILURE

  print(output)
  return _SUCCESS


if __name__ == "__main__":
  sys.exit(main())
