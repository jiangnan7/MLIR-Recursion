; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "x86_64-unknown-linux-gnu"

declare i8* @malloc(i64)

declare void @free(i8*)

define i32 @_Z12man_ackermanjj(i32 %0, i32 %1) !dbg !3 {
  %3 = alloca i32, i64 ptrtoint (i32* getelementptr (i32, i32* null, i32 512) to i64), align 4, !dbg !7
  %4 = alloca i32, i64 ptrtoint (i32* getelementptr (i32, i32* null, i32 512) to i64), align 4, !dbg !9
  %5 = alloca i32, i64 ptrtoint (i32* getelementptr (i32, i32* null, i32 512) to i64), align 4, !dbg !10
  store i32 %1, i32* %5, align 4, !dbg !11
  store i32 %0, i32* %4, align 4, !dbg !12
  store i32 0, i32* %3, align 4, !dbg !13
  br label %6, !dbg !14

6:                                                ; preds = %27, %23, %37, %44, %53, %58, %72, %65, %2
  %7 = phi i32 [ %11, %72 ], [ %11, %65 ], [ %11, %58 ], [ %11, %53 ], [ %11, %44 ], [ %11, %37 ], [ %28, %27 ], [ %24, %23 ], [ undef, %2 ]
  %8 = phi i32 [ %12, %72 ], [ %12, %65 ], [ %59, %58 ], [ %12, %53 ], [ %45, %44 ], [ %38, %37 ], [ %30, %27 ], [ %12, %23 ], [ 0, %2 ]
  %9 = phi i1 [ %71, %72 ], [ %71, %65 ], [ true, %58 ], [ %55, %53 ], [ true, %44 ], [ true, %37 ], [ %29, %27 ], [ %26, %23 ], [ true, %2 ]
  br i1 %9, label %10, label %73, !dbg !15

10:                                               ; preds = %6
  %11 = phi i32 [ %7, %6 ]
  %12 = phi i32 [ %8, %6 ]
  %13 = sext i32 %12 to i64, !dbg !16
  %14 = getelementptr i32, i32* %3, i64 %13, !dbg !17
  %15 = load i32, i32* %14, align 4, !dbg !18
  %16 = getelementptr i32, i32* %5, i64 %13, !dbg !19
  %17 = load i32, i32* %16, align 4, !dbg !20
  %18 = getelementptr i32, i32* %4, i64 %13, !dbg !21
  %19 = load i32, i32* %18, align 4, !dbg !22
  %20 = icmp eq i32 %15, 0, !dbg !23
  br i1 %20, label %21, label %51, !dbg !24

21:                                               ; preds = %10
  %22 = icmp eq i32 %19, 0, !dbg !25
  br i1 %22, label %23, label %31, !dbg !26

23:                                               ; preds = %21
  %24 = add i32 %17, 1, !dbg !27
  %25 = icmp eq i32 %12, 0, !dbg !28
  %26 = icmp ne i32 %12, 0, !dbg !29
  br i1 %25, label %6, label %27, !dbg !30

27:                                               ; preds = %23, %53, %72
  %28 = phi i32 [ %11, %72 ], [ %11, %53 ], [ %24, %23 ]
  %29 = phi i1 [ %71, %72 ], [ %55, %53 ], [ %26, %23 ]
  %30 = add i32 %12, -1, !dbg !31
  br label %6, !dbg !32

31:                                               ; preds = %21
  %32 = icmp sgt i32 %19, 0, !dbg !33
  br i1 %32, label %33, label %35, !dbg !34

33:                                               ; preds = %31
  %34 = icmp eq i32 %17, 0, !dbg !35
  br label %35, !dbg !36

35:                                               ; preds = %33, %31
  %36 = phi i1 [ %34, %33 ], [ false, %31 ]
  br i1 %36, label %37, label %44, !dbg !37

37:                                               ; preds = %35
  store i32 1, i32* %14, align 4, !dbg !38
  %38 = add i32 %12, 1, !dbg !39
  %39 = sext i32 %38 to i64, !dbg !40
  %40 = getelementptr i32, i32* %3, i64 %39, !dbg !41
  store i32 0, i32* %40, align 4, !dbg !42
  %41 = add i32 %19, -1, !dbg !43
  %42 = getelementptr i32, i32* %4, i64 %39, !dbg !44
  store i32 %41, i32* %42, align 4, !dbg !45
  %43 = getelementptr i32, i32* %5, i64 %39, !dbg !46
  store i32 1, i32* %43, align 4, !dbg !47
  br label %6, !dbg !48

44:                                               ; preds = %35
  store i32 2, i32* %14, align 4, !dbg !49
  %45 = add i32 %12, 1, !dbg !50
  %46 = sext i32 %45 to i64, !dbg !51
  %47 = getelementptr i32, i32* %3, i64 %46, !dbg !52
  store i32 0, i32* %47, align 4, !dbg !53
  %48 = getelementptr i32, i32* %4, i64 %46, !dbg !54
  store i32 %19, i32* %48, align 4, !dbg !55
  %49 = add i32 %17, -1, !dbg !56
  %50 = getelementptr i32, i32* %5, i64 %46, !dbg !57
  store i32 %49, i32* %50, align 4, !dbg !58
  br label %6, !dbg !59

51:                                               ; preds = %10
  %52 = icmp eq i32 %15, 1, !dbg !60
  br i1 %52, label %53, label %56, !dbg !61

53:                                               ; preds = %51
  %54 = icmp eq i32 %12, 0, !dbg !62
  %55 = icmp ne i32 %12, 0, !dbg !63
  br i1 %54, label %6, label %27, !dbg !64

56:                                               ; preds = %51
  %57 = icmp eq i32 %15, 2, !dbg !65
  br i1 %57, label %58, label %65, !dbg !66

58:                                               ; preds = %56
  store i32 %11, i32* %16, align 4, !dbg !67
  store i32 3, i32* %14, align 4, !dbg !68
  %59 = add i32 %12, 1, !dbg !69
  %60 = sext i32 %59 to i64, !dbg !70
  %61 = getelementptr i32, i32* %3, i64 %60, !dbg !71
  store i32 0, i32* %61, align 4, !dbg !72
  %62 = add i32 %19, -1, !dbg !73
  %63 = getelementptr i32, i32* %4, i64 %60, !dbg !74
  store i32 %62, i32* %63, align 4, !dbg !75
  %64 = getelementptr i32, i32* %5, i64 %60, !dbg !76
  store i32 %11, i32* %64, align 4, !dbg !77
  br label %6, !dbg !78

65:                                               ; preds = %56
  %66 = icmp eq i32 %15, 3, !dbg !79
  %67 = icmp eq i32 %12, 0, !dbg !80
  %68 = icmp ne i32 %12, 0, !dbg !81
  %69 = icmp ne i32 %15, 3, !dbg !82
  %70 = and i1 %66, %68, !dbg !83
  %71 = or i1 %70, %69, !dbg !84
  br i1 %66, label %72, label %6, !dbg !85

72:                                               ; preds = %65
  br i1 %67, label %6, label %27, !dbg !86

73:                                               ; preds = %6
  ret i32 %7, !dbg !87
}

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2}

