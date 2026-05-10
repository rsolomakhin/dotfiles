#!/usr/bin/env python3
#
# Copyright 2026 Rouslan Solomakhin
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
import sys
import json
import subprocess
from dataclasses import asdict
from google import genai
from scripts import check_no_absolute_paths
from scripts import check_standards
from skills.committing_git_changes.scripts import batch_commit
from skills.gathering_git_context.scripts import gather_context
from skills.proposing_changes.scripts import format_proposal

def read_file(path: str) -> dict:
  """Reads the content of a file using Python's built-in open().

  Args:
    path: The path to the file to read.

  Returns:
    A dictionary containing stdout, stderr, and exit_code.
  """
  try:
    with open(path, "r", encoding="utf-8") as f:
      content = f.read()
    return {
        "stdout": content,
        "stderr": "",
        "exit_code": 0
    }
  except Exception as e:
    return {
        "stdout": "",
        "stderr": str(e),
        "exit_code": 1
    }

def write_file(path: str, content: str) -> dict:
  """Writes content to a file using Python's built-in open().

  Args:
    path: The path to the file to write.
    content: The content to write to the file.

  Returns:
    A dictionary containing stdout, stderr, and exit_code.
  """
  try:
    with open(path, "w", encoding="utf-8") as f:
      f.write(content)
    return {
        "stdout": f"Successfully wrote to {path}",
        "stderr": "",
        "exit_code": 0
    }
  except Exception as e:
    return {
        "stdout": "",
        "stderr": str(e),
        "exit_code": 1
    }

def list_files() -> dict:
  """Lists all files tracked by git.

  Returns:
    A dictionary containing stdout, stderr, and exit_code.
  """
  try:
    result = subprocess.run(
        ["git", "ls-files"], capture_output=True, text=True, check=False
    )
    return {
        "stdout": result.stdout,
        "stderr": result.stderr,
        "exit_code": result.returncode
    }
  except Exception as e:
    return {
        "stdout": "",
        "stderr": str(e),
        "exit_code": 1
    }

TOOL_MAP = {
  "gather_git_context": {
    "func": gather_context.gather_git_context,
    "requires_permission": False,
  },
  "read_file": {
    "func": read_file,
    "requires_permission": False,
  },
  "write_file": {
    "func": write_file,
    "requires_permission": True,
  },
  "list_files": {
    "func": list_files,
    "requires_permission": False,
  },
  "check_standards": {
    "func": lambda: [
        asdict(e) for e in check_standards.get_all_errors()
    ],
    "requires_permission": False,
  },
  "check_no_absolute_paths": {
    "func": lambda: [
        asdict(e) for e in check_no_absolute_paths.get_all_errors()
    ],
    "requires_permission": False,
  },
  "batch_commit": {
    "func": batch_commit.batch_commit,
    "requires_permission": True,
  },
  "format_proposal": {
    "func": format_proposal.format_proposal,
    "requires_permission": False,
  },
}

