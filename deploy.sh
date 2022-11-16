#!/bin/bash
poetry run brownie run scripts/deploy.py
poetry run python scripts/operator.py
