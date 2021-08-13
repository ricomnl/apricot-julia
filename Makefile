.PHONY: .venv format test clean

PROJECT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROFILE = default
PROJECT_NAME = apricot-julia

.venv:
	poetry install

kernel: .venv
	poetry run python -m ipykernel install --user --name ${PROJECT_NAME}

format: .venv
	poetry run isort .
	poetry run black .
	poetry run flake8 .

test: .venv
	poetry run python -m pytest --durations=0 -s $(FILTER)

## Delete all compiled Python files
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete
