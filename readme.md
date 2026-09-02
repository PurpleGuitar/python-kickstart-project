# Python Kickstart Project

This repo provides a basic environment for kickstarting a new Python
project. It has the following features already set up:

- a virtual environment using `venv`
- linting using `mypy` and `ruff`
- testing using `unittest` and `coverage`
- formatting using `ruff` and `pandoc`
- command-line arguments and help using `argparse`
- logging, including setting debug via `--trace`
- Setup for running, debugging, and testing via VS Code
- Running, linting, and testing inside a Docker container

See [docs/kickstart.md](docs/kickstart.md) for the full reference: the
`make` commands, the layout of the files, and troubleshooting notes.

# Quick start

``` bash
make run     # run main.py with debug logging
make lint    # mypy and ruff
make test    # unittest with coverage
```
