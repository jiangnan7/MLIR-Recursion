; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

declare i8* @malloc(i64)

declare void @free(i8*)

define void @_Z7man_sumjPi(i32 %0, i32* %1) !dbg !3 {
  %3 = alloca i32, i64 512, align 4, !dbg !7
  %4 = alloca i32*, i64 512, align 8, !dbg !9
  %5 = alloca i32, i64 512, align 4, !dbg !10
  store i32 %0, i32* %5, align 4, !dbg !11
  store i32* %1, i32** %4, align 8, !dbg !12
  store i32 0, i32* %3, align 4, !dbg !13
  br label %6, !dbg !14

6:                                                ; preds = %84, %2
  %7 = phi i32 [ %82, %84 ], [ 0, %2 ]
  %8 = phi i1 [ %83, %84 ], [ true, %2 ]
  br i1 %8, label %9, label %85, !dbg !15

9:                                                ; preds = %6
  %10 = phi i32 [ %7, %6 ]
  %11 = sext i32 %10 to i64, !dbg !16
  %12 = getelementptr i32, i32* %5, i64 %11, !dbg !17
  %13 = load i32, i32* %12, align 4, !dbg !18
  %14 = getelementptr i32*, i32** %4, i64 %11, !dbg !19
  %15 = load i32*, i32** %14, align 8, !dbg !20
  %16 = getelementptr i32, i32* %3, i64 %11, !dbg !21
  %17 = load i32, i32* %16, align 4, !dbg !22
  %18 = icmp eq i32 %17, 0, !dbg !23
  br i1 %18, label %19, label %46, !dbg !24

19:                                               ; preds = %9
  %20 = icmp sle i32 %13, 1, !dbg !25
  br i1 %20, label %21, label %32, !dbg !26

21:                                               ; preds = %19
  %22 = icmp eq i32 %10, 0, !dbg !27
  %23 = icmp ne i32 %10, 0, !dbg !28
  br i1 %22, label %24, label %25, !dbg !29

24:                                               ; preds = %21
  br label %27, !dbg !30

25:                                               ; preds = %21
  %26 = add i32 %10, -1, !dbg !31
  br label %27, !dbg !32

27:                                               ; preds = %24, %25
  %28 = phi i32 [ %26, %25 ], [ %10, %24 ]
  br label %29, !dbg !33

29:                                               ; preds = %27, %78
  %30 = phi i32 [ %79, %78 ], [ %28, %27 ]
  %31 = phi i1 [ %80, %78 ], [ %23, %27 ]
  br label %40, !dbg !34

32:                                               ; preds = %19
  %33 = getelementptr i32, i32* %3, i64 %11, !dbg !35
  store i32 1, i32* %33, align 4, !dbg !36
  %34 = add i32 %10, 1, !dbg !37
  %35 = sext i32 %34 to i64, !dbg !38
  %36 = getelementptr i32, i32* %3, i64 %35, !dbg !39
  store i32 0, i32* %36, align 4, !dbg !40
  %37 = sdiv i32 %13, 2, !dbg !41
  %38 = getelementptr i32, i32* %5, i64 %35, !dbg !42
  store i32 %37, i32* %38, align 4, !dbg !43
  %39 = getelementptr i32*, i32** %4, i64 %35, !dbg !44
  store i32* %15, i32** %39, align 8, !dbg !45
  br label %40, !dbg !46

40:                                               ; preds = %29, %32, %48
  %41 = phi i32 [ %50, %48 ], [ %34, %32 ], [ %30, %29 ]
  %42 = phi i1 [ true, %48 ], [ true, %32 ], [ %31, %29 ]
  br label %43, !dbg !47

43:                                               ; preds = %40
  %44 = phi i32 [ %41, %40 ]
  %45 = phi i1 [ %42, %40 ]
  br label %81, !dbg !48

46:                                               ; preds = %9
  %47 = icmp eq i32 %17, 1, !dbg !49
  br i1 %47, label %48, label %59, !dbg !50

48:                                               ; preds = %46
  %49 = getelementptr i32, i32* %3, i64 %11, !dbg !51
  store i32 2, i32* %49, align 4, !dbg !52
  %50 = add i32 %10, 1, !dbg !53
  %51 = sext i32 %50 to i64, !dbg !54
  %52 = getelementptr i32, i32* %3, i64 %51, !dbg !55
  store i32 0, i32* %52, align 4, !dbg !56
  %53 = sdiv i32 %13, 2, !dbg !57
  %54 = sub i32 %13, %53, !dbg !58
  %55 = getelementptr i32, i32* %5, i64 %51, !dbg !59
  store i32 %54, i32* %55, align 4, !dbg !60
  %56 = sext i32 %53 to i64, !dbg !61
  %57 = getelementptr i32, i32* %15, i64 %56, !dbg !62
  %58 = getelementptr i32*, i32** %4, i64 %51, !dbg !63
  store i32* %57, i32** %58, align 8, !dbg !64
  br label %40, !dbg !65

59:                                               ; preds = %46
  %60 = icmp eq i32 %17, 2, !dbg !66
  br i1 %60, label %61, label %75, !dbg !67

61:                                               ; preds = %59
  %62 = sdiv i32 %13, 2, !dbg !68
  %63 = sext i32 %62 to i64, !dbg !69
  %64 = getelementptr i32, i32* %15, i64 %63, !dbg !70
  %65 = load i32, i32* %64, align 4, !dbg !71
  %66 = load i32, i32* %15, align 4, !dbg !72
  %67 = add i32 %66, %65, !dbg !73
  store i32 %67, i32* %15, align 4, !dbg !74
  %68 = icmp eq i32 %10, 0, !dbg !75
  %69 = icmp ne i32 %10, 0, !dbg !76
  br i1 %68, label %70, label %71, !dbg !77

70:                                               ; preds = %61
  br label %73, !dbg !78

71:                                               ; preds = %61
  %72 = add i32 %10, -1, !dbg !79
  br label %73, !dbg !80

73:                                               ; preds = %70, %71
  %74 = phi i32 [ %72, %71 ], [ %10, %70 ]
  br label %75, !dbg !81

75:                                               ; preds = %73, %59
  %76 = phi i32 [ %74, %73 ], [ %10, %59 ]
  %77 = phi i1 [ %69, %73 ], [ true, %59 ]
  br label %78, !dbg !82

78:                                               ; preds = %75
  %79 = phi i32 [ %76, %75 ]
  %80 = phi i1 [ %77, %75 ]
  br label %29, !dbg !83

81:                                               ; preds = %43
  %82 = phi i32 [ %44, %43 ]
  %83 = phi i1 [ %45, %43 ]
  br label %84, !dbg !84

84:                                               ; preds = %81
  br label %6, !dbg !85

85:                                               ; preds = %6
  ret void, !dbg !86
}

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2}

