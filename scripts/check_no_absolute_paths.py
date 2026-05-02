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

import os
import re
import subprocess
import sys


_SUCCESS = 0
_FAILURE = 1


def check_file(file_path):
  """Check a single file for absolute paths."""
  violations = []
  # Allow-list of acceptable absolute path prefixes.
  allow_list = ["/usr/", "/dev/", "/tmp/", "/opt/"]

  try:
    with open(file_path, "r", errors="ignore") as f:
      for line_num, line in enumerate(f, 1):
        # Match paths starting with / and having at least one more slash.
        matches = re.finditer(r"(^|\s)(/[a-zA-Z0-9_-]+){2,}", line)
        for match in matches:
          matched_path = match.group().strip()
          # Check if the path starts with any allow-listed prefix.
          if not any(matched_path.startswith(prefix) for prefix in allow_list):
            violations.append(f"Line {line_num}: {matched_path}")
  except Exception as e:
    print(f"Error reading {file_path}: {e}", file=sys.stderr)

  return violations


def check_no_absolute_paths() -> int:
  # Find repo root.
  script_dir = os.path.dirname(os.path.abspath(__file__))
  repo_root = os.path.abspath(os.path.join(script_dir, ".."))
  os.chdir(repo_root)

  # Get all tracked files.
  try:
    result = subprocess.run(
        ["git", "ls-files"],
        stdout=subprocess.PIPE,
        text=True,
        check=True,
    )
    files = result.stdout.splitlines()
  except subprocess.CalledProcessError as e:
    print(f"Error running git ls-files: {e}", file=sys.stderr)
    return _FAILURE

  success = True
  for file_path in files:
    violations = check_file(file_path)
    if violations:
      print(f"Absolute paths found in {file_path}:", file=sys.stderr)
      for v in violations:
        print(f"  {v}", file=sys.stderr)
      success = False

  if not success:
    print("Error: Unallowed absolute paths found in the repo.", file=sys.stderr)
    return _FAILURE

  print("No unallowed absolute paths found.")
  return _SUCCESS


if __name__ == "__main__":
  sys.exit(check_no_absolute_paths())
