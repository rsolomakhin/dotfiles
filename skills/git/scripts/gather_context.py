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

import argparse
import os
import subprocess
import sys


_SUCCESS = 0
_FAILURE = 1


def run_command(cmd, description) -> bool:
  """Run a command and print output."""
  print(f"--- Running: {description} ---")
  try:
    result = subprocess.run(cmd, check=True, text=True)
  except subprocess.CalledProcessError as e:
    print(f"Error: {description} failed.", file=sys.stderr)
    return False
  else:
    print(result)
    return True


def gather_context() -> int:
  # Find repo root relative to script.
  script_dir = os.path.dirname(os.path.abspath(__file__))
  repo_root = os.path.abspath(os.path.join(script_dir, "../../.."))

  # Change directory to repo root.
  os.chdir(repo_root)

  if not run_command(["env", "PAGER=cat", "git", "log", "-n", "3", "--stat"], "Git log"):
    return _FAILURE

  if not run_command(["env", "PAGER=cat", "git", "status"], "Git status"):
    return _FAILURE

  if not run_command(["env", "PAGER=cat", "git", "diff", "--stat"], "Git diff stat"):
    return _FAILURE

  if not run_command(["env", "PAGER=cat", "git", "diff", "--cached", "--stat"], "Git diff stat staged for commit"):
    return _FAILURE

  if not run_command(["env", "PAGER=cat", "git", "diff"], "Git diff"):
    return _FAILURE

  if not run_command(["env", "PAGER=cat", "git", "diff", "--cached"], "Git diff staged for commit"):
    return _FAILURE

  return _SUCCESS


if __name__ == "__main__":
  sys.exit(gather_context())
