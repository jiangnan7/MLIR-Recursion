module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @_Z6r_sortPji(%arg0: memref<?xi32>, %arg1: i32) attributes {llvm.linkage = #llvm.linkage<external>, state_base = 0 : i32, state_finish = 3 : i32, state_region0 = 3 : i32} {
    %c1 = arith.constant 1 : index
    %c-1_i32 = arith.constant -1 : i32
    %c0_i32 = arith.constant 0 : i32
    %c32_i32 = arith.constant 32 : i32
    %c1_i32 = arith.constant 1 : i32
    %false = arith.constant false
    %true = arith.constant true
    %0 = arith.index_cast %arg1 : i32 to index
    %1 = llvm.mlir.undef : i32
    %2 = arith.cmpi slt, %arg1, %c32_i32 : i32
    scf.if %2 {
      scf.for %arg2 = %c1 to %0 step %c1 {
        %3 = arith.index_cast %arg2 : index to i32
        %4 = memref.load %arg0[%arg2] : memref<?xi32>
        %5 = scf.while (%arg3 = %3) : (i32) -> i32 {
          %7 = arith.cmpi sgt, %arg3, %c0_i32 : i32
          %8:2 = scf.if %7 -> (i1, i32) {
            %9 = arith.addi %arg3, %c-1_i32 : i32
            %10 = arith.index_cast %9 : i32 to index
            %11 = memref.load %arg0[%10] : memref<?xi32>
            %12 = arith.cmpi slt, %4, %11 : i32
            %13 = arith.select %12, %9, %arg3 : i32
            scf.if %12 {
              %14 = arith.index_cast %arg3 : i32 to index
              %15 = memref.load %arg0[%10] : memref<?xi32>
              memref.store %15, %arg0[%14] : memref<?xi32>
            }
            scf.yield %12, %13 : i1, i32
          } else {
            scf.yield %false, %arg3 : i1, i32
          }
          scf.condition(%8#0) %8#1 : i32
        } do {
        ^bb0(%arg3: i32):
          scf.yield %arg3 : i32
        }
        %6 = arith.index_cast %5 : i32 to index
        memref.store %4, %arg0[%6] : memref<?xi32>
      }
    } else {
      %3 = affine.load %arg0[symbol(%0) floordiv 2] : memref<?xi32>
      %4 = arith.addi %arg1, %c-1_i32 : i32
      %5:3 = scf.while (%arg2 = %1, %arg3 = %4, %arg4 = %c0_i32, %arg5 = %true) : (i32, i32, i32, i1) -> (i32, i32, i32) {
        scf.condition(%arg5) %arg4, %arg2, %arg3 : i32, i32, i32
      } do {
      ^bb0(%arg2: i32, %arg3: i32, %arg4: i32):
        %9 = scf.while (%arg5 = %arg2) : (i32) -> i32 {
          %13 = arith.index_cast %arg5 : i32 to index
          %14 = memref.load %arg0[%13] : memref<?xi32>
          %15 = arith.cmpi slt, %14, %3 : i32
          scf.condition(%15) %arg5 : i32
        } do {
        ^bb0(%arg5: i32):
          %13 = arith.addi %arg5, %c1_i32 : i32
          scf.yield %13 : i32
        }
        %10 = scf.while (%arg5 = %arg4) : (i32) -> i32 {
          %13 = arith.index_cast %arg5 : i32 to index
          %14 = memref.load %arg0[%13] : memref<?xi32>
          %15 = arith.cmpi slt, %3, %14 : i32
          scf.condition(%15) %arg5 : i32
        } do {
        ^bb0(%arg5: i32):
          %13 = arith.addi %arg5, %c-1_i32 : i32
          scf.yield %13 : i32
        }
        %11 = arith.cmpi slt, %9, %10 : i32
        %12:3 = scf.if %11 -> (i32, i32, i32) {
          %13 = arith.index_cast %9 : i32 to index
          %14 = memref.load %arg0[%13] : memref<?xi32>
          %15 = arith.index_cast %10 : i32 to index
          %16 = memref.load %arg0[%15] : memref<?xi32>
          memref.store %16, %arg0[%13] : memref<?xi32>
          memref.store %14, %arg0[%15] : memref<?xi32>
          %17 = arith.addi %9, %c1_i32 : i32
          %18 = arith.addi %10, %c-1_i32 : i32
          scf.yield %14, %18, %17 : i32, i32, i32
        } else {
          scf.yield %arg3, %10, %9 : i32, i32, i32
        }
        scf.yield %12#0, %12#1, %12#2, %11 : i32, i32, i32, i1
      }
      func.call @_Z6r_sortPji(%arg0, %5#0) {carry_value = 1 : i32, "operand#1" = 1 : i32, state_base = 0 : i32, state_finish = 1 : i32} : (memref<?xi32>, i32) -> ()
      %6 = arith.index_cast %5#0 : i32 to index
      %7 = "polygeist.subindex"(%arg0, %6) : (memref<?xi32>, index) -> memref<?xi32>
      %8 = arith.subi %arg1, %5#0 : i32
      func.call @_Z6r_sortPji(%7, %8) {state_base = 1 : i32, state_finish = 2 : i32} : (memref<?xi32>, i32) -> ()
    } {state_base = 0 : i32, state_finish = 3 : i32, state_region1 = 2 : i32}
    return
  }
}

