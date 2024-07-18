#! /usr/bin/env bash

set -euo pipefail

readonly INPUT="$(realpath "$1")"
readonly DEVICE="$2"
shift 2

echo "Benchmarking: ${INPUT} on device ${DEVICE}"

timeout 50s tools/iree-benchmark-module \
  --device="rocm://${DEVICE}" \
  --device_allocator=caching \
  --module="${INPUT}" \
  --parameters=model=punet.irpa \
  --function=main \
  --input=1x4x128x128xf16 \
  --input=1xsi32 \
  --input=2x64x2048xf16 \
  --input=2x1280xf16 \
  --input=2x6xf16 \
  --input=1xf16 \
  --benchmark_repetitions=3 2>&1 | grep real_time_median

echo
