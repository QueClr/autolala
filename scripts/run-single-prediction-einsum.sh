#!/usr/bin/env bash

POLY_PATH=/home/schrodingerzy/Documents/Polygeist/build/bin
export SYMBOLICA_HIDE_BANNER=1
export RUST_LOG=info
PROGRAM_NAME=$(basename $1 .c)
$POLY_PATH/cgeist $1 -S -raise-scf-to-affine | \
    $POLY_PATH/polygeist-opt --strip-dlti-attributes > /tmp/"${PROGRAM_NAME}.mlir"

mkdir -p results/fully-associative-einsum
mkdir -p results/12-way-einsum
cargo run --release --quiet --bin analyzer -- -i /tmp/"${PROGRAM_NAME}.mlir" --json -o results/fully-associative-einsum/${PROGRAM_NAME}.json barvinok --barvinok-arg=--approximation-method=scale --infinite-repeat --block-size=8
cargo run --release --quiet --bin assoc-conv -- -o results/12-way-einsum/${PROGRAM_NAME}.json -i results/fully-associative-einsum/${PROGRAM_NAME}.json -a 12

