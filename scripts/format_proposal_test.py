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
import argparse
import sys
import contextlib
import io
from format_proposal import get_parser, generate_proposal

class TestFormatProposal(unittest.TestCase):
  def test_get_parser(self):
    parser = get_parser()
    args = parser.parse_args([
        "--title", "Test Title",
        "--suggestion", "Test Suggestion",
        "--issue", "Test Issue",
        "--proposed-code", "Test Proposed Code",
        "--improvement", "Test Improvement",
        "--alternatives", "Test Alternatives"
    ])
    with self.subTest(name="Overview"):
      self.assertEqual(args.title, "Test Title")
      self.assertEqual(args.alternatives, "Test Alternatives")
    with self.subTest(name="Description"):
      self.assertEqual(args.suggestion, "Test Suggestion")
      self.assertEqual(args.issue, "Test Issue")
      self.assertEqual(args.improvement, "Test Improvement")
    with self.subTest(name="Code"):
      self.assertEqual(args.existing_code, "") # Default value
      self.assertEqual(args.proposed_code, "Test Proposed Code")      

  def test_get_parser_missing_args(self):
    parser = get_parser()
    with self.assertRaises(SystemExit):
      with contextlib.redirect_stderr(io.StringIO()):
        parser.parse_args([])

  def test_generate_proposal(self):
    template = "Title: {title}\nSuggestion: {suggestion}\nExisting: {existing_code}\nIssue: {issue}\nProposed: {proposed_code}\nImprovement: {improvement}\nAlternatives: {alternatives}"
    
    class MockArgs:
      def __init__(self):
        self.title = "T"
        self.suggestion = "S"
        self.existing_code = "E"
        self.issue = "I"
        self.proposed_code = "P"
        self.improvement = "Im"
        self.alternatives = "A"
        
    args = MockArgs()
    output = generate_proposal(template, args)
    
    expected = "Title: T\nSuggestion: S\nExisting: E\nIssue: I\nProposed: P\nImprovement: Im\nAlternatives: A"
    self.assertEqual(output, expected)

if __name__ == "__main__":
  unittest.main()
