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
import json
from dataclasses import dataclass, asdict

_SUCCESS = 0
_FAILURE = 1

@dataclass(frozen=True)
class AbsolutePathError:
  """An unallowed absolute path error.

  Attributes:
    file: The path to the file with the error.
    line: The line number where the error occurred.
    message: The error message containing the unallowed path.
  """
  file: str
  line: int
  message: str

def check_line(line: str, allow_list: list[str]) -> list[str]:
  """Check a single line for absolute paths.

  Args:
    line: The line to check.
    allow_list: List of allowed absolute path prefixes.

  Returns:
    A list of violated absolute paths found in the line.
  """
  violations = []
  # Match paths starting with / and having at least one more slash.
  # Ignore paths preceded by . or ~ to avoid false positives for relative paths.
  path_pattern = r"(?:^|[^a-zA-Z0-9_.~-])((?:/[a-zA-Z0-9_-]+){2,})"
  matches = re.finditer(path_pattern, line)
  for match in matches:
    matched_path = match.group(1)
    if not any(matched_path.startswith(prefix) for prefix in allow_list):
      violations.append(matched_path)
  return violations


def check_file(file_path: str) -> list[AbsolutePathError]:
  """Check a single file for absolute paths.

  Args:
    file_path: The path to the file to check.

  Returns:
    A list of AbsolutePathError objects.
  """
  violations = []
  allow_list = [
      "/usr/", "/dev/", "/tmp/", "/opt/", "/bin/", "/example/", "/etc/"
  ]

  try:
    with open(file_path, "r") as f:
      for line_num, line in enumerate(f, 1):
        line_violations = check_line(line, allow_list)
        for v in line_violations:
          violations.append(AbsolutePathError(
              file=file_path,
              line=line_num,
              message=f"Absolute path found: {v}"
          ))
  except Exception as e:
    violations.append(AbsolutePathError(
        file=file_path,
        line=0,
        message=f"Error reading {file_path}: {e!r}"
    ))

  return violations


def get_all_errors() -> list[AbsolutePathError]:
  """Get all absolute path violations in the repository.

  Returns:
    A list of AbsolutePathError objects.
  """
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
    return [AbsolutePathError(
        file="git ls-files",
        line=0,
        message=f"Error running git ls-files: {e!r}"
    )]

  all_errors = []
  for file_path in files:
    all_errors.extend(check_file(file_path))

  return all_errors


def main() -> int:
  """Main entry point for the absolute path checker.

  Returns:
    0 on success, 1 on failure.
  """
  all_errors = get_all_errors()
  result = {"result": "success" if len(all_errors) == 0 else "failure",
            "errors": [asdict(e) for e in all_errors]}
  print(json.dumps(result, indent=2))

  return _FAILURE if all_errors else _SUCCESS

if __name__ == "__main__":
  sys.exit(main())
