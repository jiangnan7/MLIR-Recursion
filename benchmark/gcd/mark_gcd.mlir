module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @_Z3gcdii(%arg0: i32, %arg1: i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, state_base = 0 : i32, state_finish = 2 : i32, state_region0 = 2 : i32} {
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.cmpi eq, %arg1, %c0_i32 : i32
    %1 = scf.if %0 -> (i32) {
      scf.yield %arg0 : i32
    } else {
      %2 = arith.remsi %arg0, %arg1 : i32
      %3 = func.call @_Z3gcdii(%arg1, %2) {state_base = 0 : i32, state_finish = 1 : i32} : (i32, i32) -> i32
      scf.yield %3 : i32
    } {state_base = 0 : i32, state_finish = 2 : i32, state_region1 = 1 : i32}
    return %1 : i32
  }
}

