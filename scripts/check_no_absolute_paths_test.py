import unittest
import re
from check_no_absolute_paths import check_line

class TestCheckNoAbsolutePaths(unittest.TestCase):
  def test_absolute_paths(self):
    allow_list = ["/usr/", "/dev/", "/tmp/", "/opt/"]
    test_cases = [
        ("Line with /example/bin/tools", ["/example/bin/tools"]),
        ("Line with %!/example/bin/tools", ["/example/bin/tools"]),
        ("Multiple paths: /example/bin and /etc/passwd", ["/example/bin", "/etc/passwd"]),
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

if __name__ == '__main__':
  unittest.main()
