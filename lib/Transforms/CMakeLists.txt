add_mlir_dialect_library(MLIRHLSTransforms

  Recursion.cpp
  MarkRecursive.cpp
  # ADDITIONAL_HEADER_DIRS
  # ${PROJECT_SOURCE_DIR}/include/hls/Recursion

  DEPENDS
  MLIRHLSTransformsIncGen
)

# Tail Recursion Elimination Pass
# target_link_libraries(Recursion PUBLIC MLIRIR)
