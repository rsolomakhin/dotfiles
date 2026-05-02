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
    print result
    return True


def batch_commit() -> int:
  parser = argparse.ArgumentParser(
      description="Batch execute tests, add, commit, and push."
  )
  parser.add_argument(
      "--message", required=True, help="Commit message, explaining why."
  )

  args = parser.parse_args()

  # Find repo root relative to script.
  script_dir = os.path.dirname(os.path.abspath(__file__))
  repo_root = os.path.abspath(os.path.join(script_dir, "../../.."))

  # Change directory to repo root.
  os.chdir(repo_root)

  if not run_command(["git", "add", "."], "Staging files"):
    return _FAILURE

  if not run_command(["./test"], "Running tests"):
    return _FAILURE

  if not run_command(["git", "commit", "-m", args.message], "Committing changes"):
    return _FAILURE

  if not run_command(["git", "push"], "Pushing changes"):
    return _FAILURE

  return _SUCCESS


if __name__ == "__main__":
  sys.exit(batch_commit())
