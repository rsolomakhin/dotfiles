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
import subprocess
import json
from google import genai

def shell_execute(command: str) -> dict:
  """Executes a shell command and returns the output.

  Args:
    command: The shell command to execute.

  Returns:
    A dictionary containing stdout, stderr, and exit_code, or an error message.
  """
  try:
    # Use a timeout to prevent hanging
    result = subprocess.run(
      command, shell=True, capture_output=True, text=True, timeout=30
    )
    return {
      "stdout": result.stdout,
      "stderr": result.stderr,
      "exit_code": result.returncode
    }
  except subprocess.TimeoutExpired:
    return {"error": "Command timed out after 30 seconds"}
  except Exception as e:
    return {"error": str(e)}

TOOL_MAP = {
  "shell_execute": {
    "func": shell_execute,
    "requires_permission": True,
  },
}

TOOLS = [
  {
    "type": "function",
    "name": "shell_execute",
    "description": (
      "Executes a shell command in the local environment and returns stdout, "
      "stderr, and exit code. Use this for file operations, git commands, "
      "and system checks."
    ),
    "parameters": {
      "type": "object",
      "properties": {
        "command": {
          "type": "string",
          "description": "The shell command to execute."
        }
      },
      "required": ["command"]
    }
  },
  {"type": "google_search"}
]

def main() -> None:
  # Check for GEMINI_API_KEY
  api_key = os.environ.get("GEMINI_API_KEY")
  if not api_key:
    print("Error: GEMINI_API_KEY environment variable is not set.")
    sys.exit(1)

  # Initialize client
  try:
    client = genai.Client()
  except Exception as e:
    print(f"Error initializing client: {e}")
    sys.exit(1)

  model_id = "gemini-3-flash-preview"
  previous_interaction_id = None

  # Initialize system instruction
  system_instruction = ""

  # Load Project Overview (README.md)
  if os.path.exists("README.md"):
    try:
      with open("README.md", "r") as f:
        system_instruction += "# Project Overview\n\n" + f.read() + "\n\n"
    except Exception as e:
      print(f"Warning: Could not read README.md: {e}")

  # Load Legal & Terms (TERMS.md)
  if os.path.exists("TERMS.md"):
    try:
      with open("TERMS.md", "r") as f:
        system_instruction += "# Legal & Terms\n\n" + f.read() + "\n\n"
    except Exception as e:
      print(f"Warning: Could not read TERMS.md: {e}")

  # Load core standards from AGENTS.md (Mandatory)
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
  if os.path.exists("README.md"):
    print("  - README.md")
  if os.path.exists("TERMS.md"):
    print("  - TERMS.md")
  print(f"  - {agents_file}")
  for skill in loaded_skills:
    print(f"  - Skill: {skill}")
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
