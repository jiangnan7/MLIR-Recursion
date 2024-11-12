module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @_Z5r_sumjPi(%arg0: i32, %arg1: memref<?xi32>) attributes {llvm.linkage = #llvm.linkage<external>, state_base = 0 : i32, state_finish = 3 : i32, state_region0 = 3 : i32} {
    %c1_i32 = arith.constant 1 : i32
    %c2_i32 = arith.constant 2 : i32
    %0 = arith.index_cast %arg0 : i32 to index
    %1 = arith.cmpi sle, %arg0, %c1_i32 : i32
    scf.if %1 {
    } else {
      %2 = arith.divsi %arg0, %c2_i32 : i32
      func.call @_Z5r_sumjPi(%2, %arg1) {carry_value = 1 : i32, "operand#0" = 0 : i32, state_base = 0 : i32, state_finish = 1 : i32} : (i32, memref<?xi32>) -> ()
      %3 = arith.subi %arg0, %2 : i32
      %4 = arith.index_cast %2 : i32 to index
      %5 = "polygeist.subindex"(%arg1, %4) : (memref<?xi32>, index) -> memref<?xi32>
      func.call @_Z5r_sumjPi(%3, %5) {state_base = 1 : i32, state_finish = 2 : i32} : (i32, memref<?xi32>) -> ()
      %c2 = arith.constant 2 : index
      %c0 = arith.constant 0 : index
      %c-1 = arith.constant -1 : index
      %6 = arith.cmpi slt, %0, %c0 : index
      %7 = arith.subi %c-1, %0 : index
      %8 = arith.select %6, %7, %0 : index
      %9 = arith.divsi %8, %c2 : index
      %10 = arith.subi %c-1, %9 : index
      %11 = arith.select %6, %10, %9 : index
      %12 = memref.load %arg1[%11] : memref<?xi32>
      %c0_0 = arith.constant 0 : index
      %13 = memref.load %arg1[%c0_0] : memref<?xi32>
      %14 = arith.addi %13, %12 : i32
      %c0_1 = arith.constant 0 : index
      memref.store %14, %arg1[%c0_1] : memref<?xi32>
    } {state_base = 0 : i32, state_finish = 3 : i32, state_region1 = 2 : i32}
    return
  }
}

