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
import io
import sys
import json
import builtins
from unittest.mock import patch, mock_open
import format_proposal

class TestFormatProposal(unittest.TestCase):

  def test_format_proposal_success(self) -> None:
    data = {
        "title": "T",
        "suggestion": "S",
        "existing_code": "E",
        "issue": "I",
        "proposed_code": "P",
        "improvement": "Im",
        "alternatives": "A"
    }
    mock_stdin = io.StringIO(json.dumps(data))
    mock_stdout = io.StringIO()

    template_content = (
        "{title} {suggestion} {existing_code} {issue} "
        "{proposed_code} {improvement} {alternatives}"
    )

    with patch.object(sys, "stdin", mock_stdin):
      with patch.object(sys, "stdout", mock_stdout):
        with patch.object(builtins, "open",
                          mock_open(read_data=template_content),
                          spec_set=True):
          result = format_proposal.format_proposal()

    self.assertEqual(result, 0)
    self.assertIn("T S E I P Im A", mock_stdout.getvalue())

  def test_format_proposal_invalid_json(self) -> None:
    mock_stdin = io.StringIO("not json")
    mock_stderr = io.StringIO()

    with patch.object(sys, "stdin", mock_stdin):
      with patch.object(sys, "stderr", mock_stderr):
        result = format_proposal.format_proposal()

    self.assertEqual(result, 1)
    self.assertIn("Error: Invalid JSON input", mock_stderr.getvalue())

  def test_format_proposal_missing_key(self) -> None:
    mock_stdin = io.StringIO(json.dumps({"title": "T"}))
    mock_stderr = io.StringIO()

    with patch.object(sys, "stdin", mock_stdin):
      with patch.object(sys, "stderr", mock_stderr):
        result = format_proposal.format_proposal()

    self.assertEqual(result, 1)
    self.assertIn("Error: Missing required key", mock_stderr.getvalue())

if __name__ == "__main__":
  unittest.main()
