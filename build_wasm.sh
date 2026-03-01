#!/usr/bin/env bash

set -euo pipefail

SRC="yoga"
BIN="$SRC/build_wasm_static_odin"

if [ ! -d "$SRC" ]; then
    git clone --revision cfdacac0e3c2e91ab15939027688756271a66025 --depth=1 https://github.com/facebook/yoga "$SRC"
fi

if [ "$(uname -s)" = "Darwin" ]; then
    CPU="$(sysctl -n hw.ncpu 2>/dev/null || echo 8)"
else
    CPU="$(nproc 2>/dev/null || getconf _NPROCESSORS_ONLN || echo 8)"
fi

emcmake cmake -S "cmake" -B "$BIN" -DCMAKE_BUILD_TYPE=Release -DYOGA_LIBRARY_TYPE=STATIC -DYOGA_SOURCE_DIR="$PWD/$SRC"
cmake --build "$BIN" --config Release -j"$CPU"

cp "$BIN/libyoga.a" "yoga.wasm.a"

echo "Built yoga.wasm.a"
