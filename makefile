#
# Run app
#

.PHONY: run
run: .venv
	. .venv/bin/activate && python3 main.py --trace

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
	. .venv/bin/activate && python3 -m mypy --strict *.py tests/*.py

.PHONY: pylint
pylint: .venv
	. .venv/bin/activate && python3 -m pylint --jobs 4 --output-format=colorized *.py tests/*.py

.PHONY: lint
lint: .venv mypy pylint

#
# Testing
#

.PHONY: test
test: .venv
	. .venv/bin/activate \
	&& python3 -m coverage run --branch -m unittest discover -s tests -v \
	&& python3 -m coverage report \
	&& python3 -m coverage html

#
# Watch directories for changes
#

.PHONY: lint-watch
lint-watch:
	while inotifywait -e close_write,moved_to,create . tests; do \
		clear; \
		$(MAKE) lint; \
	done

.PHONY: test-watch
test-watch:
	while inotifywait -e close_write,moved_to,create . tests; do \
		clear; \
		$(MAKE) test; \
	done

.PHONY: lint-test-watch
lint-test-watch:
	while inotifywait -e close_write,moved_to,create . tests; do \
		clear; \
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
	${EDITOR} readme.md main.py *.py tests/*.py makefile requirements.txt .gitignore

.PHONY: format
format: .venv
	. .venv/bin/activate && python -m black *.py tests/*.py
	pandoc readme.md --from markdown --to markdown --output readme.md

#
# Cleanup
#

.PHONY: clean
clean:
	rm -rf .mypy_cache
	rm -rf .venv
	rm -rf __pycache__
	rm -rf test/__pycache__
	rm -rf htmlcov
	rm -f .coverage
	rm -rf build
	rm -rf dist

# 
# Docker 
# 

.PHONY: docker-run
docker-run: docker-build
	test -n "$(DOCKER_IMAGE)" || (echo "DOCKER_IMAGE is not set" && exit 1)
	docker run --rm -it $(DOCKER_IMAGE) make run

.PHONY: docker-test
docker-test: docker-build
	test -n "$(DOCKER_IMAGE)" || (echo "DOCKER_IMAGE is not set" && exit 1)
	docker run --rm -it $(DOCKER_IMAGE) make test

.PHONY: docker-lint
docker-lint: docker-build
	test -n "$(DOCKER_IMAGE)" || (echo "DOCKER_IMAGE is not set" && exit 1)
	docker run --rm -it $(DOCKER_IMAGE) make lint

.PHONY: docker-build
docker-build: .docker-built

.docker-built: Dockerfile makefile requirements.txt main.py $(wildcard *.py) $(wildcard tests/*.py)
	test -n "$(DOCKER_IMAGE)" || (echo "DOCKER_IMAGE is not set" && exit 1)
	docker build -t $(DOCKER_IMAGE) .
	touch .docker-built
