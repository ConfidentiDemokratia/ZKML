#!/bin/bash

# Install Python packages
pip install -r requirements.txt

# Install and use a specific version of solc via solc-select
solc-select install 0.8.20
solc-select use 0.8.20

# Run the Python script
python3 ezkl_process.py network.onnx input.json
