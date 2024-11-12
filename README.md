# MLIR-Recursion


MLIR-Recursion is a customised compiler framework built on top of [MLIR](https://mlir.llvm.org), developed to support High-Level Synthesis (HLS) processes involving recursive functions. This framework introduces three passes that transform recursive applications into synthesizable architectures. For details on recursive function optimization, see the [Optimize Recursion Pass](recursion/README.md) in the `recursion` folder.



### Prerequisites
- cmake
- ninja

### Build MLIR-Recursion

LLVM Version: Ensure the specified [llvm-project](https://github.com/jiangnan7/llvm-project) version is used to maintain compatibility with MLIR-Recursion.  

```sh
$ git clone --recursive https://github.com/jiangnan7/llvm-project
$ ./build_and_run.sh
```

## Compiling C/C++ 

To optimize C/C++ kernels, run:
```sh
$ # Recursion
$ # Note: Fix the pass: --convert-scf-to-cf
$ ./build/bin/hls-opt --lower-affine --mark-recusrive sort.mlir | --optimize-recursion --convert-scf-to-cf \ 
    ./thirdparty/Polygeist/bin/polygeist-opt --lower-affine --convert-polygeist-to-llvm="use-c-style-memref=1" \ 
    --canonicalize  | ./thirdparty/Polygeist/llvm-project/build/bin/mlir-translate --mlir-to-llvmir \
    -opaque-pointers=0 -o sort.ll 
```
Next, you can use the open source tool Bambu.


## Generate RTL

The following process requires [Bambu](https://github.com/ferrandi/PandA-bambu) to generate RTL, which is a sample command:
```sh
$ /opt/panda/bin/bambu -v3 --print-dot -lm --soft-float --compiler=I386_CLANG12 -O2 \
    --device=deivce --clock-period=10 --no-iob --experimental-setup=BAMBU-BALANCED-MP \
    --channels-number=2 --memory-allocation-policy=ALL_BRAM --disable-function-proxy \
    --simulate --simulator=VERILATOR  --top-fname=sort  sort.ll 
```