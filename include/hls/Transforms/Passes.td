#ifndef HLS_PASSES_TD
#define HLS_PASSES_TD

include "mlir/Pass/PassBase.td"


//===----------------------------------------------------------------------===//
// Recursion analysis pass
//===----------------------------------------------------------------------===//

def OptimizeTailRecursionPass : Pass<"optimize-tail-recursion", "func::FuncOp"> {
  let summary = "Optimize a Tail Recursion. ";
  let constructor = "mlir::hls::createOptimizeTailRecursionPass()";
}


def OptimizeRecursionPass : Pass<"optimize-recursion", "func::FuncOp"> {
  let summary = "Optimize a Recursion. ";
  let constructor = "mlir::hls::createOptimizeRecursionPass()";
}

def MarkRecursive : Pass<"mark-recursive", "func::FuncOp"> {
  let summary = "Mark a Recursion. ";
  let constructor = "mlir::hls::createMarkRecursivePass()";
}

#endif // HLS_PASSES_TD