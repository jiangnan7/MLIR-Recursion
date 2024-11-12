module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @_Z10r_ackermanjj(%arg0: i32, %arg1: i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1_i32 = arith.constant -1 : i32
    %false = arith.constant false
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.cmpi eq, %arg0, %c0_i32 : i32
    %1 = scf.if %0 -> (i32) {
      %2 = arith.addi %arg1, %c1_i32 : i32
      scf.yield %2 : i32
    } else {
      %2 = arith.cmpi sgt, %arg0, %c0_i32 : i32
      %3 = scf.if %2 -> (i1) {
        %5 = arith.cmpi eq, %arg1, %c0_i32 : i32
        scf.yield %5 : i1
      } else {
        scf.yield %false : i1
      }
      %4 = scf.if %3 -> (i32) {
        %5 = arith.addi %arg0, %c-1_i32 : i32
        %6 = func.call @_Z10r_ackermanjj(%5, %c1_i32) : (i32, i32) -> i32
        scf.yield %6 : i32
      } else {
        %5 = arith.addi %arg1, %c-1_i32 : i32
        %6 = func.call @_Z10r_ackermanjj(%arg0, %5) : (i32, i32) -> i32
        %7 = arith.addi %arg0, %c-1_i32 : i32
        %8 = func.call @_Z10r_ackermanjj(%7, %6) : (i32, i32) -> i32
        scf.yield %8 : i32
      }
      scf.yield %4 : i32
    }
    return %1 : i32
  }
}
