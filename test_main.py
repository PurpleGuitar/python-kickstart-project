""" Tests for main.py """

# Standard imports
import unittest

# Third-party imports

# Project imports
import main


class MainTest(unittest.TestCase):
    """Tests for main.py"""

    def test_testable_function(self) -> None:
        """Example test"""
        self.assertEqual(7, main.testable_function(3, 4))
