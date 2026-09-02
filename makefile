# All .py files in non-dot subdirectories (exclude virtualenv, build/dist, hidden dirs)
PY_SOURCES := $(shell find . -type f -name '*.py' -not -path './.*' -not -path './.venv/*' -not -path './build/*' -not -path './dist/*')

# All markdown files, reformatted by `make format` and opened by `make edit`
MD_SOURCES := $(shell find . -type f -name '*.md' -not -path './.*' -not -path './.venv/*' | sort)

#
# Run app
#
# Pass arguments to the app using ARGS, e.g.:
#   make run ARGS="~/repos/am_num_text_ulb"
#
# Setting ARGS replaces the default below, so include --trace yourself if
# you want debug logging:
#   make run ARGS="path/to/file.txt --trace"
#

ARGS ?= --trace

.PHONY: run
run: .venv
	. .venv/bin/activate && python3 main.py $(ARGS)

#
# Virtual environment management
#

.venv: requirements.txt
	# Create virtual environment
	python3 -m venv .venv
	# Install/update dependencies from requirements.txt
	. .venv/bin/activate; python3 -m pip install -r requirements.txt
	# Update modified date of .venv so that make knows it's been updated
	touch .venv

#
# Linting
#

.PHONY: mypy
mypy: .venv
	. .venv/bin/activate && python3 -m mypy $(PY_SOURCES)

.PHONY: ruff
ruff: .venv
	. .venv/bin/activate && python3 -m ruff check $(PY_SOURCES)

.PHONY: lint
lint: .venv mypy ruff

#
# Testing
#

.PHONY: test
test: .venv
	. .venv/bin/activate \
	&& python3 -m coverage run -m unittest discover -p "test*.py" \
	&& python3 -m coverage report \
	&& python3 -m coverage html

#
# Watch directories for changes
#

.PHONY: run-watch
run-watch:
	while inotifywait -e close_write,moved_to,create $(PY_SOURCES); do \
		clear; \
		sleep 1; \
		$(MAKE) run; \
	done

.PHONY: lint-watch
lint-watch:
	while inotifywait -e close_write,moved_to,create $(PY_SOURCES); do \
		clear; \
		sleep 1; \
		$(MAKE) lint; \
	done

.PHONY: test-watch
test-watch:
	while inotifywait -e close_write,moved_to,create $(PY_SOURCES); do \
		clear; \
		sleep 1; \
		$(MAKE) test; \
	done

.PHONY: lint-test-watch
lint-test-watch:
	while inotifywait -e close_write,moved_to,create $(PY_SOURCES); do \
		clear; \
		sleep 1; \
		$(MAKE) lint && $(MAKE) test; \
	done

#
# Create distributable package
#

.PHONY: dist
dist: .venv
	. .venv/bin/activate \
	&& pyinstaller --noconfirm --onefile main.py

#
# Editing and Formatting
#

.PHONY: edit
edit:
	${EDITOR} $(MD_SOURCES) main.py $(PY_SOURCES) makefile pyproject.toml requirements.txt .gitignore

.PHONY: format
format: .venv
	. .venv/bin/activate && python3 -m ruff format $(PY_SOURCES)
	. .venv/bin/activate && python3 -m ruff check --fix $(PY_SOURCES)
	for f in $(MD_SOURCES); do \
		pandoc $$f --from markdown --to gfm+smart --output $$f; \
	done

#
# Cleanup
#

.PHONY: clean
clean:
	rm -rf .mypy_cache
	rm -rf .venv
	rm -rf __pycache__
	rm -rf tests/__pycache__
	rm -rf htmlcov
	rm -f .coverage
	rm -rf build
	rm -rf dist

# 
# Docker 
# 

# You can set a sensible default for DOCKER_IMAGE by sourcing env.sh.

# ARGS is forwarded explicitly: the container runs its own `make`, and
# `docker run` does not inherit the host environment, so the host's ARGS
# would otherwise be dropped.

.PHONY: docker-run
docker-run: docker-build
	test -n "$(DOCKER_IMAGE)" || (echo "DOCKER_IMAGE is not set" && exit 1)
	docker run --rm -it $(DOCKER_IMAGE) make run ARGS="$(ARGS)"

.PHONY: docker-test
docker-test: docker-build
	test -n "$(DOCKER_IMAGE)" || (echo "DOCKER_IMAGE is not set" && exit 1)
	docker run --rm -it $(DOCKER_IMAGE) make test

.PHONY: docker-lint
docker-lint: docker-build
	test -n "$(DOCKER_IMAGE)" || (echo "DOCKER_IMAGE is not set" && exit 1)
	docker run --rm -it $(DOCKER_IMAGE) make lint

.PHONY: docker-clean
docker-clean:
	test -n "$(DOCKER_IMAGE)" || (echo "DOCKER_IMAGE is not set" && exit 1)
	docker image rm $(DOCKER_IMAGE) || true
	rm .docker-built || true

.PHONY: docker-build
docker-build: .docker-built

.docker-built: Dockerfile makefile pyproject.toml requirements.txt $(PY_SOURCES)
	# Build the Docker image
	test -n "$(DOCKER_IMAGE)" || (echo "DOCKER_IMAGE is not set" && exit 1)
	docker build -t $(DOCKER_IMAGE) .
	touch .docker-built
