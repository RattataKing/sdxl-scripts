#!/bin/bash

# Usage: PATH=/path/to/iree/build/tools:$PATH ./compile-unet-winograd.sh <target-chip> [extra flags]

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

readonly IREE_COMPILE="$(which iree-compile)"
readonly CHIP="$1"
shift

set -x

"${SCRIPT_DIR}/compile-unet-base.sh" "$IREE_COMPILE" "$CHIP" winograd \
  "${SCRIPT_DIR}/specs/attention_and_matmul_spec.mlir" \
  "${SCRIPT_DIR}/base_ir/stable_diffusion_xl_base_1_0_64_1024x1024_fp16_unet.mlir" \
  --iree-hal-dump-executable-configurations-to=configurations/unet_winograd \
  --iree-hal-dump-executable-sources-to=sources/unet_winograd \
  --iree-hal-dump-executable-binaries-to=binaries/unet_winograd \
  --iree-hal-dump-executable-benchmarks-to=benchmarks/unet_winograd \
  -o "${PWD}/tmp/unet.vmfb" \
  "$@"

  #--iree-hal-benchmark-dispatch-repeat-count=20 \
  #--iree-hal-executable-debug-level=3 \
  #--iree-vulkan-target-triple=rdna3-unknown-linux \
  #--iree-llvmcpu-target-triple=x86_64-unknown-linux \
  #--iree-hal-cuda-llvm-target-arch=sm_80 \
  #--mlir-disable-threading \
