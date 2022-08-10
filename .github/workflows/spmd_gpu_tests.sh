#!/bin/bash

set -x

# Print test options
echo "VERBOSE: ${VERBOSE}"

nvidia-smi
nvcc --version
which python3
python3 --version
which pip3
pip3 --version

# Install git
apt-get update
apt-get install git -y

# Install dependencies
# Turn off progress bar to save logs
pip3 install --upgrade pip
pip3 config set global.progress_bar off
pip3 install flake8 pytest pytest-cov pytest-shard numpy expecttest hypothesis
if [ -f requirements.txt ]; then pip3 install -r requirements.txt --find-links https://download.pytorch.org/whl/nightly/cu102/torch_nightly.html; fi

# Install pavel's huggingface fork
pip3 install git+https://github.com/huggingface/transformers.git@main sentencepiece

# Install pippy
python3 setup.py install
python3 spmd/setup.py install

# Run all integration tests
# python3 test/spmd/tensor/test_megatron_example.py
# python3 test/spmd/tensor/test_ddp.py
python3 test/spmd/tensor/test_tp_sharding_ops.py
