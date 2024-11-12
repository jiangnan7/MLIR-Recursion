//===----------------------------------------------------------------------===//
//
// Jiangnan Li
//
//===----------------------------------------------------------------------===//

#ifndef HLS_INITALLPASSES_H
#define HLS_INITALLPASSES_H

#include "mlir/InitAllPasses.h"
#include "hls/Transforms/Passes.h"

namespace mlir {
namespace hls {
   
namespace {
#define GEN_PASS_REGISTRATION
#include "hls/Transforms/Passes.h.inc"
} // namespace

// Add all the HLS passes.
inline void registerAllPasses() {

    mlir::registerAllPasses();
    hls::registerPasses();
    // recursion
    // hls::registerOptimizeRecursionPass();
    // hls::registerOptimizeTailRecursionPass();
    // hls::registerOptimizeWellStructuredRecursionPass();
    
    // //loop
    // hls::registerAffineLoopPerfection();
    // hls::registerAffineLoopTile();



}

} // namespace hls
} // namespace mlir

#endif // HLS_INITALLPASSES_H