TOOLS = [
  {
    "type": "function",
    "name": "gather_git_context",
    "description": (
      "Gathers detailed git context including log, status, and diffs. "
      "This is a read-only operation and does not require user permission."
    ),
    "parameters": {
      "type": "object",
      "properties": {}
    }
  },
  {
    "type": "function",
    "name": "read_file",
    "description": (
      "Reads the content of a file. "
      "This is a read-only operation and does not require user permission."
    ),
    "parameters": {
      "type": "object",
      "properties": {
        "path": {
          "type": "string",
          "description": "The path to the file to read."
        }
      },
      "required": ["path"]
    }
  },
  {
    "type": "function",
    "name": "edit_file",
    "description": (
      "Edits a file by replacing a range of lines (0-indexed). "
      "start is inclusive, end is exclusive. For insertion, use start=end. "
      "Content should include any necessary trailing newlines. "
      "Requires explicit user permission as it modifies the file system."
    ),
    "parameters": {
      "type": "object",
      "properties": {
        "path": {
          "type": "string",
          "description": "The path to the file to edit."
        },
        "start": {
          "type": "integer",
          "description": "The 0-based start line index (inclusive)."
        },
        "end": {
          "type": "integer",
          "description": "The 0-based end line index (exclusive)."
        },
        "content": {
          "type": "string",
          "description": "The new content to insert in the range."
        }
      },
      "required": ["path", "start", "end", "content"]
    }
  },
  {
    "type": "function",
    "name": "list_files",
    "description": (
      "Lists all files tracked by git using 'git ls-files'. "
      "This is a read-only operation and does not require user permission."
    ),
    "parameters": {
      "type": "object",
      "properties": {}
    }
  },
  {
    "type": "function",

    "name": "check_standards",
    "description": (
        "Runs repository-wide standards compliance checks (license headers, "
        "shebangs, Python style, etc.). Returns a list of errors."
    ),
    "parameters": {
      "type": "object",
      "properties": {}
    }
  },
  {
    "type": "function",
    "name": "check_no_absolute_paths",
    "description": (
        "Scans for unauthorized absolute paths in tracked files. "
        "Returns a list of violations."
    ),
    "parameters": {
      "type": "object",
      "properties": {}
    }
  },
  {
    "type": "function",
    "name": "batch_commit",
    "description": (
        "Stages all changes, runs tests, commits with a message, and pushes. "
        "Requires explicit user permission as it modifies the repository."
    ),
    "parameters": {
      "type": "object",
      "properties": {
        "message": {
          "type": "string",
          "description": "The commit message explaining why the change is made."
        }
      },
      "required": ["message"]
    }
  },
  {
    "type": "function",
    "name": "format_proposal",
    "description": (
        "Formats a structured change proposal into a standard Markdown "
        "template. Useful for preparing formal suggestions for review."
    ),
    "parameters": {
      "type": "object",
      "properties": {
        "data": {
          "type": "object",
          "properties": {
            "title": {
                "type": "string",
                "description": "Title of the proposal"
            },
            "suggestion": {
                "type": "string",
                "description": "Short summary of the suggestion"
            },
            "existing_code": {
                "type": "string",
                "description": "Code snippet of the current state"
            },
            "issue": {
                "type": "string",
                "description": "Description of the problem being solved"
            },
            "proposed_code": {
                "type": "string",
                "description": "Code snippet of the proposed change"
            },
            "improvement": {
                "type": "string",
                "description": "Detailed explanation of why this is better"
            },
            "alternatives": {
                "type": "string",
                "description": "Other approaches considered"
            }
          },
          "required": [
              "title", "suggestion", "existing_code", "issue", "proposed_code",
              "improvement", "alternatives"
          ]
        }
      },
      "required": ["data"]
    }
  },
]

