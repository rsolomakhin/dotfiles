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
        content = "#!/bin/bash\n# Licensed under the Apache License, Version 2.0\necho hello"
        path = self.create_test_file("test.sh", content)
        self.assertEqual(check_file(path), [])

    def test_missing_shebang(self):
        content = "# Licensed under the Apache License, Version 2.0\necho hello"
        path = self.create_test_file("install", content) # install requires shebang
        errors = check_file(path)
        self.assertTrue(any("Missing shebang" in e for e in errors))

    def test_missing_license(self):
        content = "#!/bin/bash\necho hello"
        path = self.create_test_file("test.sh", content)
        errors = check_file(path)
        self.assertTrue(any("Missing Apache 2.0 license header" in e for e in errors))

    def test_markdown_skipped(self):
        content = "# Just a header\nNo license here."
        path = self.create_test_file("README.md", content)
        self.assertEqual(check_file(path), [])

    def test_src_file_no_shebang_allowed(self):
        # Files in src/ are often sourced and don't need shebangs, but need licenses.
        content = "# Licensed under the Apache License, Version 2.0\nalias ll=\"ls -l\""
        path = self.create_test_file("src/bashrc", content)
        self.assertEqual(check_file(path), [])

    def test_src_file_missing_license(self):
        content = "alias ll=\"ls -l\""
        path = self.create_test_file("src/bashrc", content)
        errors = check_file(path)
        self.assertTrue(any("Missing Apache 2.0 license header" in e for e in errors))

    def test_python_quote_consistency_fail(self):
        content = "#!/usr/bin/env python3\n# Licensed under the Apache License, Version 2.0\ns1 = \"double\"\ns2 = 'single'"
        path = self.create_test_file("test.py", content)
        errors = check_file(path)
        self.assertTrue(any("Inconsistent string quotes" in e for e in errors))

    def test_python_docstring_fail(self):
        content = "#!/usr/bin/env python3\n# Licensed under the Apache License, Version 2.0\n'''Single quoted docstring'''\ndef foo():\n    pass"
        path = self.create_test_file("test.py", content)
        errors = check_file(path)
        self.assertTrue(any("Docstring must use double quotes" in e for e in errors))

    def test_python_valid_style(self):
        content = "#!/usr/bin/env python3\n# Licensed under the Apache License, Version 2.0\n\"\"\"Double quoted docstring\"\"\"\ns1 = \"double\"\ns2 = \"double also\""
        path = self.create_test_file("test.py", content)
        self.assertEqual(check_file(path), [])

if __name__ == "__main__":
    unittest.main()
