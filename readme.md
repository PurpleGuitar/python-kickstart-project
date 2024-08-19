# Python Kickstart Project

This repo is intended to provide a basic environment for kickstarting a
new Python project. It has the following features:

-   a virtual environment using `venv`
-   linting using `mypy` and `pylint`
-   testing using `unittest` and `coverage`
-   formatting using `black` and `pandoc`
-   command-line arguments and help using `argparse`
-   logging, including setting debug via `--trace`
-   Basic debugging support for VSCode

# Usage

Use `make` to do basic operations:

-   `make run` to run the program.
-   `make lint` to run mypy and pylint on the Python source files.
-   `make test` to run coverage and unit tests, if any.
-   `make format` to reformat Python source files and readme.md.

Virtual environment management is automatic. Update `requirements.txt`
to add or remove libraries, and the makefile commands will automatically
call `venv` and `pip` as needed to update the environment.

# Troubleshooting

If you need to force an update to the virtual environment, just
`touch requirements.txt`. The environment will rebuild on the next
`make` command.

If you need to force a rebuild of the virtual environment from scratch,
you can delete it using `make clean`, and the next `make` command will
re-create it.
