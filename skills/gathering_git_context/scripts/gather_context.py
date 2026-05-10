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
import subprocess
import sys


_SUCCESS = 0
_FAILURE = 1


def gather_git_context() -> dict:
  """Gather context for the current state of the repo.

  Returns:
    A dictionary containing stdout, stderr, and exit_code.
  """
  # Find repo root relative to script.
  script_dir = os.path.dirname(os.path.abspath(__file__))
  repo_root = os.path.abspath(os.path.join(script_dir, "../../.."))

  # Change directory to repo root.
  original_cwd = os.getcwd()
  os.chdir(repo_root)

  output = []
  error_output = []
  exit_code = _SUCCESS

  def run_cmd(cmd: list[str], description: str) -> bool:
    nonlocal exit_code
    output.append(f"--- Running: {description} ---\n")
    try:
      result = subprocess.run(cmd, capture_output=True, text=True, check=False)
      output.append(result.stdout)
      error_output.append(result.stderr)
      if result.returncode != _SUCCESS:
        output.append(
            f"Error: {description} failed with exit code "
            f"{result.returncode}.\n")
        exit_code = result.returncode
        return False
      return True
    except Exception as e:
      error_output.append(f"Exception running {description}: {str(e)}\n")
      exit_code = _FAILURE
      return False

  commands = [
      (["env", "PAGER=cat", "git", "log", "-n", "3", "--stat"], "Git log"),
      (["env", "PAGER=cat", "git", "status"], "Git status"),
      (["env", "PAGER=cat", "git", "diff", "--stat"], "Git diff stat"),
      (["env", "PAGER=cat", "git", "diff", "--cached", "--stat"],
       "Git diff stat staged for commit"),
      (["env", "PAGER=cat", "git", "diff"], "Git diff"),
      (["env", "PAGER=cat", "git", "diff", "--cached"],
       "Git diff staged for commit"),
  ]

  for cmd, desc in commands:
    if not run_cmd(cmd, desc):
      break

  os.chdir(original_cwd)

  return {
      "stdout": "".join(output),
      "stderr": "".join(error_output),
      "exit_code": exit_code
  }


if __name__ == "__main__":
  result = gather_git_context()
  if result["stdout"]:
    print(result["stdout"])
  if result["stderr"]:
    print(result["stderr"], file=sys.stderr)
  sys.exit(result["exit_code"])
