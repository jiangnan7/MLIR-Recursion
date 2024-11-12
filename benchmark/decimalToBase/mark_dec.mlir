
module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @_Z13decimalToBaseiiPiRi(%arg0: i32, %arg1: i32, %arg2: memref<?xi32>, %arg3: memref<?xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.cmpi eq, %arg0, %c0_i32 : i32
    scf.if %0 {
    } else {
      %1 = arith.divsi %arg0, %arg1 : i32
      func.call @_Z13decimalToBaseiiPiRi(%1, %arg1, %arg2, %arg3)  {state_base = 0 : i32, state_finish = 1 : i32}: (i32, i32, memref<?xi32>, memref<?xi32>) -> ()
      %2 = arith.remsi %arg0, %arg1 : i32
      %3 = affine.load %arg3[0] : memref<?xi32>
      %4 = arith.addi %3, %c1_i32 : i32
      affine.store %4, %arg3[0] : memref<?xi32>
      %5 = arith.index_cast %3 : i32 to index
      memref.store %2, %arg2[%5] : memref<?xi32>
    }
    return
  }
}