!0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "mlir", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "LLVMDialectModule", directory: "/")
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = distinct !DISubprogram(name: "_Z7man_sumjPi", linkageName: "_Z7man_sumjPi", scope: null, file: !4, line: 2, type: !5, scopeLine: 2, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !6)
!4 = !DIFile(filename: "<stdin>", directory: "/home/jnli/yahu/mlir-hls")
!5 = !DISubroutineType(types: !6)
!6 = !{}
!7 = !DILocation(line: 9, column: 10, scope: !8)
!8 = !DILexicalBlockFile(scope: !3, file: !4, discriminator: 0)
!9 = !DILocation(line: 10, column: 10, scope: !8)
!10 = !DILocation(line: 11, column: 10, scope: !8)
!11 = !DILocation(line: 12, column: 5, scope: !8)
!12 = !DILocation(line: 13, column: 5, scope: !8)
!13 = !DILocation(line: 14, column: 5, scope: !8)
!14 = !DILocation(line: 15, column: 5, scope: !8)
!15 = !DILocation(line: 17, column: 5, scope: !8)
!16 = !DILocation(line: 19, column: 11, scope: !8)
!17 = !DILocation(line: 20, column: 11, scope: !8)
!18 = !DILocation(line: 21, column: 11, scope: !8)
!19 = !DILocation(line: 22, column: 11, scope: !8)
!20 = !DILocation(line: 23, column: 11, scope: !8)
!21 = !DILocation(line: 24, column: 11, scope: !8)
!22 = !DILocation(line: 25, column: 11, scope: !8)
!23 = !DILocation(line: 26, column: 11, scope: !8)
!24 = !DILocation(line: 27, column: 5, scope: !8)
!25 = !DILocation(line: 29, column: 11, scope: !8)
!26 = !DILocation(line: 30, column: 5, scope: !8)
!27 = !DILocation(line: 32, column: 11, scope: !8)
!28 = !DILocation(line: 33, column: 11, scope: !8)
!29 = !DILocation(line: 34, column: 5, scope: !8)
!30 = !DILocation(line: 36, column: 5, scope: !8)
!31 = !DILocation(line: 38, column: 11, scope: !8)
!32 = !DILocation(line: 39, column: 5, scope: !8)
!33 = !DILocation(line: 41, column: 5, scope: !8)
!34 = !DILocation(line: 43, column: 5, scope: !8)
!35 = !DILocation(line: 45, column: 11, scope: !8)
!36 = !DILocation(line: 46, column: 5, scope: !8)
!37 = !DILocation(line: 47, column: 11, scope: !8)
!38 = !DILocation(line: 48, column: 11, scope: !8)
!39 = !DILocation(line: 49, column: 11, scope: !8)
!40 = !DILocation(line: 50, column: 5, scope: !8)
!41 = !DILocation(line: 51, column: 11, scope: !8)
!42 = !DILocation(line: 52, column: 11, scope: !8)
!43 = !DILocation(line: 53, column: 5, scope: !8)
!44 = !DILocation(line: 54, column: 11, scope: !8)
!45 = !DILocation(line: 55, column: 5, scope: !8)
!46 = !DILocation(line: 56, column: 5, scope: !8)
!47 = !DILocation(line: 58, column: 5, scope: !8)
!48 = !DILocation(line: 60, column: 5, scope: !8)
!49 = !DILocation(line: 62, column: 11, scope: !8)
!50 = !DILocation(line: 63, column: 5, scope: !8)
!51 = !DILocation(line: 65, column: 11, scope: !8)
!52 = !DILocation(line: 66, column: 5, scope: !8)
!53 = !DILocation(line: 67, column: 11, scope: !8)
!54 = !DILocation(line: 68, column: 11, scope: !8)
!55 = !DILocation(line: 69, column: 11, scope: !8)
!56 = !DILocation(line: 70, column: 5, scope: !8)
!57 = !DILocation(line: 71, column: 11, scope: !8)
!58 = !DILocation(line: 72, column: 11, scope: !8)
!59 = !DILocation(line: 73, column: 11, scope: !8)
!60 = !DILocation(line: 74, column: 5, scope: !8)
!61 = !DILocation(line: 75, column: 11, scope: !8)
!62 = !DILocation(line: 76, column: 11, scope: !8)
!63 = !DILocation(line: 77, column: 11, scope: !8)
!64 = !DILocation(line: 78, column: 5, scope: !8)
!65 = !DILocation(line: 79, column: 5, scope: !8)
!66 = !DILocation(line: 81, column: 11, scope: !8)
!67 = !DILocation(line: 82, column: 5, scope: !8)
!68 = !DILocation(line: 84, column: 11, scope: !8)
!69 = !DILocation(line: 85, column: 11, scope: !8)
!70 = !DILocation(line: 86, column: 11, scope: !8)
!71 = !DILocation(line: 87, column: 11, scope: !8)
!72 = !DILocation(line: 88, column: 11, scope: !8)
!73 = !DILocation(line: 89, column: 11, scope: !8)
!74 = !DILocation(line: 90, column: 5, scope: !8)
!75 = !DILocation(line: 91, column: 11, scope: !8)
!76 = !DILocation(line: 92, column: 11, scope: !8)
!77 = !DILocation(line: 93, column: 5, scope: !8)
!78 = !DILocation(line: 95, column: 5, scope: !8)
!79 = !DILocation(line: 97, column: 11, scope: !8)
!80 = !DILocation(line: 98, column: 5, scope: !8)
!81 = !DILocation(line: 100, column: 5, scope: !8)
!82 = !DILocation(line: 102, column: 5, scope: !8)
!83 = !DILocation(line: 104, column: 5, scope: !8)
!84 = !DILocation(line: 106, column: 5, scope: !8)
!85 = !DILocation(line: 108, column: 5, scope: !8)
!86 = !DILocation(line: 110, column: 5, scope: !8)
