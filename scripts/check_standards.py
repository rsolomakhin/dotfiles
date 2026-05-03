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

from __future__ import annotations
import ast
from dataclasses import dataclass, asdict
import io
import json
import os
import re
import subprocess
import sys
import tokenize

_SUCCESS = 0
_FAILURE = 1

@dataclass(frozen=True)
class StandardError:
  """A standard compliance error.

  Attributes:
    file: The path to the file with the error.
    message: The error message.
    line: The line number where the error occurred, or None if not applicable.
  """
  file: str
  message: str
  line: int | None = None

# Files that should have a shebang.
SHEBANG_REQUIRED = {
    "install",
    "test",
}

# Directories and extensions to check for license headers.
LICENSE_REQUIRED_EXT = {
    ".sh", ".py", ".bat", ".conf", ".vim", ".vimrc", ".bashrc", ".profile",
    ".zshrc", ".emacs", ".eslintrc", ".gitconfig", ".Xresources", ".cvsignore"
}
LICENSE_REQUIRED_FILES = {"install", "test"}

LICENSE_TEXT = "Licensed under the Apache License, Version 2.0"
COPYRIGHT_RE = re.compile(r"Copyright (\d{4}) Rouslan Solomakhin")
URL_RE = re.compile(r"https?://")

def is_docstring(
    token: tokenize.TokenInfo,
    prev_token: tokenize.TokenInfo | None) -> bool:
  """Check if a token is a docstring.

  Args:
    token: The token to check.
    prev_token: The previous token.

  Returns:
    True if the token is likely a docstring.
  """
  if token.type != tokenize.STRING:
    return False
  # Docstrings follow an INDENT or are at the start of a module/class/function.
  if prev_token is None or prev_token.type in {
      tokenize.INDENT, tokenize.NL, tokenize.NEWLINE}:
    # Simple heuristic: if it's a string literal on its own line (or after
    # indent) it's likely a docstring.
    return True
  return False

def check_python_style(file_path: str) -> list[StandardError]:
  """Verify string quote consistency, double-quoted docstrings, and indent.

  Args:
    file_path: The path to the file to check.

  Returns:
    A list of StandardError objects.
  """
  errors = []
  try:
    with open(file_path, "rb") as f:
      tokens = list(tokenize.tokenize(f.readline))
  except Exception as e:
    return [StandardError(
        file=file_path,
        message=f"Could not tokenize {file_path}: {e}"
    )]

  quotes_used = set()
  prev_token = None
  indent_stack = [0]

  for token in tokens:
    # Check indentation.
    if token.type == tokenize.INDENT:
      indent_str = token.string
      if "\t" in indent_str:
        errors.append(StandardError(
            file=file_path,
            line=token.start[0],
            message="Tab used for indentation"
        ))

      expected_indent = indent_stack[-1] + 2
      actual_indent = len(indent_str)
      if actual_indent != expected_indent:
        errors.append(StandardError(
            file=file_path,
            line=token.start[0],
            message=(f"Indentation increment is not 2 spaces "
                     f"(expected {expected_indent}, found {actual_indent})")
        ))
      indent_stack.append(actual_indent)
    elif token.type == tokenize.DEDENT:
      indent_stack.pop()

    # Check quotes.
    if token.type == tokenize.STRING:
      s = token.string
      # Remove prefixes like u, r, f, b
      prefix = ""
      for char in s.lower():
        if char in "urfb":
          prefix += char
        else:
          break
      core_string = s[len(prefix):]

      is_doc = is_docstring(token, prev_token)

      if is_doc:
        if (not core_string.startswith("\"\"\"") and
            not core_string.startswith("\"")):
          errors.append(StandardError(
              file=file_path,
              line=token.start[0],
              message="Docstring must use double quotes"
          ))
      else:
        if core_string.startswith("'") or core_string.startswith("'''"):
          quotes_used.add("'")
        elif core_string.startswith("\"") or core_string.startswith("\"\"\""):
          quotes_used.add("\"")

    if token.type not in {tokenize.NL, tokenize.COMMENT, tokenize.ENCODING}:
      prev_token = token

  if len(quotes_used) > 1:
    errors.append(StandardError(
        file=file_path,
        message=("Inconsistent string quotes: found both single and "
                 "double quotes")
    ))

  return errors

