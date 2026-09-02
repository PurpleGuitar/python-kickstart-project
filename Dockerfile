# Start with a Python environment
FROM python:3.14.4-slim

# Install make
RUN apt-get update && apt-get install -y make

# Clean up apt cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Create an unprivileged user to run the application
RUN useradd --create-home appuser

# Set the working directory and hand it to the unprivileged user
WORKDIR /app
RUN chown appuser:appuser /app

# Drop root privileges for everything that follows
USER appuser

# Set up venv. Only the two files `make .venv` reads are copied first, so this
# expensive layer stays cached when application code changes. Note that
# pyproject.toml also holds lint and test configuration, so editing a ruff rule
# invalidates the layer and reinstalls dependencies.
COPY --chown=appuser:appuser makefile /app
COPY --chown=appuser:appuser pyproject.toml /app
RUN make .venv

# Copy the rest of the application code. This copies everything not listed in
# .dockerignore, so user-created modules, packages and data files are picked up
# without editing this file.
COPY --chown=appuser:appuser . /app
