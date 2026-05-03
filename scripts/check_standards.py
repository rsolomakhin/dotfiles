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

import io
import os
import re
import subprocess
import sys
import tokenize

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

def is_docstring(token, prev_token):
    """Check if a token is a docstring."""
    if token.type != tokenize.STRING:
        return False
    # Docstrings follow an INDENT or are at the start of a module/class/function.
    if prev_token is None or prev_token.type in {tokenize.INDENT, tokenize.NL, tokenize.NEWLINE}:
        # Simple heuristic: if it's a string literal on its own line (or after indent), it's likely a docstring.
        return True
    return False

def check_python_style(file_path):
    """Verify string quote consistency and double-quoted docstrings."""
    errors = []
    try:
        with open(file_path, "rb") as f:
            tokens = list(tokenize.tokenize(f.readline))
    except Exception as e:
        return [f"Could not tokenize {file_path}: {e}"]

    quotes_used = set()
    prev_token = None
    
    for token in tokens:
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
                if not core_string.startswith("\"\"\"") and not core_string.startswith("\""):
                     errors.append(f"{file_path}:{token.start[0]} Docstring must use double quotes")
                # Docstrings are always double quoted, don't add to quotes_used for consistency check
            else:
                if core_string.startswith("'") or core_string.startswith("'''"):
                    quotes_used.add("'")
                elif core_string.startswith("\"") or core_string.startswith("\"\"\""):
                    quotes_used.add("\"")
        
        if token.type not in {tokenize.NL, tokenize.COMMENT, tokenize.ENCODING}:
            prev_token = token

    if len(quotes_used) > 1:
        errors.append(f"{file_path} Inconsistent string quotes: found both single and double quotes")
    
    return errors

def get_committed_copyright_year(file_path):
    """Get the copyright year from the version of the file in HEAD."""
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

def check_file(file_path):
    errors = []
    base_name = os.path.basename(file_path)
    _, ext = os.path.splitext(file_path)

    # Skip markdown files as they are part of agentic memory.
    if ext == ".md":
        return []

    try:
        with open(file_path, "r", encoding="utf-8") as f:
            lines = f.readlines()
    except Exception as e:
        return [f"Could not read {file_path}: {e}"]

    if not lines:
        return []

    # Check for shebang if required.
    if base_name in SHEBANG_REQUIRED or ext in {".sh", ".py"}:
        if "src/" not in file_path:
            if not lines[0].startswith("#!"):
                errors.append(f"Missing shebang in {file_path}")

    # Check for license header and copyright year.
    content = "".join(lines[:20])
    if LICENSE_TEXT not in content:
        if ext in LICENSE_REQUIRED_EXT or base_name in LICENSE_REQUIRED_FILES or "src/" in file_path:
            errors.append(f"Missing Apache 2.0 license header in {file_path}")
    else:
        # Verify copyright year hasn't changed from the committed version.
        match = COPYRIGHT_RE.search(content)
        if match:
            current_year = match.group(1)
            committed_year = get_committed_copyright_year(file_path)
            if committed_year and current_year != committed_year:
                errors.append(f"{file_path} Copyright year changed: found {current_year}, expected {committed_year} (from committed version)")
        elif ext in LICENSE_REQUIRED_EXT or base_name in LICENSE_REQUIRED_FILES or "src/" in file_path:
            errors.append(f"Missing Copyright header in {file_path}")

    # Python specific style checks.
    if ext == ".py":
        errors.extend(check_python_style(file_path))

    return errors

def main():
    all_errors = []
    
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
        print(f"Error running git ls-files: {e}", file=sys.stderr)
        sys.exit(1)

    for file_path in files_to_check:
        if os.path.isfile(file_path):
            all_errors.extend(check_file(file_path))

    if all_errors:
        for error in all_errors:
            print(f"[Error] {error}")
        sys.exit(1)
    else:
        print("[Success] All files passed standards check.")

if __name__ == "__main__":
    main()
