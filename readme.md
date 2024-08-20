# Python Kickstart Project

This repo provides a basic environment for kickstarting a new Python
project. It has the following features already set up:

-   a virtual environment using `venv`
-   linting using `mypy` and `pylint`
-   testing using `unittest` and `coverage`
-   formatting using `black` and `pandoc`
-   command-line arguments and help using `argparse`
-   logging, including setting debug via `--trace`
-   Basic debugging support for VSCode

# Files

Main files in this project:

-   `main.py`: Your Python source code goes here.
-   `tests/test_main.py`: Your unit tests go here.
-   `requirements.txt`: Edit to add or remove library dependencies.
-   `makefile`: Contains commands for `make` to execute.

# Make commands

Use `make` to do basic operations:

-   `make run` to run the program.
-   `make run-trace` to run with debug logs sent to stderr.
-   `make lint` to run mypy and pylint on source and tests.
-   `make test` to discover and run tests with coverage.
-   `make format` to reformat Python source files and readme.md.

# Virtual Environment

Virtual environment management is automatic. Update `requirements.txt`
to add or remove libraries, and the makefile commands will automatically
call `venv` and `pip` as needed to update the environment.

# Unit testing

Unit tests, including tests for project modules, can all go in the
`tests/` folder. It is already set up as a importable module for
automatic test discovery.

In VSCode, you can see, run, and debug your tests from the "Testing" View.

# Troubleshooting

If you need to force an update to the virtual environment, just
`touch requirements.txt`. The next `make` command will call `pip` to
re-process dependencies.

If you need to force a rebuild of the virtual environment from scratch,
you can delete it using `make clean`. The next `make` command will
re-create it.
