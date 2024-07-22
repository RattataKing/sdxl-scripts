#! /usr/bin/env bash

set -euo pipefail

readonly INPUT="$(realpath "$1")"
readonly DEVICE="$2"
shift 2

echo "Benchmarking: ${INPUT} on device ${DEVICE}"

timeout 20s tools/iree-benchmark-module \
  --device="rocm://${DEVICE}" \
  --device_allocator=caching \
  --module="${INPUT}" \
  --parameters=model=unet_splat.irpa \
  --function=run_forward \
  --input=12x4x128x128xf16 \
  --input=24x64x2048xf16 \
  --input=24x1280xf16 \
  --input=24x6xf16 \
  --input=1xf16 \
  --input=1xi64 \
  --benchmark_repetitions=5 2>&1 | grep real_time_median

echo
