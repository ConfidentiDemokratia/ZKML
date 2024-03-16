#!/bin/bash

# Create a virtual environment named 'env' if it doesn't already exist
if [ ! -d "env" ]; then
    python3 -m venv env
fi

# Activate the virtual environment
source env/bin/activate

# Install Python packages
pip install --upgrade pip
pip install -r requirements.txt

# Install and use a specific version of solc via solc-select
solc-select install 0.8.20
solc-select use 0.8.20

# Run the Python script
python3 ezkl_process.py model.onnx input.json

# Deactivate the virtual environment
deactivate
