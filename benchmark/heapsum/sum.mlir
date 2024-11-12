module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @sum(%arg0: i32, %arg1: memref<?xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1_i32 = arith.constant 1 : i32
    %c2_i32 = arith.constant 2 : i32
    %0 = arith.index_cast %arg0 : i32 to index
    %1 = arith.cmpi sle, %arg0, %c1_i32 : i32
    scf.if %1 {
    } else {
      %2 = arith.divsi %arg0, %c2_i32 : i32
      func.call @sum(%2, %arg1) : (i32, memref<?xi32>) -> ()
      %3 = arith.subi %arg0, %2 : i32
      %4 = arith.index_cast %2 : i32 to index
      %5 = "polygeist.subindex"(%arg1, %4) : (memref<?xi32>, index) -> memref<?xi32>
      func.call @sum(%3, %5) : (i32, memref<?xi32>) -> ()
      %6 = affine.load %arg1[symbol(%0) floordiv 2] : memref<?xi32>
      %7 = affine.load %arg1[0] : memref<?xi32>
      %8 = arith.addi %7, %6 : i32
      affine.store %8, %arg1[0] : memref<?xi32>
    }
    return
  }
}
