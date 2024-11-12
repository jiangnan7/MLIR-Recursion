module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @_Z11r_tiled_mmmiiPiPKiS1_(%arg0: i32, %arg1: i32, %arg2: memref<?xi32>, %arg3: memref<?xi32>, %arg4: memref<?xi32>) attributes {llvm.linkage = #llvm.linkage<external>, state_base = 0 : i32, state_finish = 9 : i32, state_region0 = 9 : i32} {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c2_i32 = arith.constant 2 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %c16_i32 = arith.constant 16 : i32
    %alloca = memref.alloca() : memref<1x2xmemref<?xi32>>
    %cast = memref.cast %alloca : memref<1x2xmemref<?xi32>> to memref<?x2xmemref<?xi32>>
    %alloca_0 = memref.alloca() : memref<1xi32>
    %alloca_1 = memref.alloca() : memref<1xi32>
    affine.store %arg0, %alloca_1[0] : memref<1xi32>
    affine.store %arg1, %alloca_0[0] : memref<1xi32>
    %cast_2 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
    %cast_3 = memref.cast %alloca_1 : memref<1xi32> to memref<?xi32>
    affine.store %cast_2, %alloca[0, 0] : memref<1x2xmemref<?xi32>>
    affine.store %cast_3, %alloca[0, 1] : memref<1x2xmemref<?xi32>>
    %0 = arith.cmpi sle, %arg0, %c16_i32 : i32
    scf.if %0 {
      %1 = llvm.mlir.undef : i32
      %2 = scf.while (%arg5 = %c0_i32, %arg6 = %arg0) : (i32, i32) -> i32 {
        %3 = arith.cmpi slt, %arg5, %arg6 : i32
        scf.condition(%3) %arg5 : i32
      } do {
      ^bb0(%arg5: i32):
        %3:2 = scf.while (%arg6 = %c0_i32, %arg7 = %1) : (i32, i32) -> (i32, i32) {
          %5 = affine.load %alloca_1[0] : memref<1xi32>
          %6 = arith.cmpi slt, %arg6, %5 : i32
          scf.condition(%6) %5, %arg6 : i32, i32
        } do {
        ^bb0(%arg6: i32, %arg7: i32):
          %5 = affine.load %alloca_0[0] : memref<1xi32>
          %6 = arith.muli %arg5, %5 : i32
          %7 = arith.addi %6, %arg7 : i32
          %8 = arith.index_cast %7 : i32 to index
          %9 = memref.load %arg2[%8] : memref<?xi32>
          %10 = arith.sitofp %9 : i32 to f32
          %11 = arith.index_cast %arg6 : i32 to index
          %12 = scf.for %arg8 = %c0 to %11 step %c1 iter_args(%arg9 = %10) -> (f32) {
            %15 = arith.index_cast %arg8 : index to i32
            %16 = arith.addi %6, %15 : i32
            %17 = arith.index_cast %16 : i32 to index
            %18 = memref.load %arg3[%17] : memref<?xi32>
            %19 = arith.muli %15, %5 : i32
            %20 = arith.addi %19, %arg7 : i32
            %21 = arith.index_cast %20 : i32 to index
            %22 = memref.load %arg4[%21] : memref<?xi32>
            %23 = arith.muli %18, %22 : i32
            %24 = arith.sitofp %23 : i32 to f32
            %25 = arith.addf %arg9, %24 : f32
            scf.yield %25 : f32
          }
          %13 = arith.fptosi %12 : f32 to i32
          memref.store %13, %arg2[%8] : memref<?xi32>
          %14 = arith.addi %arg7, %c1_i32 : i32
          scf.yield %14, %arg6 : i32, i32
        }
        %4 = arith.addi %arg5, %c1_i32 : i32
        scf.yield %4, %3#0 : i32, i32
      }
    } else {
      %1 = arith.divsi %arg0, %c2_i32 : i32
      %2 = affine.load %alloca_0[0] : memref<1xi32>
      %3 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c0_i32, %c0_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %4 = arith.index_cast %3 : i32 to index
      %5 = "polygeist.subindex"(%arg2, %4) : (memref<?xi32>, index) -> memref<?xi32>
      %6 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c0_i32, %c0_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %7 = arith.index_cast %6 : i32 to index
      %8 = "polygeist.subindex"(%arg3, %7) : (memref<?xi32>, index) -> memref<?xi32>
      %9 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c0_i32, %c0_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %10 = arith.index_cast %9 : i32 to index
      %11 = "polygeist.subindex"(%arg4, %10) : (memref<?xi32>, index) -> memref<?xi32>
      func.call @_Z11r_tiled_mmmiiPiPKiS1_(%1, %2, %5, %8, %11) {state_base = 0 : i32, state_finish = 1 : i32} : (i32, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>) -> ()
      %12 = affine.load %alloca_1[0] : memref<1xi32>
      %13 = arith.divsi %12, %c2_i32 : i32
      %14 = affine.load %alloca_0[0] : memref<1xi32>
      %15 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c0_i32, %c1_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %16 = arith.index_cast %15 : i32 to index
      %17 = "polygeist.subindex"(%arg2, %16) : (memref<?xi32>, index) -> memref<?xi32>
      %18 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c0_i32, %c0_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %19 = arith.index_cast %18 : i32 to index
      %20 = "polygeist.subindex"(%arg3, %19) : (memref<?xi32>, index) -> memref<?xi32>
      %21 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c0_i32, %c1_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %22 = arith.index_cast %21 : i32 to index
      %23 = "polygeist.subindex"(%arg4, %22) : (memref<?xi32>, index) -> memref<?xi32>
      func.call @_Z11r_tiled_mmmiiPiPKiS1_(%13, %14, %17, %20, %23) {state_base = 1 : i32, state_finish = 2 : i32} : (i32, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>) -> ()
      %24 = affine.load %alloca_1[0] : memref<1xi32>
      %25 = arith.divsi %24, %c2_i32 : i32
      %26 = affine.load %alloca_0[0] : memref<1xi32>
      %27 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c1_i32, %c0_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %28 = arith.index_cast %27 : i32 to index
      %29 = "polygeist.subindex"(%arg2, %28) : (memref<?xi32>, index) -> memref<?xi32>
      %30 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c1_i32, %c0_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %31 = arith.index_cast %30 : i32 to index
      %32 = "polygeist.subindex"(%arg3, %31) : (memref<?xi32>, index) -> memref<?xi32>
      %33 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c0_i32, %c0_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %34 = arith.index_cast %33 : i32 to index
      %35 = "polygeist.subindex"(%arg4, %34) : (memref<?xi32>, index) -> memref<?xi32>
      func.call @_Z11r_tiled_mmmiiPiPKiS1_(%25, %26, %29, %32, %35) {state_base = 2 : i32, state_finish = 3 : i32} : (i32, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>) -> ()
      %36 = affine.load %alloca_1[0] : memref<1xi32>
      %37 = arith.divsi %36, %c2_i32 : i32
      %38 = affine.load %alloca_0[0] : memref<1xi32>
      %39 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c1_i32, %c1_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %40 = arith.index_cast %39 : i32 to index
      %41 = "polygeist.subindex"(%arg2, %40) : (memref<?xi32>, index) -> memref<?xi32>
      %42 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c1_i32, %c0_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %43 = arith.index_cast %42 : i32 to index
      %44 = "polygeist.subindex"(%arg3, %43) : (memref<?xi32>, index) -> memref<?xi32>
      %45 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c0_i32, %c1_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %46 = arith.index_cast %45 : i32 to index
      %47 = "polygeist.subindex"(%arg4, %46) : (memref<?xi32>, index) -> memref<?xi32>
      func.call @_Z11r_tiled_mmmiiPiPKiS1_(%37, %38, %41, %44, %47) {state_base = 3 : i32, state_finish = 4 : i32} : (i32, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>) -> ()
      %48 = affine.load %alloca_1[0] : memref<1xi32>
      %49 = arith.divsi %48, %c2_i32 : i32
      %50 = affine.load %alloca_0[0] : memref<1xi32>
      %51 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c0_i32, %c0_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %52 = arith.index_cast %51 : i32 to index
      %53 = "polygeist.subindex"(%arg2, %52) : (memref<?xi32>, index) -> memref<?xi32>
      %54 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c0_i32, %c1_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %55 = arith.index_cast %54 : i32 to index
      %56 = "polygeist.subindex"(%arg3, %55) : (memref<?xi32>, index) -> memref<?xi32>
      %57 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c1_i32, %c0_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %58 = arith.index_cast %57 : i32 to index
      %59 = "polygeist.subindex"(%arg4, %58) : (memref<?xi32>, index) -> memref<?xi32>
      func.call @_Z11r_tiled_mmmiiPiPKiS1_(%49, %50, %53, %56, %59) {state_base = 4 : i32, state_finish = 5 : i32} : (i32, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>) -> ()
      %60 = affine.load %alloca_1[0] : memref<1xi32>
      %61 = arith.divsi %60, %c2_i32 : i32
      %62 = affine.load %alloca_0[0] : memref<1xi32>
      %63 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c0_i32, %c1_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %64 = arith.index_cast %63 : i32 to index
      %65 = "polygeist.subindex"(%arg2, %64) : (memref<?xi32>, index) -> memref<?xi32>
      %66 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c0_i32, %c1_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %67 = arith.index_cast %66 : i32 to index
      %68 = "polygeist.subindex"(%arg3, %67) : (memref<?xi32>, index) -> memref<?xi32>
      %69 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c1_i32, %c1_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %70 = arith.index_cast %69 : i32 to index
      %71 = "polygeist.subindex"(%arg4, %70) : (memref<?xi32>, index) -> memref<?xi32>
      func.call @_Z11r_tiled_mmmiiPiPKiS1_(%61, %62, %65, %68, %71) {state_base = 5 : i32, state_finish = 6 : i32} : (i32, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>) -> ()
      %72 = affine.load %alloca_1[0] : memref<1xi32>
      %73 = arith.divsi %72, %c2_i32 : i32
      %74 = affine.load %alloca_0[0] : memref<1xi32>
      %75 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c1_i32, %c0_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %76 = arith.index_cast %75 : i32 to index
      %77 = "polygeist.subindex"(%arg2, %76) : (memref<?xi32>, index) -> memref<?xi32>
      %78 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c1_i32, %c1_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %79 = arith.index_cast %78 : i32 to index
      %80 = "polygeist.subindex"(%arg3, %79) : (memref<?xi32>, index) -> memref<?xi32>
      %81 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c1_i32, %c0_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %82 = arith.index_cast %81 : i32 to index
      %83 = "polygeist.subindex"(%arg4, %82) : (memref<?xi32>, index) -> memref<?xi32>
      func.call @_Z11r_tiled_mmmiiPiPKiS1_(%73, %74, %77, %80, %83) {state_base = 6 : i32, state_finish = 7 : i32} : (i32, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>) -> ()
      %84 = affine.load %alloca_1[0] : memref<1xi32>
      %85 = arith.divsi %84, %c2_i32 : i32
      %86 = affine.load %alloca_0[0] : memref<1xi32>
      %87 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c1_i32, %c1_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %88 = arith.index_cast %87 : i32 to index
      %89 = "polygeist.subindex"(%arg2, %88) : (memref<?xi32>, index) -> memref<?xi32>
      %90 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c1_i32, %c1_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %91 = arith.index_cast %90 : i32 to index
      %92 = "polygeist.subindex"(%arg3, %91) : (memref<?xi32>, index) -> memref<?xi32>
      %93 = func.call @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%cast, %c1_i32, %c1_i32) : (memref<?x2xmemref<?xi32>>, i32, i32) -> i32
      %94 = arith.index_cast %93 : i32 to index
      %95 = "polygeist.subindex"(%arg4, %94) : (memref<?xi32>, index) -> memref<?xi32>
      func.call @_Z11r_tiled_mmmiiPiPKiS1_(%85, %86, %89, %92, %95) {state_base = 7 : i32, state_finish = 8 : i32} : (i32, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>) -> ()
    } {state_base = 0 : i32, state_finish = 9 : i32, state_region1 = 8 : i32}
    return
  }
  func.func private @_ZZ11r_tiled_mmmiiPiPKiS1_ENK3$_0clEii(%arg0: memref<?x2xmemref<?xi32>>, %arg1: i32, %arg2: i32) -> i32 attributes {llvm.linkage = #llvm.linkage<internal>} {
    %c2_i32 = arith.constant 2 : i32
    %0 = affine.load %arg0[0, 0] : memref<?x2xmemref<?xi32>>
    %1 = affine.load %0[0] : memref<?xi32>
    %2 = arith.muli %arg1, %1 : i32
    %3 = affine.load %arg0[0, 1] : memref<?x2xmemref<?xi32>>
    %4 = affine.load %3[0] : memref<?xi32>
    %5 = arith.muli %2, %4 : i32
    %6 = arith.divsi %5, %c2_i32 : i32
    %7 = arith.muli %arg2, %4 : i32
    %8 = arith.divsi %7, %c2_i32 : i32
    %9 = arith.addi %6, %8 : i32
    return %9 : i32
  }
  func.func @_Z4testiPi(%arg0: i32, %arg1: memref<?xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2_i32 = arith.constant 2 : i32
    %c1_i32 = arith.constant 1 : i32
    %0 = arith.shli %c1_i32, %arg0 : i32
    %1 = arith.index_cast %0 : i32 to index
    %2 = "polygeist.subindex"(%arg1, %1) : (memref<?xi32>, index) -> memref<?xi32>
    %3 = arith.muli %0, %c2_i32 : i32
    %4 = arith.index_cast %3 : i32 to index
    %5 = "polygeist.subindex"(%arg1, %4) : (memref<?xi32>, index) -> memref<?xi32>
    call @_Z11r_tiled_mmmiiPiPKiS1_(%0, %0, %arg1, %2, %5) : (i32, i32, memref<?xi32>, memref<?xi32>, memref<?xi32>) -> ()
    return
  }
}

