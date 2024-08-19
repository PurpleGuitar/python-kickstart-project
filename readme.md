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

# Usage

Main files in this project:

-   `main.py`: Your Python source code goes here.
-   `test_main.py`: Your unit tests go here.
-   `requirements.txt`: Edit to add or remove Python library
    dependencies.
-   `makefile`: Contains commands for `make` to execute.

Use `make` to do basic operations:

-   `make run` to run the program.
-   `make run-trace` to run with debug logs sent to stderr.
-   `make lint` to run mypy and pylint on the Python source files.
-   `make test` to discover and run tests with coverage.
-   `make format` to reformat Python source files and readme.md.

Virtual environment management is automatic. Update `requirements.txt`
to add or remove libraries, and the makefile commands will automatically
call `venv` and `pip` as needed to update the environment.

# Troubleshooting

If you need to force an update to the virtual environment, just
`touch requirements.txt`. The next `make` command will call `pip` to
re-process dependencies.

If you need to force a rebuild of the virtual environment from scratch,
you can delete it using `make clean`. The next `make` command will
re-create it.
