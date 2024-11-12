#ifndef HLS_PASSES_H
#define HLS_PASSES_H

#include "mlir/Pass/Pass.h"
#include "hls/InitAllDialects.h"
#include <memory>
namespace mlir {
class Pass;
namespace func {
class FuncOp;
} // namespace func
} // namespace mlir

namespace mlir::hls {

//Recursion analysis pass
std::unique_ptr<Pass> createOptimizeRecursionPass();
std::unique_ptr<Pass> createOptimizeTailRecursionPass();
std::unique_ptr<Pass> createMarkRecursivePass();

/// Generate the code for registering passes.
// #define GEN_PASS_REGISTRATION
#define GEN_PASS_CLASSES
// #define GEN_PASS_DECL
#include "hls/Transforms/Passes.h.inc"

} // namespace mlir::hls

#endif // HLS_PASSES_H

