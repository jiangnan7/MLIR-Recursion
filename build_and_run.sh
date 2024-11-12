#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset


# The absolute path to the directory of this script.
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "${MY_DIR}"

# Set up MLIR
mkdir -p ${MY_DIR}/thirdparty
INSTALL_DIR=${MY_DIR}/thirdparty



## INSTALL LLVM/MLIR
LLVM_REPO=${MY_DIR}/thirdparty/llvm-project
LLVM_BUILD=${MY_DIR}/thirdparty/llvm-project/build

mkdir -p $LLVM_BUILD

cd "${LLVM_BUILD}" 
cmake  -G Ninja "-H$LLVM_REPO/llvm" \
     "-B$LLVM_BUILD" \
     -DLLVM_INSTALL_UTILS=ON \
     -DLLVM_ENABLE_PROJECTS="mlir;clang" \
     -DCMAKE_BUILD_TYPE=RelWithDebInfo \
     -DLLVM_INCLUDE_TOOLS=ON \
     -DLLVM_BUILD_EXAMPLES=ON \
     -DLLVM_TARGETS_TO_BUILD="host"
  

ninja
ninja && ninja check-mlir


##INSTALL Polygeist

cd "${INSTALL_DIR}"
git clone --recursive https://github.com/llvm/Polygeist
Polygeist_REPO=${MY_DIR}/thirdparty/Polygeist
cd "${Polygeist_REPO}"
git checkout eda0c6cbf5ae


mkdir -p build
cd build
cmake -G Ninja ../llvm-project/llvm \
  -DLLVM_ENABLE_PROJECTS="clang;mlir" \
  -DLLVM_EXTERNAL_PROJECTS="polygeist" \
  -DLLVM_EXTERNAL_POLYGEIST_SOURCE_DIR=.. \
  -DLLVM_TARGETS_TO_BUILD="host" \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DCMAKE_BUILD_TYPE=DEBUG
ninja
ninja check-polygeist-opt && ninja check-cgeist



#INSTALL MLIR-Recursion
cd "${MY_DIR}"
mkdir -p build && cd build
cmake -G Ninja .. \
  -DLLVM_DIR=$LLVM_REPO/build/lib/cmake/llvm \
  -DMLIR_DIR=$LLVM_REPO/build/lib/cmake/mlir 
cmake --build . --target hls-opt

