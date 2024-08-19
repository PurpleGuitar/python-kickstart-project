.PHONY: run
run: .venv
	. .venv/bin/activate && python3 main.py

.PHONY: run-trace
run-trace: .venv
	. .venv/bin/activate && python3 main.py --trace

.PHONY: lint
lint: .venv
	. .venv/bin/activate && python3 -m mypy --strict *.py 
	. .venv/bin/activate && python3 -m pylint --output-format=colorized *.py 

.PHONY: test
test: .venv
	. .venv/bin/activate \
	&& python3 -m coverage run --branch --source . -m unittest discover \
	&& python3 -m coverage report \
	&& python3 -m coverage html

.PHONY: edit
edit:
	${EDITOR} readme.md makefile main.py *.py **/*.py .gitignore

.PHONY: format
format: .venv
	. .venv/bin/activate \
	&& python -m black *.py

.venv: requirements.txt
	# Create virtual environment
	python3 -m venv .venv
	# Install/update dependencies from requirements.txt
	. .venv/bin/activate; python3 -m pip install -r requirements.txt
	# Update modified date of .venv so that make knows it's been updated
	touch .venv

.PHONY: clean
clean:
	rm -rf .mypy_cache
	rm -rf .venv
	rm -rf __pycache__
	rm -rf htmlcov
	rm -f .coverage