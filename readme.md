# Python Kickstart Project

This repo provides a basic environment for kickstarting a new Python
project. It has the following features already set up:

-   a virtual environment using `venv`
-   linting using `mypy` and `pylint`
-   testing using `unittest` and `coverage`
-   formatting using `black` and `pandoc`
-   command-line arguments and help using `argparse`
-   logging, including setting debug via `--trace`
-   Setup for running, debugging, and testing via VS Code

# Files

Main files in this project:

-   `main.py`: Your Python source code goes here.
-   `tests/test_main.py`: Your unit tests can go in this directory.
-   `requirements.txt`: Edit to add or remove library dependencies.
-   `makefile`: Contains commands for `make` to execute.

# Make commands

Use `make` to do basic operations:

-   `make run` to run with debug logs sent to stderr.
-   `make lint` to run mypy and pylint on source and tests.
-   `make test` to discover and run tests with coverage.
-   `make dist` to build an executable in the `dist/` directory.
-   `make format` to reformat Python source files and readme.md.
-   `make clean` to clean up temporary files.

# Virtual Environment

Virtual environment management is automatic. Update `requirements.txt`
to add or remove libraries, and the makefile commands will automatically
call `venv` and `pip` as needed to update the environment.

# Unit testing

Unit tests, including tests for project modules, can all go in the
`tests/` folder. It is already set up as a importable module for
automatic test discovery.

# VS Code

VS Code has been configured for several actions:

-   Run and debug `main.py` with and without tracing.
-   Discover, run, and debug your unit tests in the "Testing" view.
-   To create or update the virtual environment for VS Code, use
    `make .venv`.

# Building

## Multiprocessing on Windows

If building for Windows, and your app uses multiprocessing (e.g. using
[concurrent.futures.ProcessPoolExecutor](https://docs.python.org/3/library/concurrent.futures.html#concurrent.futures.ProcessPoolExecutor)),
you should:

-   use the `--onedir` parameter instead of `--onefile`,
-   Make sure to call multiprocessing.freeze_support() right after your
    program starts, e.g.:

``` python
import multiprocessing

if __name__ == "__main__":
    multiprocessing.freeze_support()
```

For more info, see [Python
docs](https://docs.python.org/3/library/multiprocessing.html#multiprocessing.freeze_support)
and [StackOverflow](https://stackoverflow.com/a/54066043)

# Docker support

Several `make` commands are available that will run in a Docker
container.

-   `make docker-run` to build and run the app in a Docker container.
-   `make docker-lint` to build and lint the app in a Docker container.
-   `make docker-test` to build and test the app in a Docker container.
-   `make docker-build` to build the Docker container.

It's not usually necessary to call `make docker-build` directly; it
should be called automatically if your source files have changed. The
`.docker-built` target controls which files will trigger a rebuild.

These commands do not create or use a virtual environment in your local
workspace.

# Troubleshooting

Sometimes VS Code doesn't start correctly the first time when clicking
the "Start Debugging" action from the "Run and Debug" panel. Wait for it
to time out, then try the action again.

If VS Code doesn't seem to be picking up your modules, you may need to
use the command "Python: select interpreter" to select the one in the
project's virtual environment directory: `./.venv/bin/python`

If you need to force an update to the project dependencies, you can
`touch requirements.txt` and then execute any `make` command,
e.g. `make .venv`, to detect the change and update the dependencies.

If you need to force a rebuild of the virtual environment from scratch,
you can delete it using `make clean`, and then execute any `make`
command, e.g. `make .venv`, to re-create the virtual environment.
