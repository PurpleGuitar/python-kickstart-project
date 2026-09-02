# Kickstart Reference

Reference documentation for the development environment that came from
[python-kickstart-project](https://github.com/PurpleGuitar/python-kickstart-project).

# Files

Main files in this project:

- `main.py`: Your Python source code goes here.
- `tests/test_main.py`: Your unit tests can go in this directory.
- `readme.md`: Documentation for your project.
- `requirements.txt`: Edit to add or remove library dependencies.
- `pyproject.toml`: Configuration for the tools (ruff, mypy, coverage).
- `makefile`: Contains commands for `make` to execute.
- `Dockerfile`: Defines the container image used by the `docker-*` make
  commands.
- `env.sh`: Sensible defaults for environment variables; source it
  before using the Docker commands.
- `.gitignore`: Pre-configured to ignore caches, build artifacts, and
  the virtual environment.
- `docs/kickstart.md`: This file.

# Make commands

Use `make` to do basic operations:

- `make run` to run with debug logs sent to stderr.
- `make lint` to run mypy and ruff on source and tests.
- `make mypy` or `make ruff` to run just one of the two linters.
- `make test` to discover and run tests with coverage.
- `make dist` to build an executable in the `dist/` directory.
- `make format` to reformat Python source files, apply ruff's lint
  auto-fixes, and reformat the markdown files (requires `pandoc` to be
  installed on your system).
- `make edit` to open the project files in your `$EDITOR`.
- `make .venv` to create or update the virtual environment.
- `make clean` to clean up temporary files.

## Passing arguments to your app

`make run` passes the contents of the `ARGS` variable to `main.py`.
`ARGS` defaults to `--trace`, which is why a bare `make run` produces
debug logs. To pass your own arguments, set it on the command line:

``` bash
make run ARGS="path/to/file.txt"
```

Setting `ARGS` *replaces* the default, so include `--trace` yourself if
you also want debug logging:

``` bash
make run ARGS="path/to/file.txt --trace"
```

`make docker-run` accepts `ARGS` the same way and forwards it into the
container.

## Watch commands

These commands re-run automatically whenever a Python source file
changes (they require `inotifywait`, from the `inotify-tools` package):

- `make run-watch` to re-run the app on changes.
- `make lint-watch` to re-lint on changes.
- `make test-watch` to re-test on changes.
- `make lint-test-watch` to lint and then test on changes.

# Virtual Environment

Virtual environment management is automatic. Update `requirements.txt`
to add or remove libraries, and the makefile commands will automatically
call `venv` and `pip` as needed to update the environment.

# Python version

The project targets a single Python version, pinned in two places:

- `Dockerfile`: the `python:` base image tag.
- `pyproject.toml`: ruff's `target-version` and mypy's `python_version`.

Both currently target Python 3.14. Change them together when moving to a
new version. Your local `.venv` is built from whatever `python3`
resolves to on your system, so keep that in step too.

# Unit testing

A `tests/` folder is already set up as an importable module for
automatic test discovery. It has an example test inside it.

Tests are run using `coverage`. The project enforces a minimum test
coverage threshold of **80%** (configured in `pyproject.toml`). If
coverage falls below this threshold, the `make test` command will fail.

If you prefer to keep your unit tests alongside your main code instead
of in a `tests/` directory, that's fine; the test commands will work
either way. Wherever you put your tests, the files should be named to
match the `test*.py` pattern (for example, `test_main.py`) to be
discoverable.

If you put your tests into a different subdirectory (for example, in a
`module_xxx/tests` subdirectory), don't forget to include an
`__init__.py` file in the subdirectory root, otherwise `unittest` won't
be able to discover the test files.

# VS Code

VS Code has been configured for several actions:

- Run and debug `main.py` with and without tracing.
- Discover, run, and debug your unit tests in the "Testing" view.
- To create or update the virtual environment for VS Code, use
  `make .venv`.

# Building

## Multiprocessing on Windows

If building for Windows, and your app uses multiprocessing (e.g. using
[concurrent.futures.ProcessPoolExecutor](https://docs.python.org/3/library/concurrent.futures.html#concurrent.futures.ProcessPoolExecutor)),
you should:

- use the `--onedir` parameter instead of `--onefile`,
- Make sure to call multiprocessing.freeze_support() right after your
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
container. Before using them, you may wish to source `env.sh` to
configure sensible default environment variables (such as
`DOCKER_IMAGE`):

``` bash
source env.sh
```

- `make docker-run` to build and run the app in a Docker container.
- `make docker-lint` to build and lint the app in a Docker container.
- `make docker-test` to build and test the app in a Docker container.
- `make docker-shell` to build the container and open an interactive
  `bash` shell inside it.
- `make docker-build` to build the Docker container.
- `make docker-clean` to remove the Docker image and rebuild marker.

It's not usually necessary to call `make docker-build` directly; it
should be called automatically if your source files have changed. The
`.docker-built` target controls which files will trigger a rebuild.

These commands do not create or use a virtual environment in your local
workspace.

# Troubleshooting

## Debugging in VS Code

Sometimes VS Code doesn't start correctly the first time when clicking
the "Start Debugging" action from the "Run and Debug" panel. Cancel it
or wait for it to time out, then try the action again.

## Linting in VS Code

If VS Code doesn't seem to be picking up your modules, you may need to
use the command "Python: select interpreter" to select the one in the
project's virtual environment directory: `./.venv/bin/python`

## Updating the virtual environment

If you need to force an update to the project dependencies, you can
`touch requirements.txt` and then execute any `make` command,
e.g. `make run` or `make .venv`, to detect the change and update the
dependencies.

If you need to force a rebuild of the virtual environment from scratch,
you can delete it using `make clean`, and then execute any `make`
command, e.g. `make run` or `make .venv`, to re-create the virtual
environment.