def main() -> None:
  # Check for GEMINI_API_KEY.
  api_key = os.environ.get("GEMINI_API_KEY")
  if not api_key:
    print("Error: GEMINI_API_KEY environment variable is not set.")
    sys.exit(1)

  # Initialize client.
  try:
    client = genai.Client()
  except Exception as e:
    print(f"Error initializing client: {e}")
    sys.exit(1)

  model_id = "gemini-3-flash-preview"
  previous_interaction_id = None

  # Initialize system instruction.
  system_instruction = ""

  # Load project context from AGENTS.md.
  agents_file = "AGENTS.md"
  if not os.path.exists(agents_file):
    print(f"Error: {agents_file} not found in the current directory.")
    sys.exit(1)
  try:
    with open(agents_file, "r") as f:
      system_instruction += "# Core Standards\n\n" + f.read()
  except Exception as e:
    print(f"Error reading {agents_file}: {e}")
    sys.exit(1)

  # Load Project Overview from README.md.
  if os.path.exists("README.md"):
    try:
      with open("README.md", "r") as f:
        system_instruction += "# Project Overview\n\n" + f.read() + "\n\n"
    except Exception as e:
      print(f"Warning: Could not read README.md: {e}")

  # Load the terminology definitions from TERMS.md.
  if os.path.exists("TERMS.md"):
    try:
      with open("TERMS.md", "r") as f:
        system_instruction += "# Terminology\n\n" + f.read() + "\n\n"
    except Exception as e:
      print(f"Warning: Could not read TERMS.md: {e}")

  # Load all skills from skills/*/SKILL.md
  import glob
  skill_files = glob.glob("skills/*/SKILL.md")
  loaded_skills = []
  if skill_files:
    system_instruction += "\n\n# Available Skills\n"
    for skill_path in skill_files:
      try:
        skill_name = os.path.basename(os.path.dirname(skill_path))
        with open(skill_path, "r") as f:
          system_instruction += f"\n## Skill: {skill_name}\n\n" + \
                                f.read() + "\n"
        loaded_skills.append(skill_name)
      except Exception as e:
        print(f"Warning: Could not read skill at {skill_path}: {e}")

  print(f"Chatting with {model_id}.")
  print("Loaded context from:")
  print(f"  - {agents_file}")
  if os.path.exists("README.md"):
    print("  - README.md")
  if os.path.exists("TERMS.md"):
    print("  - TERMS.md")
  print(f"  - Skills: {" ".join(loaded_skills)}")
  print("Type '/exit' or '/quit' to stop.")

  while True:
    try:
      # Get user input
      user_input = input("You: ").strip()

      # Handle exit commands
      if user_input.lower() in ["/exit", "/quit"]:
        print("Goodbye!")
        break

      if not user_input:
        continue

      # Create initial interaction
      interaction = client.interactions.create(
        model=model_id,
        input=user_input,
        system_instruction=system_instruction,
        previous_interaction_id=previous_interaction_id,
        tools=TOOLS
      )

      # Handle multi-step interaction (tool calls)
      while True:
        # Update state for the next turn (last interaction in the chain)
        previous_interaction_id = interaction.id

        # Print outputs from this step
        for step in interaction.steps:
          if step.type == "model_output":
            for part in step.content:
              if part.type == "text":
                print(f"Gemini: {part.text}")
          elif step.type == "thought":
            if hasattr(step, "summary") and step.summary:
              for part in step.summary:
                if part.type == "text":
                  # Abbreviate thought summary
                  thought_text = part.text.replace("\n", " ")
                  if len(thought_text) > 80:
                    thought_text = thought_text[:77] + "..."
                  print(f"[Thought] {thought_text}")

        if interaction.status != "requires_action":
          break

        # Collect tool results
        tool_results = []
        for step in interaction.steps:
          if step.type == "function_call":
            tool_name = step.name
            tool_args = step.arguments
            tool_id = step.id

            print(f"  [Calling Tool] {tool_name}({json.dumps(tool_args)})")

            if tool_name in TOOL_MAP:
              config = TOOL_MAP[tool_name]
              if config.get("requires_permission"):
                prompt = f"  [Permission Request] Allow {tool_name}? (y/n): "
                if input(prompt).strip().lower() != "y":
                  print(f"  [Tool Denied] {tool_name}")
                  tool_results.append({
                    "type": "function_result",
                    "name": tool_name,
                    "call_id": tool_id,
                    "is_error": True,
                    "result": {
                      "error": "User denied permission to run this tool."
                    }
                  })
                  continue

              try:
                result = config["func"](**tool_args)
                tool_results.append({
                  "type": "function_result",
                  "name": tool_name,
                  "call_id": tool_id,
                  "result": result
                })
                # Show abbreviated result on success
                result_str = json.dumps(result).replace("\n", " ")
                if len(result_str) > 100:
                  result_str = result_str[:97] + "..."
                print(f"  [Tool Success] {tool_name}: {result_str}")
              except Exception as e:
                print(f"  [Tool Error] {tool_name}: {e}")
                tool_results.append({
                  "type": "function_result",
                  "name": tool_name,
                  "call_id": tool_id,
                  "is_error": True,
                  "result": {"error": str(e)}
                })
            else:
              print(f"  [Tool Error] Tool '{tool_name}' not found.")
              tool_results.append({
                "type": "function_result",
                "name": tool_name,
                "call_id": tool_id,
                "is_error": True,
                "result": {"error": f"Tool '{tool_name}' not found."}
              })

        # Send tool results back
        if tool_results:
          interaction = client.interactions.create(
            model=model_id,
            input=tool_results,
            system_instruction=system_instruction,
            previous_interaction_id=interaction.id,
            tools=TOOLS
          )
        else:
          # Should not happen if status is requires_action
          break

    except (EOFError, KeyboardInterrupt):
      print("\nGoodbye!")
      break
    except Exception as e:
      print(f"\nError during interaction: {e}")
      # Reset session on error to avoid broken chains
      previous_interaction_id = None

if __name__ == "__main__":
  main()
