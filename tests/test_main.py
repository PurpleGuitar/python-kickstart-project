"""Tests for main.py"""

# Standard imports
from argparse import Namespace
import unittest

# Library imports

# Project imports
import main


class MainTest(unittest.TestCase):
    """Tests for main.py"""

    def test_main_returns_zero(self) -> None:
        """main() should report success with a 0 exit code."""
        args = Namespace(trace=False)
        self.assertEqual(main.main(args), 0)


if __name__ == "__main__":  # pragma: no cover
    unittest.main()
