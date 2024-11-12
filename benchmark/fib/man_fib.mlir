module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @_Z7man_fibj(%arg0: i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-2_i32 = arith.constant -2 : i32
    %c-1_i32 = arith.constant -1 : i32
    %true = arith.constant true
    %c2_i32 = arith.constant 2 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %0 = llvm.mlir.undef : i32
    %alloca = memref.alloca() : memref<512xi32>
    %alloca_0 = memref.alloca() : memref<512xi32>
    %alloca_1 = memref.alloca() : memref<512xi32>
    affine.store %arg0, %alloca_1[0] : memref<512xi32>
    affine.store %c0_i32, %alloca[0] : memref<512xi32>
    %1:2 = scf.while (%arg1 = %0, %arg2 = %c0_i32, %arg3 = %true) : (i32, i32, i1) -> (i32, i32) {
      scf.condition(%arg3) %arg1, %arg2 : i32, i32
    } do {
    ^bb0(%arg1: i32, %arg2: i32):
      %2 = arith.index_cast %arg2 : i32 to index
      %3 = memref.load %alloca[%2] : memref<512xi32>
      %4 = memref.load %alloca_1[%2] : memref<512xi32>
      %5 = arith.cmpi eq, %3, %c0_i32 : i32
      %6:3 = scf.if %5 -> (i32, i32, i1) {
        %7 = arith.cmpi sle, %4, %c2_i32 : i32
        %8 = arith.select %7, %c1_i32, %arg1 : i32
        %9:2 = scf.if %7 -> (i32, i1) {
          %10 = arith.cmpi eq, %arg2, %c0_i32 : i32
          %11 = arith.cmpi ne, %arg2, %c0_i32 : i32
          %12 = scf.if %10 -> (i32) {
            scf.yield %arg2 : i32
          } else {
            %13 = arith.addi %arg2, %c-1_i32 : i32
            scf.yield %13 : i32
          }
          scf.yield %12, %11 : i32, i1
        } else {
          memref.store %c1_i32, %alloca[%2] : memref<512xi32>
          %10 = arith.addi %arg2, %c1_i32 : i32
          %11 = arith.index_cast %10 : i32 to index
          memref.store %c0_i32, %alloca[%11] : memref<512xi32>
          %12 = arith.addi %4, %c-1_i32 : i32
          memref.store %12, %alloca_1[%11] : memref<512xi32>
          scf.yield %10, %true : i32, i1
        }
        scf.yield %8, %9#0, %9#1 : i32, i32, i1
      } else {
        %7 = arith.cmpi eq, %3, %c1_i32 : i32
        %8:3 = scf.if %7 -> (i32, i32, i1) {
          memref.store %arg1, %alloca_0[%2] : memref<512xi32>
          memref.store %c2_i32, %alloca[%2] : memref<512xi32>
          %9 = arith.addi %arg2, %c1_i32 : i32
          %10 = arith.index_cast %9 : i32 to index
          memref.store %c0_i32, %alloca[%10] : memref<512xi32>
          %11 = arith.addi %4, %c-2_i32 : i32
          memref.store %11, %alloca_1[%10] : memref<512xi32>
          scf.yield %arg1, %9, %true : i32, i32, i1
        } else {
          %9 = arith.cmpi eq, %3, %c2_i32 : i32
          %10:3 = scf.if %9 -> (i32, i32, i1) {
            %11 = memref.load %alloca_0[%2] : memref<512xi32>
            %12 = arith.addi %11, %arg1 : i32
            %13 = arith.cmpi eq, %arg2, %c0_i32 : i32
            %14 = arith.cmpi ne, %arg2, %c0_i32 : i32
            %15 = scf.if %13 -> (i32) {
              scf.yield %arg2 : i32
            } else {
              %16 = arith.addi %arg2, %c-1_i32 : i32
              scf.yield %16 : i32
            }
            scf.yield %12, %15, %14 : i32, i32, i1
          } else {
            scf.yield %arg1, %arg2, %true : i32, i32, i1
          }
          scf.yield %10#0, %10#1, %10#2 : i32, i32, i1
        }
        scf.yield %8#0, %8#1, %8#2 : i32, i32, i1
      }
      scf.yield %6#0, %6#1, %6#2 : i32, i32, i1
    }
    return %1#0 : i32
  }
}