!0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "mlir", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "LLVMDialectModule", directory: "/")
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = distinct !DISubprogram(name: "_Z12man_ackermanjj", linkageName: "_Z12man_ackermanjj", scope: null, file: !4, line: 2, type: !5, scopeLine: 2, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !6)
!4 = !DIFile(filename: "<stdin>", directory: "/home/jnli/yahu/mlir-hls")
!5 = !DISubroutineType(types: !6)
!6 = !{}
!7 = !DILocation(line: 14, column: 11, scope: !8)
!8 = !DILexicalBlockFile(scope: !3, file: !4, discriminator: 0)
!9 = !DILocation(line: 15, column: 11, scope: !8)
!10 = !DILocation(line: 16, column: 11, scope: !8)
!11 = !DILocation(line: 17, column: 5, scope: !8)
!12 = !DILocation(line: 18, column: 5, scope: !8)
!13 = !DILocation(line: 19, column: 5, scope: !8)
!14 = !DILocation(line: 20, column: 5, scope: !8)
!15 = !DILocation(line: 22, column: 5, scope: !8)
!16 = !DILocation(line: 24, column: 11, scope: !8)
!17 = !DILocation(line: 25, column: 11, scope: !8)
!18 = !DILocation(line: 26, column: 11, scope: !8)
!19 = !DILocation(line: 27, column: 11, scope: !8)
!20 = !DILocation(line: 28, column: 11, scope: !8)
!21 = !DILocation(line: 29, column: 11, scope: !8)
!22 = !DILocation(line: 30, column: 11, scope: !8)
!23 = !DILocation(line: 31, column: 11, scope: !8)
!24 = !DILocation(line: 32, column: 5, scope: !8)
!25 = !DILocation(line: 34, column: 11, scope: !8)
!26 = !DILocation(line: 35, column: 5, scope: !8)
!27 = !DILocation(line: 37, column: 11, scope: !8)
!28 = !DILocation(line: 38, column: 11, scope: !8)
!29 = !DILocation(line: 39, column: 11, scope: !8)
!30 = !DILocation(line: 40, column: 5, scope: !8)
!31 = !DILocation(line: 42, column: 11, scope: !8)
!32 = !DILocation(line: 43, column: 5, scope: !8)
!33 = !DILocation(line: 45, column: 11, scope: !8)
!34 = !DILocation(line: 46, column: 5, scope: !8)
!35 = !DILocation(line: 48, column: 11, scope: !8)
!36 = !DILocation(line: 49, column: 5, scope: !8)
!37 = !DILocation(line: 51, column: 5, scope: !8)
!38 = !DILocation(line: 53, column: 5, scope: !8)
!39 = !DILocation(line: 54, column: 11, scope: !8)
!40 = !DILocation(line: 55, column: 11, scope: !8)
!41 = !DILocation(line: 56, column: 11, scope: !8)
!42 = !DILocation(line: 57, column: 5, scope: !8)
!43 = !DILocation(line: 58, column: 11, scope: !8)
!44 = !DILocation(line: 59, column: 11, scope: !8)
!45 = !DILocation(line: 60, column: 5, scope: !8)
!46 = !DILocation(line: 61, column: 11, scope: !8)
!47 = !DILocation(line: 62, column: 5, scope: !8)
!48 = !DILocation(line: 63, column: 5, scope: !8)
!49 = !DILocation(line: 65, column: 5, scope: !8)
!50 = !DILocation(line: 66, column: 11, scope: !8)
!51 = !DILocation(line: 67, column: 11, scope: !8)
!52 = !DILocation(line: 68, column: 11, scope: !8)
!53 = !DILocation(line: 69, column: 5, scope: !8)
!54 = !DILocation(line: 70, column: 11, scope: !8)
!55 = !DILocation(line: 71, column: 5, scope: !8)
!56 = !DILocation(line: 72, column: 11, scope: !8)
!57 = !DILocation(line: 73, column: 11, scope: !8)
!58 = !DILocation(line: 74, column: 5, scope: !8)
!59 = !DILocation(line: 75, column: 5, scope: !8)
!60 = !DILocation(line: 77, column: 11, scope: !8)
!61 = !DILocation(line: 78, column: 5, scope: !8)
!62 = !DILocation(line: 80, column: 11, scope: !8)
!63 = !DILocation(line: 81, column: 11, scope: !8)
!64 = !DILocation(line: 82, column: 5, scope: !8)
!65 = !DILocation(line: 84, column: 11, scope: !8)
!66 = !DILocation(line: 85, column: 5, scope: !8)
!67 = !DILocation(line: 87, column: 5, scope: !8)
!68 = !DILocation(line: 88, column: 5, scope: !8)
!69 = !DILocation(line: 89, column: 11, scope: !8)
!70 = !DILocation(line: 90, column: 11, scope: !8)
!71 = !DILocation(line: 91, column: 11, scope: !8)
!72 = !DILocation(line: 92, column: 5, scope: !8)
!73 = !DILocation(line: 93, column: 11, scope: !8)
!74 = !DILocation(line: 94, column: 11, scope: !8)
!75 = !DILocation(line: 95, column: 5, scope: !8)
!76 = !DILocation(line: 96, column: 11, scope: !8)
!77 = !DILocation(line: 97, column: 5, scope: !8)
!78 = !DILocation(line: 98, column: 5, scope: !8)
!79 = !DILocation(line: 100, column: 11, scope: !8)
!80 = !DILocation(line: 101, column: 11, scope: !8)
!81 = !DILocation(line: 102, column: 11, scope: !8)
!82 = !DILocation(line: 103, column: 11, scope: !8)
!83 = !DILocation(line: 104, column: 11, scope: !8)
!84 = !DILocation(line: 105, column: 11, scope: !8)
!85 = !DILocation(line: 106, column: 5, scope: !8)
!86 = !DILocation(line: 108, column: 5, scope: !8)
!87 = !DILocation(line: 110, column: 5, scope: !8)
