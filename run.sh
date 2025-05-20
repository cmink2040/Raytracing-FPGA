#!/usr/bin/env bash
set -euo pipefail

N=${1:-32768}     # default matrix dimension
ITER=${2:-10}    # default number of GEMM iterations

# compile
echo "Compiling int8_tflops.cu → int8_tflops"
nvcc -O3 --std=c++14 -lcublas int8_tflops.cu -o int8_tflops

# run
echo "Running INT8 GEMM ${N}×${N} × ${ITER} iterations…"
./int8_tflops "${N}" "${ITER}"
