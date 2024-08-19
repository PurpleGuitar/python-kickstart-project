# Python Kickstart Project

This repo is intended to provide a basic environment for kickstarting a new
Python project.  It has the following features:

- a virtual environment using venv
- linting 
- testing 
- formatting 
- command-line arguments and help
- logging, including enabling debug logging using `--trace`
- Basic debugging support for VSCode

# Usage

Use `make` to do basic operations:

- `make run` to run the program.
- `make lint` to run mypy and pylint on the files.
- `make test` to run coverage and unit tests, if any.
- `make format` to reformat Python files using `black`.

The makefile will do the work of building and maintaining your virtual environment as needed. It will automatically detect when you make changes to `requirements.txt` and update the virtual environment as needed. 

If you want to force an update just `touch requirements.txt`.  If you need to rebuild the virtual environment from scratch, you can delete it using `make clean` and it will rebuild on the next make command.
