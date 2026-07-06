# Start with a Python environment
FROM python:3.13.7-slim

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

# Set up venv
COPY --chown=appuser:appuser makefile /app
COPY --chown=appuser:appuser requirements.txt /app
RUN make .venv

# Tool configuration (used by make lint / make test)
COPY --chown=appuser:appuser pyproject.toml /app

# Copy the rest of the application code
COPY --chown=appuser:appuser tests/ /app/tests/
COPY --chown=appuser:appuser *.py /app
