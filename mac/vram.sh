#!/bin/bash

# See
# https://www.reddit.com/r/LocalLLaMA/comments/186phti/m1m2m3_increase_vram_allocation_with_sudo_sysctl/
# https://www.reddit.com/r/LocalLLaMA/comments/18674zd/macs_with_32gb_of_memory_can_run_70b_models_with/
# https://github.com/ggerganov/llama.cpp/discussions/2182#discussioncomment-7698315

set -eu

mem_size=$(sysctl -n hw.memsize)
let mem_size_mb=($mem_size / 1048576)
echo "Detected $mem_size_mb MiB"
let reserved_mb=($mem_size_mb - 6000)
echo "Reserving $reserved_mb MiB"
echo "Running: sudo sysctl iogpu.wired_limit_mb=$reserved_mb"
sudo sysctl iogpu.wired_limit_mb=$reserved_mb
