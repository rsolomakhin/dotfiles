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
import re
from check_no_absolute_paths import check_line

class TestCheckNoAbsolutePaths(unittest.TestCase):
  def test_absolute_paths(self):
    allow_list = ["/usr/", "/dev/", "/tmp/", "/opt/"]
    test_cases = [
        ("Line with /example/bin/tools", ["/example/bin/tools"]),
        ("Line with %!/example/bin/tools", ["/example/bin/tools"]),
        ("Multiple paths: /example/bin and /etc/passwd",
         ["/example/bin", "/etc/passwd"]),
    ]
    for line, expected in test_cases:
      with self.subTest(line=line):
        self.assertEqual(check_line(line, allow_list), expected)

  def test_allowed_and_relative_paths(self):
    allow_list = ["/usr/", "/dev/", "/tmp/", "/opt/"]
    test_cases = [
        "Line with ./scripts/foo",
        "Line with ~/vimfiles/foo",
        "Line with /usr/bin/env",
        "Line with /tmp/test",
        "Not a path /foo", # Only one segment
        "https://example.com/foo/bar",
    ]
    for line in test_cases:
      with self.subTest(line=line):
        self.assertEqual(check_line(line, allow_list), [])

if __name__ == "__main__":
  unittest.main()
