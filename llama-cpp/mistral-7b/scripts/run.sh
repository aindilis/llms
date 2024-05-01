#!/bin/bash

exit 1;

cd /var/lib/myfrdcsa/sandbox/llama.cpp-20231015/llama.cpp-20231015

. /var/lib/myfrdcsa/codebases/internal/myfrdcsa/scripts/start-conda.sh

conda activate llama-cpp

# conda create -n llama-cpp python=3.10.9
# conda activate llama-cpp
# python3 -m pip install -r requirements.txt
# 
# export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}$ 
# (llama-cpp) andrewdo@ai2:/var/lib/myfrdcsa/sandbox/llama.cpp-20231015/llama.cpp-20231015$ export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

./main -ngl 32 -m ~/mistral-7b-instruct-v0.1.Q4_K_M.gguf --color -c 4096 --temp 0.7 --repeat_penalty 1.1 -n -1 -p "<s>[INST]{prompt} [/INST]" -i
