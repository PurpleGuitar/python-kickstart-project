"""Tests for main.py"""

import unittest

import main


class MainTest(unittest.TestCase):
    """Tests for main.py"""

    def test_module_imports(self) -> None:
        """main.py imports cleanly and exposes its entry points.

        Importing the module is enough to catch syntax errors, missing
        dependencies, and anything that crashes at import time. Replace
        this with real tests as you fill in main.py.
        """
        self.assertTrue(callable(main.main))
        self.assertTrue(callable(main.cli))


if __name__ == "__main__":
    unittest.main()