def get_committed_copyright_year(file_path: str) -> str | None:
  """Get the copyright year from the version of the file in HEAD.

  Args:
    file_path: The path to the file to check.

  Returns:
    The copyright year as a string, or None if not found.
  """
  try:
    result = subprocess.run(
        ["git", "show", f"HEAD:{file_path}"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        check=True,
    )
    match = COPYRIGHT_RE.search(result.stdout)
    if match:
      return match.group(1)
  except subprocess.CalledProcessError:
    pass
  return None

def check_python_ast(file_path: str) -> list[StandardError]:
  """Verify type annotations and docstring content using AST.

  Args:
    file_path: The path to the file to check.

  Returns:
    A list of StandardError objects.
  """
  errors = []
  try:
    with open(file_path, "r", encoding="utf-8") as f:
      content = f.read()
    tree = ast.parse(content)
  except Exception as e:
    return [StandardError(
        file=file_path,
        message=f"Could not parse {file_path}: {e}"
    )]

  for node in ast.walk(tree):
    if isinstance(node, ast.FunctionDef):
      # Check for type annotations on arguments.
      for arg in node.args.args:
        if arg.arg not in ("self", "cls") and arg.annotation is None:
          errors.append(StandardError(
              file=file_path,
              line=node.lineno,
              message=f"Missing type hint for argument '{arg.arg}'"
          ))

      is_test_func = (
          file_path.endswith("_test.py") and node.name.startswith("test_"))
      if node.returns is None and node.name != "__init__" and not is_test_func:
        errors.append(StandardError(
            file=file_path,
            line=node.lineno,
            message="Missing return type hint"
        ))

      # Check for Args: in docstring if there are arguments.
      doc = ast.get_docstring(node)
      if doc:
        has_params = any(
            arg.arg not in ("self", "cls") for arg in node.args.args)
        if has_params and "Args:" not in doc:
          errors.append(StandardError(
              file=file_path,
              line=node.lineno,
              message="Docstring missing 'Args:' section"
          ))

        # Check for Returns: in docstring if it returns something other
        # than None.
        returns_something = False
        if node.returns is not None:
          if isinstance(node.returns, ast.Name) and node.returns.id != "None":
            returns_something = True
          elif (isinstance(node.returns, ast.Constant) and
                node.returns.value is not None):
            returns_something = True
          elif not isinstance(node.returns, (ast.Name, ast.Constant)):
            # Complex types like List[int] or Optional[str]
            returns_something = True

        if returns_something and "Returns:" not in doc:
          errors.append(StandardError(
              file=file_path,
              line=node.lineno,
              message="Docstring missing 'Returns:' section"
          ))
  return errors
def check_file(file_path: str) -> list[StandardError]:
  """Check a single file for standards compliance.

  Args:
    file_path: The path to the file to check.

  Returns:
    A list of StandardError objects.
  """
  errors = []
  base_name = os.path.basename(file_path)
  _, ext = os.path.splitext(file_path)

  # Skip markdown files as they are part of agentic memory.
  if ext == ".md":
    return []

  # Skip Vim configuration as it's hard to keep within 80 chars and
  # maintain readability/correctness.
  if file_path == "src/vimrc" or file_path.startswith("src/vim/"):
    return []

  try:
    with open(file_path, "r", encoding="utf-8") as f:
      lines = f.readlines()
  except Exception as e:
    return [StandardError(
        file=file_path,
        message=f"Could not read {file_path}: {e}"
    )]

  if not lines:
    return []

  # Check line length and trailing whitespace.
  if not file_path.startswith("windows/"):
    for i, line in enumerate(lines):
      line_content = line.rstrip("\n")
      if len(line_content) > 80:
        # Skip if line contains a URL.
        if URL_RE.search(line_content):
          pass
        else:
          errors.append(StandardError(
              file=file_path,
              line=i + 1,
              message=f"Line is too long ({len(line_content)} > 80)"
          ))

      if line_content.endswith(" ") or line_content.endswith("\t"):
        errors.append(StandardError(
            file=file_path,
            line=i + 1,
            message="Trailing whitespace"
        ))

  # Check for shebang if required.
  if base_name in SHEBANG_REQUIRED or ext in {".sh", ".py"}:
    if "src/" not in file_path:
      if not lines[0].startswith("#!"):
        errors.append(StandardError(
            file=file_path,
            message="Missing shebang"
        ))

  # Check for license header and copyright year.
  content = "".join(lines[:20])
  if LICENSE_TEXT not in content:
    if (ext in LICENSE_REQUIRED_EXT or base_name in LICENSE_REQUIRED_FILES or
        "src/" in file_path):
      errors.append(StandardError(
          file=file_path,
          message="Missing Apache 2.0 license header"
      ))
  else:
    # Verify copyright year hasn't changed from the committed version.
    match = COPYRIGHT_RE.search(content)
    if match:
      current_year = match.group(1)
      committed_year = get_committed_copyright_year(file_path)
      if committed_year and current_year != committed_year:
        errors.append(StandardError(
            file=file_path,
            message=(f"Copyright year changed: found {current_year}, "
                     f"expected {committed_year} (from committed version)")
        ))
    elif (ext in LICENSE_REQUIRED_EXT or base_name in LICENSE_REQUIRED_FILES or
          "src/" in file_path):
      errors.append(StandardError(
          file=file_path,
          message="Missing Copyright header"
      ))

  # Python specific style checks.
  if ext == ".py":
    errors.extend(check_python_style(file_path))
    errors.extend(check_python_ast(file_path))

  return errors

def get_all_errors() -> list[StandardError]:
  """Get all standards errors in the repository.

  Returns:
    A list of StandardError objects.
  """
  # Get all tracked files using git ls-files.
  try:
    result = subprocess.run(
        ["git", "ls-files"],
        stdout=subprocess.PIPE,
        text=True,
        check=True,
    )
    files_to_check = result.stdout.splitlines()
  except subprocess.CalledProcessError as e:
    return [StandardError(
        file="git",
        message=f"Error running git ls-files: {e!r}"
    )]

  all_errors = []
  for file_path in files_to_check:
    all_errors.extend(check_file(file_path))

  return all_errors

def main() -> int:
  """Main entry point for the standards checker.

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
