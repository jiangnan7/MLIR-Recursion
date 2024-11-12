module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @_Z8man_sortPji(%arg0: memref<?xi32>, %arg1: i32) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c-1_i32 = arith.constant -1 : i32
    %true = arith.constant true
    %c2_i32 = arith.constant 2 : i32
    %false = arith.constant false
    %c32_i32 = arith.constant 32 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %0 = llvm.mlir.undef : i32
    %alloca = memref.alloca() : memref<512xi32>
    %alloca_0 = memref.alloca() : memref<512xi32>
    %alloca_1 = memref.alloca() : memref<512xi32>
    %alloca_2 = memref.alloca() : memref<512xmemref<?xi32>>
    affine.store %arg0, %alloca_2[0] : memref<512xmemref<?xi32>>
    affine.store %arg1, %alloca_1[0] : memref<512xi32>
    affine.store %c0_i32, %alloca[0] : memref<512xi32>
    %1:6 = scf.while (%arg2 = %0, %arg3 = %0, %arg4 = %0, %arg5 = %0, %arg6 = %0, %arg7 = %c0_i32, %arg8 = %true) : (i32, i32, i32, i32, i32, i32, i1) -> (i32, i32, i32, i32, i32, i32) {
      scf.condition(%arg8) %arg2, %arg3, %arg4, %arg5, %arg6, %arg7 : i32, i32, i32, i32, i32, i32
    } do {
    ^bb0(%arg2: i32, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32):
      %2 = arith.index_cast %arg7 : i32 to index
      %3 = memref.load %alloca_2[%2] : memref<512xmemref<?xi32>>
      %4 = memref.load %alloca_1[%2] : memref<512xi32>
      %5 = memref.load %alloca_0[%2] : memref<512xi32>
      %6 = memref.load %alloca[%2] : memref<512xi32>
      %7 = arith.cmpi eq, %6, %c0_i32 : i32
      %8:7 = scf.if %7 -> (i32, i32, i32, i32, i32, i32, i1) {
        %9 = arith.cmpi slt, %4, %c32_i32 : i32
        %10:7 = scf.if %9 -> (i32, i32, i32, i32, i32, i32, i1) {
          %11 = arith.index_cast %4 : i32 to index
          %12:2 = scf.for %arg8 = %c1 to %11 step %c1 iter_args(%arg9 = %arg5, %arg10 = %arg6) -> (i32, i32) {
            %16 = arith.index_cast %arg8 : index to i32
            %17 = memref.load %3[%arg8] : memref<?xi32>
            %18 = scf.while (%arg11 = %16) : (i32) -> i32 {
              %20 = arith.cmpi sgt, %arg11, %c0_i32 : i32
              %21:2 = scf.if %20 -> (i1, i32) {
                %22 = arith.addi %arg11, %c-1_i32 : i32
                %23 = arith.index_cast %22 : i32 to index
                %24 = memref.load %3[%23] : memref<?xi32>
                %25 = arith.cmpi slt, %17, %24 : i32
                %26 = arith.select %25, %22, %arg11 : i32
                scf.if %25 {
                  %27 = arith.index_cast %arg11 : i32 to index
                  %28 = memref.load %3[%23] : memref<?xi32>
                  memref.store %28, %3[%27] : memref<?xi32>
                }
                scf.yield %25, %26 : i1, i32
              } else {
                scf.yield %false, %arg11 : i1, i32
              }
              scf.condition(%21#0) %21#1 : i32
            } do {
            ^bb0(%arg11: i32):
              scf.yield %arg11 : i32
            }
            %19 = arith.index_cast %18 : i32 to index
            memref.store %17, %3[%19] : memref<?xi32>
            scf.yield %17, %18 : i32, i32
          }
          %13 = arith.cmpi eq, %arg7, %c0_i32 : i32
          %14 = arith.cmpi ne, %arg7, %c0_i32 : i32
          %15 = scf.if %13 -> (i32) {
            scf.yield %arg7 : i32
          } else {
            %16 = arith.addi %arg7, %c-1_i32 : i32
            scf.yield %16 : i32
          }
          scf.yield %arg2, %arg3, %arg4, %12#0, %12#1, %15, %14 : i32, i32, i32, i32, i32, i32, i1
        } else {
          %11 = arith.divsi %4, %c2_i32 : i32
          %12 = arith.index_cast %11 : i32 to index
          %13 = memref.load %3[%12] : memref<?xi32>
          %14 = arith.addi %4, %c-1_i32 : i32
          %15:3 = scf.while (%arg8 = %arg2, %arg9 = %14, %arg10 = %c0_i32, %arg11 = %true) : (i32, i32, i32, i1) -> (i32, i32, i32) {
            scf.condition(%arg11) %arg8, %arg10, %arg9 : i32, i32, i32
          } do {
          ^bb0(%arg8: i32, %arg9: i32, %arg10: i32):
            %18 = scf.while (%arg11 = %arg9) : (i32) -> i32 {
              %22 = arith.index_cast %arg11 : i32 to index
              %23 = memref.load %3[%22] : memref<?xi32>
              %24 = arith.cmpi slt, %23, %13 : i32
              scf.condition(%24) %arg11 : i32
            } do {
            ^bb0(%arg11: i32):
              %22 = arith.addi %arg11, %c1_i32 : i32
              scf.yield %22 : i32
            }
            %19 = scf.while (%arg11 = %arg10) : (i32) -> i32 {
              %22 = arith.index_cast %arg11 : i32 to index
              %23 = memref.load %3[%22] : memref<?xi32>
              %24 = arith.cmpi slt, %13, %23 : i32
              scf.condition(%24) %arg11 : i32
            } do {
            ^bb0(%arg11: i32):
              %22 = arith.addi %arg11, %c-1_i32 : i32
              scf.yield %22 : i32
            }
            %20 = arith.cmpi slt, %18, %19 : i32
            %21:3 = scf.if %20 -> (i32, i32, i32) {
              %22 = arith.index_cast %18 : i32 to index
              %23 = memref.load %3[%22] : memref<?xi32>
              %24 = arith.index_cast %19 : i32 to index
              %25 = memref.load %3[%24] : memref<?xi32>
              memref.store %25, %3[%22] : memref<?xi32>
              memref.store %23, %3[%24] : memref<?xi32>
              %26 = arith.addi %18, %c1_i32 : i32
              %27 = arith.addi %19, %c-1_i32 : i32
              scf.yield %23, %27, %26 : i32, i32, i32
            } else {
              scf.yield %arg8, %19, %18 : i32, i32, i32
            }
            scf.yield %21#0, %21#1, %21#2, %20 : i32, i32, i32, i1
          }
          memref.store %15#1, %alloca_0[%2] : memref<512xi32>
          memref.store %c1_i32, %alloca[%2] : memref<512xi32>
          %16 = arith.addi %arg7, %c1_i32 : i32
          %17 = arith.index_cast %16 : i32 to index
          memref.store %c0_i32, %alloca[%17] : memref<512xi32>
          memref.store %3, %alloca_2[%17] : memref<512xmemref<?xi32>>
          memref.store %15#1, %alloca_1[%17] : memref<512xi32>
          scf.yield %15#0, %15#1, %13, %arg5, %arg6, %16, %true : i32, i32, i32, i32, i32, i32, i1
        }
        scf.yield %10#0, %10#1, %10#2, %10#3, %10#4, %10#5, %10#6 : i32, i32, i32, i32, i32, i32, i1
      } else {
        %9 = arith.cmpi eq, %6, %c1_i32 : i32
        %10:2 = scf.if %9 -> (i32, i1) {
          memref.store %c2_i32, %alloca[%2] : memref<512xi32>
          %11 = arith.addi %arg7, %c1_i32 : i32
          %12 = arith.index_cast %11 : i32 to index
          memref.store %c0_i32, %alloca[%12] : memref<512xi32>
          %13 = arith.index_cast %5 : i32 to index
          %14 = "polygeist.subindex"(%3, %13) : (memref<?xi32>, index) -> memref<?xi32>
          memref.store %14, %alloca_2[%12] : memref<512xmemref<?xi32>>
          %15 = arith.subi %4, %5 : i32
          memref.store %15, %alloca_1[%12] : memref<512xi32>
          scf.yield %11, %true : i32, i1
        } else {
          %11 = arith.cmpi eq, %6, %c2_i32 : i32
          %12 = arith.cmpi eq, %arg7, %c0_i32 : i32
          %13 = arith.cmpi ne, %arg7, %c0_i32 : i32
          %14 = arith.cmpi ne, %6, %c2_i32 : i32
          %15 = arith.andi %11, %13 : i1
          %16 = arith.ori %15, %14 : i1
          %17 = scf.if %11 -> (i32) {
            %18 = scf.if %12 -> (i32) {
              scf.yield %arg7 : i32
            } else {
              %19 = arith.addi %arg7, %c-1_i32 : i32
              scf.yield %19 : i32
            }
            scf.yield %18 : i32
          } else {
            scf.yield %arg7 : i32
          }
          scf.yield %17, %16 : i32, i1
        }
        scf.yield %arg2, %arg3, %arg4, %arg5, %arg6, %10#0, %10#1 : i32, i32, i32, i32, i32, i32, i1
      }
      scf.yield %8#0, %8#1, %8#2, %8#3, %8#4, %8#5, %8#6 : i32, i32, i32, i32, i32, i32, i1
    }
    return
  }
}
