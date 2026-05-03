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

import unittest
import os
import tempfile
import shutil
import subprocess
from check_standards import check_file

class TestCheckStandards(unittest.TestCase):
  def setUp(self):
    self.test_dir = tempfile.mkdtemp()

  def tearDown(self):
    shutil.rmtree(self.test_dir)

  def create_test_file(self, name, content):
    file_path = os.path.join(self.test_dir, name)
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    with open(file_path, "w", encoding="utf-8") as f:
      f.write(content)
    return file_path

  def test_valid_shell_script(self):
    content = (
        "#!/bin/bash\n"
        "# Copyright 2026 Rouslan Solomakhin\n"
        "# Licensed under the Apache License, Version 2.0\n"
        "echo hello"
    )
    path = self.create_test_file("test.sh", content)
    self.assertEqual(check_file(path), [])

  def test_missing_shebang(self):
    content = (
        "# Copyright 2026 Rouslan Solomakhin\n"
        "# Licensed under the Apache License, Version 2.0\n"
        "echo hello"
    )
    path = self.create_test_file("install", content) # install requires shebang
    errors = check_file(path)
    self.assertTrue(any("Missing shebang" in e for e in errors))

  def test_missing_license(self):
    content = (
        "#!/bin/bash\n"
        "# Copyright 2026 Rouslan Solomakhin\n"
        "echo hello"
    )
    path = self.create_test_file("test.sh", content)
    errors = check_file(path)
    self.assertTrue(
        any("Missing Apache 2.0 license header" in e for e in errors))

  def test_markdown_skipped(self):
    content = "# Just a header\nNo license here."
    path = self.create_test_file("README.md", content)
    self.assertEqual(check_file(path), [])

  def test_src_file_no_shebang_allowed(self):
    # Files in src/ are often sourced and don't need shebangs, but need
    # licenses.
    content = (
        "# Copyright 2026 Rouslan Solomakhin\n"
        "# Licensed under the Apache License, Version 2.0\n"
        "alias ll=\"ls -l\""
    )
    path = self.create_test_file("src/bashrc", content)
    self.assertEqual(check_file(path), [])

  def test_src_file_missing_license(self):
    content = "# Copyright 2026 Rouslan Solomakhin\nalias ll=\"ls -l\""
    path = self.create_test_file("src/bashrc", content)
    errors = check_file(path)
    self.assertTrue(
        any("Missing Apache 2.0 license header" in e for e in errors))

  def test_python_quote_consistency_fail(self):
    content = (
        "#!/usr/bin/env python3\n"
        "# Copyright 2026 Rouslan Solomakhin\n"
        "# Licensed under the Apache License, Version 2.0\n"
        "s1 = \"double\"\n"
        "s2 = 'single'"
    )
    path = self.create_test_file("test.py", content)
    errors = check_file(path)
    self.assertTrue(any("Inconsistent string quotes" in e for e in errors))

  def test_python_docstring_fail(self):
    content = (
        "#!/usr/bin/env python3\n"
        "# Copyright 2026 Rouslan Solomakhin\n"
        "# Licensed under the Apache License, Version 2.0\n"
        "'''Single quoted docstring'''\n"
        "def foo():\n"
        "  pass"
    )
    path = self.create_test_file("test.py", content)
    errors = check_file(path)
    self.assertTrue(
        any("Docstring must use double quotes" in e for e in errors))

  def test_python_valid_style(self):
    content = (
        "#!/usr/bin/env python3\n"
        "# Copyright 2026 Rouslan Solomakhin\n"
        "# Licensed under the Apache License, Version 2.0\n"
        "\"\"\"Double quoted docstring\"\"\"\n"
        "s1 = \"double\"\n"
        "s2 = \"double also\""
    )
    path = self.create_test_file("test.py", content)
    self.assertEqual(check_file(path), [])

  def test_python_indent_2_space_pass(self):
    content = (
        "#!/usr/bin/env python3\n"
        "# Copyright 2026 Rouslan Solomakhin\n"
        "# Licensed under the Apache License, Version 2.0\n"
        "if True:\n"
        "  print(\"Hello 2 space indent world\")"
    )
    path = self.create_test_file("test.py", content)
    self.assertEqual(check_file(path), [])

  def test_python_indent_4_space_fail(self):
    content = (
        "#!/usr/bin/env python3\n"
        "# Copyright 2026 Rouslan Solomakhin\n"
        "# Licensed under the Apache License, Version 2.0\n"
        "if True:\n"
        "    print(\"Hello 4 space indent world\")"
    )
    path = self.create_test_file("test.py", content)
    errors = check_file(path)
    self.assertTrue(
        any("Indentation increment is not 2 spaces" in e for e in errors))

  def test_python_tab_indent_fail(self):
    content = (
        "#!/usr/bin/env python3\n"
        "# Copyright 2026 Rouslan Solomakhin\n"
        "# Licensed under the Apache License, Version 2.0\n"
        "def foo():\n"
        "\tpass"
    )
    path = self.create_test_file("test.py", content)
    errors = check_file(path)
    self.assertTrue(any("Tab used for indentation" in e for e in errors))

  def test_copyright_year_change_fail(self):
    # We need to run this in a real git repo.
    subprocess.run(["git", "init"], cwd=self.test_dir,
                   stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    # Git needs a user to commit.
    subprocess.run(["git", "config", "user.email", "test@example.com"],
                   cwd=self.test_dir)
    subprocess.run(["git", "config", "user.name", "Test User"],
                   cwd=self.test_dir)
    
    content = (
        "# Copyright 2017 Rouslan Solomakhin\n"
        "# Licensed under the Apache License, Version 2.0"
    )
    path = self.create_test_file("test.sh", content)
    subprocess.run(["git", "add", "test.sh"], cwd=self.test_dir,
                   stdout=subprocess.PIPE)
    subprocess.run(["git", "commit", "-m", "initial"], cwd=self.test_dir,
                   stdout=subprocess.PIPE)
    
    # Now change the year in the working directory.
    with open(path, "w") as f:
      f.write("# Copyright 2015 Rouslan Solomakhin\n"
              "# Licensed under the Apache License, Version 2.0")
      
    orig_cwd = os.getcwd()
    os.chdir(self.test_dir)
    try:
      errors = check_file("test.sh")
      self.assertTrue(any("Copyright year changed" in e for e in errors))
    finally:
      os.chdir(orig_cwd)

if __name__ == "__main__":
  unittest.main()
