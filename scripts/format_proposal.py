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

from __future__ import annotations
import argparse
import os
import sys


_SUCCESS = 0
_FAILURE = 1


def get_parser() -> argparse.ArgumentParser:
  """Get the argument parser for formatting a proposal.

  Returns:
    The argument parser.
  """
  parser = argparse.ArgumentParser(
      description="Format a proposal according to the A-F protocol."
  )
  parser.add_argument("--title", required=True, help="Title of the proposal.")
  parser.add_argument("--suggestion", required=True, help="Suggestion.")
  parser.add_argument("--existing-code", default="", help="Existing Code.")
  parser.add_argument("--issue", required=True, help="Issue with the code.")
  parser.add_argument(
      "--proposed-code", required=True, help="Proposed code change."
  )
  parser.add_argument(
      "--improvement",
      required=True,
      help="How it improves the situation.",
  )
  parser.add_argument(
      "--alternatives",
      required=True,
      help="Alternatives considered.",
  )
  return parser


def generate_proposal(template: str, args: argparse.Namespace) -> str:
  """Generate a proposal from a template and arguments.

  Args:
    template: The template string.
    args: The parsed arguments.

  Returns:
    The formatted proposal string.
  """
  return template.format(
      title=args.title,
      suggestion=args.suggestion,
      existing_code=args.existing_code,
      issue=args.issue,
      proposed_code=args.proposed_code,
      improvement=args.improvement,
      alternatives=args.alternatives,
  )


def format_proposal(argv: list[str] | None = None) -> int:
  """Format a proposal.

  Args:
    argv: The command line arguments.

  Returns:
    0 for success, 1 for failure.
  """
  parser = get_parser()
  args = parser.parse_args(argv)

  # Find template relative to script.
  script_dir = os.path.dirname(os.path.abspath(__file__))
  template_path = os.path.join(script_dir, "../resources/proposal_template.md")

  if not os.path.exists(template_path):
    print(f"Error: Template not found at {template_path}", file=sys.stderr)
    return _FAILURE

  with open(template_path, "r") as f:
    template = f.read()

  output = generate_proposal(template, args)

  print(output)
  return _SUCCESS


if __name__ == "__main__":
  sys.exit(format_proposal())
