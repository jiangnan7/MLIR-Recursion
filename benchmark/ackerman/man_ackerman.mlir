module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @_Z12man_ackermanjj(%arg0: i32, %arg1: i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1_i32 = arith.constant -1 : i32
    %true = arith.constant true
    %c3_i32 = arith.constant 3 : i32
    %c2_i32 = arith.constant 2 : i32
    %false = arith.constant false
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %0 = llvm.mlir.undef : i32
    %alloca = memref.alloca() : memref<512xi32>
    %alloca_0 = memref.alloca() : memref<512xi32>
    %alloca_1 = memref.alloca() : memref<512xi32>
    affine.store %arg1, %alloca_1[0] : memref<512xi32>
    affine.store %arg0, %alloca_0[0] : memref<512xi32>
    affine.store %c0_i32, %alloca[0] : memref<512xi32>
    %1:2 = scf.while (%arg2 = %0, %arg3 = %c0_i32, %arg4 = %true) : (i32, i32, i1) -> (i32, i32) {
      scf.condition(%arg4) %arg2, %arg3 : i32, i32
    } do {
    ^bb0(%arg2: i32, %arg3: i32):
      %2 = arith.index_cast %arg3 : i32 to index
      %3 = memref.load %alloca[%2] : memref<512xi32>
      %4 = memref.load %alloca_1[%2] : memref<512xi32>
      %5 = memref.load %alloca_0[%2] : memref<512xi32>
      %6 = arith.cmpi eq, %3, %c0_i32 : i32
      %7:3 = scf.if %6 -> (i32, i32, i1) {
        %8 = arith.cmpi eq, %5, %c0_i32 : i32
        %9:3 = scf.if %8 -> (i32, i32, i1) {
          %10 = arith.addi %4, %c1_i32 : i32
          %11 = arith.cmpi eq, %arg3, %c0_i32 : i32
          %12 = arith.cmpi ne, %arg3, %c0_i32 : i32
          %13 = scf.if %11 -> (i32) {
            scf.yield %arg3 : i32
          } else {
            %14 = arith.addi %arg3, %c-1_i32 : i32
            scf.yield %14 : i32
          }
          scf.yield %10, %13, %12 : i32, i32, i1
        } else {
          %10 = arith.cmpi sgt, %5, %c0_i32 : i32
          %11 = scf.if %10 -> (i1) {
            %13 = arith.cmpi eq, %4, %c0_i32 : i32
            scf.yield %13 : i1
          } else {
            scf.yield %false : i1
          }
          %12 = scf.if %11 -> (i32) {
            memref.store %c1_i32, %alloca[%2] : memref<512xi32>
            %13 = arith.addi %arg3, %c1_i32 : i32
            %14 = arith.index_cast %13 : i32 to index
            memref.store %c0_i32, %alloca[%14] : memref<512xi32>
            %15 = arith.addi %5, %c-1_i32 : i32
            memref.store %15, %alloca_0[%14] : memref<512xi32>
            memref.store %c1_i32, %alloca_1[%14] : memref<512xi32>
            scf.yield %13 : i32
          } else {
            memref.store %c2_i32, %alloca[%2] : memref<512xi32>
            %13 = arith.addi %arg3, %c1_i32 : i32
            %14 = arith.index_cast %13 : i32 to index
            memref.store %c0_i32, %alloca[%14] : memref<512xi32>
            memref.store %5, %alloca_0[%14] : memref<512xi32>
            %15 = arith.addi %4, %c-1_i32 : i32
            memref.store %15, %alloca_1[%14] : memref<512xi32>
            scf.yield %13 : i32
          }
          scf.yield %arg2, %12, %true : i32, i32, i1
        }
        scf.yield %9#0, %9#1, %9#2 : i32, i32, i1
      } else {
        %8 = arith.cmpi eq, %3, %c1_i32 : i32
        %9:2 = scf.if %8 -> (i32, i1) {
          %10 = arith.cmpi eq, %arg3, %c0_i32 : i32
          %11 = arith.cmpi ne, %arg3, %c0_i32 : i32
          %12 = scf.if %10 -> (i32) {
            scf.yield %arg3 : i32
          } else {
            %13 = arith.addi %arg3, %c-1_i32 : i32
            scf.yield %13 : i32
          }
          scf.yield %12, %11 : i32, i1
        } else {
          %10 = arith.cmpi eq, %3, %c2_i32 : i32
          %11:2 = scf.if %10 -> (i32, i1) {
            memref.store %arg2, %alloca_1[%2] : memref<512xi32>
            memref.store %c3_i32, %alloca[%2] : memref<512xi32>
            %12 = arith.addi %arg3, %c1_i32 : i32
            %13 = arith.index_cast %12 : i32 to index
            memref.store %c0_i32, %alloca[%13] : memref<512xi32>
            %14 = arith.addi %5, %c-1_i32 : i32
            memref.store %14, %alloca_0[%13] : memref<512xi32>
            memref.store %arg2, %alloca_1[%13] : memref<512xi32>
            scf.yield %12, %true : i32, i1
          } else {
            %12 = arith.cmpi eq, %3, %c3_i32 : i32
            %13 = arith.cmpi eq, %arg3, %c0_i32 : i32
            %14 = arith.cmpi ne, %arg3, %c0_i32 : i32
            %15 = arith.cmpi ne, %3, %c3_i32 : i32
            %16 = arith.andi %12, %14 : i1
            %17 = arith.ori %16, %15 : i1
            %18 = scf.if %12 -> (i32) {
              %19 = scf.if %13 -> (i32) {
                scf.yield %arg3 : i32
              } else {
                %20 = arith.addi %arg3, %c-1_i32 : i32
                scf.yield %20 : i32
              }
              scf.yield %19 : i32
            } else {
              scf.yield %arg3 : i32
            }
            scf.yield %18, %17 : i32, i1
          }
          scf.yield %11#0, %11#1 : i32, i1
        }
        scf.yield %arg2, %9#0, %9#1 : i32, i32, i1
      }
      scf.yield %7#0, %7#1, %7#2 : i32, i32, i1
    }
    return %1#0 : i32
  }
}
