; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

declare i8* @malloc(i64)

declare void @free(i8*)

define void @_Z8man_sortPji(i32* %0, i32 %1) !dbg !3 {
  %3 = alloca i32, i64 512, align 4, !dbg !7
  %4 = alloca i32, i64 512, align 4, !dbg !9
  %5 = alloca i32, i64 512, align 4, !dbg !10
  %6 = alloca i32*, i64 512, align 8, !dbg !11
  store i32* %0, i32** %6, align 8, !dbg !12
  store i32 %1, i32* %5, align 4, !dbg !13
  store i32 0, i32* %3, align 4, !dbg !14
  br label %7, !dbg !15

7:                                                ; preds = %165, %2
  %8 = phi i32 [ %163, %165 ], [ 0, %2 ]
  %9 = phi i1 [ %164, %165 ], [ true, %2 ]
  br i1 %9, label %10, label %166, !dbg !16

10:                                               ; preds = %7
  %11 = phi i32 [ %8, %7 ]
  %12 = sext i32 %11 to i64, !dbg !17
  %13 = getelementptr i32*, i32** %6, i64 %12, !dbg !18
  %14 = load i32*, i32** %13, align 8, !dbg !19
  %15 = getelementptr i32, i32* %5, i64 %12, !dbg !20
  %16 = load i32, i32* %15, align 4, !dbg !21
  %17 = getelementptr i32, i32* %4, i64 %12, !dbg !22
  %18 = load i32, i32* %17, align 4, !dbg !23
  %19 = getelementptr i32, i32* %3, i64 %12, !dbg !24
  %20 = load i32, i32* %19, align 4, !dbg !25
  %21 = icmp eq i32 %20, 0, !dbg !26
  br i1 %21, label %22, label %135, !dbg !27

22:                                               ; preds = %10
  %23 = icmp slt i32 %16, 32, !dbg !28
  br i1 %23, label %24, label %71, !dbg !29

24:                                               ; preds = %22
  %25 = sext i32 %16 to i64, !dbg !30
  br label %26, !dbg !31

26:                                               ; preds = %55, %24
  %27 = phi i64 [ %58, %55 ], [ 1, %24 ]
  %28 = icmp slt i64 %27, %25, !dbg !32
  br i1 %28, label %29, label %59, !dbg !33

29:                                               ; preds = %26
  %30 = trunc i64 %27 to i32, !dbg !34
  %31 = getelementptr i32, i32* %14, i64 %27, !dbg !35
  %32 = load i32, i32* %31, align 4, !dbg !36
  br label %33, !dbg !37

33:                                               ; preds = %54, %29
  %34 = phi i32 [ %53, %54 ], [ %30, %29 ]
  %35 = icmp sgt i32 %34, 0, !dbg !38
  br i1 %35, label %36, label %48, !dbg !39

36:                                               ; preds = %33
  %37 = add i32 %34, -1, !dbg !40
  %38 = sext i32 %37 to i64, !dbg !41
  %39 = getelementptr i32, i32* %14, i64 %38, !dbg !42
  %40 = load i32, i32* %39, align 4, !dbg !43
  %41 = icmp slt i32 %32, %40, !dbg !44
  %42 = select i1 %41, i32 %37, i32 %34, !dbg !45
  br i1 %41, label %43, label %48, !dbg !46

43:                                               ; preds = %36
  %44 = sext i32 %34 to i64, !dbg !47
  %45 = getelementptr i32, i32* %14, i64 %38, !dbg !48
  %46 = load i32, i32* %45, align 4, !dbg !49
  %47 = getelementptr i32, i32* %14, i64 %44, !dbg !50
  store i32 %46, i32* %47, align 4, !dbg !51
  br label %48, !dbg !52

48:                                               ; preds = %43, %36, %33
  %49 = phi i1 [ %41, %43 ], [ %41, %36 ], [ false, %33 ]
  %50 = phi i32 [ %42, %43 ], [ %42, %36 ], [ %34, %33 ]
  br label %51, !dbg !53

51:                                               ; preds = %48
  %52 = phi i1 [ %49, %48 ]
  %53 = phi i32 [ %50, %48 ]
  br label %54, !dbg !54

54:                                               ; preds = %51
  br i1 %52, label %33, label %55, !dbg !55

55:                                               ; preds = %54
  %56 = sext i32 %53 to i64, !dbg !56
  %57 = getelementptr i32, i32* %14, i64 %56, !dbg !57
  store i32 %32, i32* %57, align 4, !dbg !58
  %58 = add i64 %27, 1, !dbg !59
  br label %26, !dbg !60

59:                                               ; preds = %26
  %60 = icmp eq i32 %11, 0, !dbg !61
  %61 = icmp ne i32 %11, 0, !dbg !62
  br i1 %60, label %62, label %63, !dbg !63

62:                                               ; preds = %59
  br label %65, !dbg !64

63:                                               ; preds = %59
  %64 = add i32 %11, -1, !dbg !65
  br label %65, !dbg !66

65:                                               ; preds = %62, %63, %160
  %66 = phi i32 [ %161, %160 ], [ %64, %63 ], [ %11, %62 ]
  %67 = phi i1 [ %153, %160 ], [ %61, %63 ], [ %61, %62 ]
  br label %68, !dbg !67

68:                                               ; preds = %65
  %69 = phi i32 [ %66, %65 ]
  %70 = phi i1 [ %67, %65 ]
  br label %129, !dbg !68

71:                                               ; preds = %22
  %72 = sdiv i32 %16, 2, !dbg !69
  %73 = sext i32 %72 to i64, !dbg !70
  %74 = getelementptr i32, i32* %14, i64 %73, !dbg !71
  %75 = load i32, i32* %74, align 4, !dbg !72
  %76 = add i32 %16, -1, !dbg !73
  br label %77, !dbg !74

77:                                               ; preds = %120, %71
  %78 = phi i32 [ %118, %120 ], [ %76, %71 ]
  %79 = phi i32 [ %119, %120 ], [ 0, %71 ]
  %80 = phi i1 [ %104, %120 ], [ true, %71 ]
  br i1 %80, label %81, label %121, !dbg !75

81:                                               ; preds = %77
  %82 = phi i32 [ %79, %77 ]
  %83 = phi i32 [ %78, %77 ]
  br label %84, !dbg !76

84:                                               ; preds = %90, %81
  %85 = phi i32 [ %92, %90 ], [ %82, %81 ]
  %86 = sext i32 %85 to i64, !dbg !77
  %87 = getelementptr i32, i32* %14, i64 %86, !dbg !78
  %88 = load i32, i32* %87, align 4, !dbg !79
  %89 = icmp slt i32 %88, %75, !dbg !80
  br i1 %89, label %90, label %93, !dbg !81

90:                                               ; preds = %84
  %91 = phi i32 [ %85, %84 ]
  %92 = add i32 %91, 1, !dbg !82
  br label %84, !dbg !83

93:                                               ; preds = %84
  br label %94, !dbg !84

94:                                               ; preds = %100, %93
  %95 = phi i32 [ %102, %100 ], [ %83, %93 ]
  %96 = sext i32 %95 to i64, !dbg !85
  %97 = getelementptr i32, i32* %14, i64 %96, !dbg !86
  %98 = load i32, i32* %97, align 4, !dbg !87
  %99 = icmp slt i32 %75, %98, !dbg !88
  br i1 %99, label %100, label %103, !dbg !89

100:                                              ; preds = %94
  %101 = phi i32 [ %95, %94 ]
  %102 = add i32 %101, -1, !dbg !90
  br label %94, !dbg !91

103:                                              ; preds = %94
  %104 = icmp slt i32 %85, %95, !dbg !92
  br i1 %104, label %105, label %116, !dbg !93

105:                                              ; preds = %103
  %106 = sext i32 %85 to i64, !dbg !94
  %107 = getelementptr i32, i32* %14, i64 %106, !dbg !95
  %108 = load i32, i32* %107, align 4, !dbg !96
  %109 = sext i32 %95 to i64, !dbg !97
  %110 = getelementptr i32, i32* %14, i64 %109, !dbg !98
  %111 = load i32, i32* %110, align 4, !dbg !99
  %112 = getelementptr i32, i32* %14, i64 %106, !dbg !100
  store i32 %111, i32* %112, align 4, !dbg !101
  %113 = getelementptr i32, i32* %14, i64 %109, !dbg !102
  store i32 %108, i32* %113, align 4, !dbg !103
  %114 = add i32 %85, 1, !dbg !104
  %115 = add i32 %95, -1, !dbg !105
  br label %117, !dbg !106

116:                                              ; preds = %103
  br label %117, !dbg !107

117:                                              ; preds = %105, %116
  %118 = phi i32 [ %95, %116 ], [ %115, %105 ]
  %119 = phi i32 [ %85, %116 ], [ %114, %105 ]
  br label %120, !dbg !108

120:                                              ; preds = %117
  br label %77, !dbg !109

121:                                              ; preds = %77
  %122 = getelementptr i32, i32* %4, i64 %12, !dbg !110
  store i32 %79, i32* %122, align 4, !dbg !111
  %123 = getelementptr i32, i32* %3, i64 %12, !dbg !112
  store i32 1, i32* %123, align 4, !dbg !113
  %124 = add i32 %11, 1, !dbg !114
  %125 = sext i32 %124 to i64, !dbg !115
  %126 = getelementptr i32, i32* %3, i64 %125, !dbg !116
  store i32 0, i32* %126, align 4, !dbg !117
  %127 = getelementptr i32*, i32** %6, i64 %125, !dbg !118
  store i32* %14, i32** %127, align 8, !dbg !119
  %128 = getelementptr i32, i32* %5, i64 %125, !dbg !120
  store i32 %79, i32* %128, align 4, !dbg !121
  br label %129, !dbg !122

129:                                              ; preds = %68, %121, %137
  %130 = phi i32 [ %139, %137 ], [ %124, %121 ], [ %69, %68 ]
  %131 = phi i1 [ true, %137 ], [ true, %121 ], [ %70, %68 ]
  br label %132, !dbg !123

132:                                              ; preds = %129
  %133 = phi i32 [ %130, %129 ]
  %134 = phi i1 [ %131, %129 ]
  br label %162, !dbg !124

135:                                              ; preds = %10
  %136 = icmp eq i32 %20, 1, !dbg !125
  br i1 %136, label %137, label %147, !dbg !126

137:                                              ; preds = %135
  %138 = getelementptr i32, i32* %3, i64 %12, !dbg !127
  store i32 2, i32* %138, align 4, !dbg !128
  %139 = add i32 %11, 1, !dbg !129
  %140 = sext i32 %139 to i64, !dbg !130
  %141 = getelementptr i32, i32* %3, i64 %140, !dbg !131
  store i32 0, i32* %141, align 4, !dbg !132
  %142 = sext i32 %18 to i64, !dbg !133
  %143 = getelementptr i32, i32* %14, i64 %142, !dbg !134
  %144 = getelementptr i32*, i32** %6, i64 %140, !dbg !135
  store i32* %143, i32** %144, align 8, !dbg !136
  %145 = sub i32 %16, %18, !dbg !137
  %146 = getelementptr i32, i32* %5, i64 %140, !dbg !138
  store i32 %145, i32* %146, align 4, !dbg !139
  br label %129, !dbg !140

147:                                              ; preds = %135
  %148 = icmp eq i32 %20, 2, !dbg !141
  %149 = icmp eq i32 %11, 0, !dbg !142
  %150 = icmp ne i32 %11, 0, !dbg !143
  %151 = icmp ne i32 %20, 2, !dbg !144
  %152 = and i1 %148, %150, !dbg !145
  %153 = or i1 %152, %151, !dbg !146
  br i1 %148, label %154, label %160, !dbg !147

154:                                              ; preds = %147
  br i1 %149, label %155, label %156, !dbg !148

155:                                              ; preds = %154
  br label %158, !dbg !149

156:                                              ; preds = %154
  %157 = add i32 %11, -1, !dbg !150
  br label %158, !dbg !151

158:                                              ; preds = %155, %156
  %159 = phi i32 [ %157, %156 ], [ %11, %155 ]
  br label %160, !dbg !152

160:                                              ; preds = %158, %147
  %161 = phi i32 [ %159, %158 ], [ %11, %147 ]
  br label %65, !dbg !153

162:                                              ; preds = %132
  %163 = phi i32 [ %133, %132 ]
  %164 = phi i1 [ %134, %132 ]
  br label %165, !dbg !154

165:                                              ; preds = %162
  br label %7, !dbg !155

166:                                              ; preds = %7
  ret void, !dbg !156
}

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2}

!0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "mlir", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "LLVMDialectModule", directory: "/")
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = distinct !DISubprogram(name: "_Z8man_sortPji", linkageName: "_Z8man_sortPji", scope: null, file: !4, line: 2, type: !5, scopeLine: 2, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !6)
!4 = !DIFile(filename: "<stdin>", directory: "/home/jnli/yahu/mlir-hls")
!5 = !DISubroutineType(types: !6)
!6 = !{}
!7 = !DILocation(line: 12, column: 10, scope: !8)
!8 = !DILexicalBlockFile(scope: !3, file: !4, discriminator: 0)
!9 = !DILocation(line: 13, column: 11, scope: !8)
!10 = !DILocation(line: 14, column: 11, scope: !8)
!11 = !DILocation(line: 15, column: 11, scope: !8)
!12 = !DILocation(line: 16, column: 5, scope: !8)
!13 = !DILocation(line: 17, column: 5, scope: !8)
!14 = !DILocation(line: 18, column: 5, scope: !8)
!15 = !DILocation(line: 19, column: 5, scope: !8)
!16 = !DILocation(line: 21, column: 5, scope: !8)
!17 = !DILocation(line: 23, column: 11, scope: !8)
!18 = !DILocation(line: 24, column: 11, scope: !8)
!19 = !DILocation(line: 25, column: 11, scope: !8)
!20 = !DILocation(line: 26, column: 11, scope: !8)
!21 = !DILocation(line: 27, column: 11, scope: !8)
!22 = !DILocation(line: 28, column: 11, scope: !8)
!23 = !DILocation(line: 29, column: 11, scope: !8)
!24 = !DILocation(line: 30, column: 11, scope: !8)
!25 = !DILocation(line: 31, column: 11, scope: !8)
!26 = !DILocation(line: 32, column: 11, scope: !8)
!27 = !DILocation(line: 33, column: 5, scope: !8)
!28 = !DILocation(line: 35, column: 11, scope: !8)
!29 = !DILocation(line: 36, column: 5, scope: !8)
!30 = !DILocation(line: 38, column: 11, scope: !8)
!31 = !DILocation(line: 39, column: 5, scope: !8)
!32 = !DILocation(line: 41, column: 11, scope: !8)
!33 = !DILocation(line: 42, column: 5, scope: !8)
!34 = !DILocation(line: 44, column: 11, scope: !8)
!35 = !DILocation(line: 45, column: 11, scope: !8)
!36 = !DILocation(line: 46, column: 11, scope: !8)
!37 = !DILocation(line: 47, column: 5, scope: !8)
!38 = !DILocation(line: 49, column: 11, scope: !8)
!39 = !DILocation(line: 50, column: 5, scope: !8)
!40 = !DILocation(line: 52, column: 11, scope: !8)
!41 = !DILocation(line: 53, column: 11, scope: !8)
!42 = !DILocation(line: 54, column: 11, scope: !8)
!43 = !DILocation(line: 55, column: 11, scope: !8)
!44 = !DILocation(line: 56, column: 11, scope: !8)
!45 = !DILocation(line: 57, column: 11, scope: !8)
!46 = !DILocation(line: 58, column: 5, scope: !8)
!47 = !DILocation(line: 60, column: 11, scope: !8)
!48 = !DILocation(line: 61, column: 11, scope: !8)
!49 = !DILocation(line: 62, column: 11, scope: !8)
!50 = !DILocation(line: 63, column: 11, scope: !8)
!51 = !DILocation(line: 64, column: 5, scope: !8)
!52 = !DILocation(line: 65, column: 5, scope: !8)
!53 = !DILocation(line: 67, column: 5, scope: !8)
!54 = !DILocation(line: 69, column: 5, scope: !8)
!55 = !DILocation(line: 71, column: 5, scope: !8)
!56 = !DILocation(line: 73, column: 11, scope: !8)
!57 = !DILocation(line: 74, column: 11, scope: !8)
!58 = !DILocation(line: 75, column: 5, scope: !8)
!59 = !DILocation(line: 76, column: 11, scope: !8)
!60 = !DILocation(line: 77, column: 5, scope: !8)
!61 = !DILocation(line: 79, column: 11, scope: !8)
!62 = !DILocation(line: 80, column: 11, scope: !8)
!63 = !DILocation(line: 81, column: 5, scope: !8)
!64 = !DILocation(line: 83, column: 5, scope: !8)
!65 = !DILocation(line: 85, column: 11, scope: !8)
!66 = !DILocation(line: 86, column: 5, scope: !8)
!67 = !DILocation(line: 88, column: 5, scope: !8)
!68 = !DILocation(line: 90, column: 5, scope: !8)
!69 = !DILocation(line: 92, column: 11, scope: !8)
!70 = !DILocation(line: 93, column: 11, scope: !8)
!71 = !DILocation(line: 94, column: 11, scope: !8)
!72 = !DILocation(line: 95, column: 11, scope: !8)
!73 = !DILocation(line: 96, column: 11, scope: !8)
!74 = !DILocation(line: 97, column: 5, scope: !8)
!75 = !DILocation(line: 99, column: 5, scope: !8)
!76 = !DILocation(line: 101, column: 5, scope: !8)
!77 = !DILocation(line: 103, column: 11, scope: !8)
!78 = !DILocation(line: 104, column: 11, scope: !8)
!79 = !DILocation(line: 105, column: 11, scope: !8)
!80 = !DILocation(line: 106, column: 11, scope: !8)
!81 = !DILocation(line: 107, column: 5, scope: !8)
!82 = !DILocation(line: 109, column: 11, scope: !8)
!83 = !DILocation(line: 110, column: 5, scope: !8)
!84 = !DILocation(line: 112, column: 5, scope: !8)
!85 = !DILocation(line: 114, column: 11, scope: !8)
!86 = !DILocation(line: 115, column: 11, scope: !8)
!87 = !DILocation(line: 116, column: 11, scope: !8)
!88 = !DILocation(line: 117, column: 11, scope: !8)
!89 = !DILocation(line: 118, column: 5, scope: !8)
!90 = !DILocation(line: 120, column: 11, scope: !8)
!91 = !DILocation(line: 121, column: 5, scope: !8)
!92 = !DILocation(line: 123, column: 11, scope: !8)
!93 = !DILocation(line: 124, column: 5, scope: !8)
!94 = !DILocation(line: 126, column: 11, scope: !8)
!95 = !DILocation(line: 127, column: 11, scope: !8)
!96 = !DILocation(line: 128, column: 11, scope: !8)
!97 = !DILocation(line: 129, column: 11, scope: !8)
!98 = !DILocation(line: 130, column: 11, scope: !8)
!99 = !DILocation(line: 131, column: 11, scope: !8)
!100 = !DILocation(line: 132, column: 11, scope: !8)
!101 = !DILocation(line: 133, column: 5, scope: !8)
!102 = !DILocation(line: 134, column: 11, scope: !8)
!103 = !DILocation(line: 135, column: 5, scope: !8)
!104 = !DILocation(line: 136, column: 11, scope: !8)
!105 = !DILocation(line: 137, column: 11, scope: !8)
!106 = !DILocation(line: 138, column: 5, scope: !8)
!107 = !DILocation(line: 140, column: 5, scope: !8)
!108 = !DILocation(line: 142, column: 5, scope: !8)
!109 = !DILocation(line: 144, column: 5, scope: !8)
!110 = !DILocation(line: 146, column: 11, scope: !8)
!111 = !DILocation(line: 147, column: 5, scope: !8)
!112 = !DILocation(line: 148, column: 11, scope: !8)
!113 = !DILocation(line: 149, column: 5, scope: !8)
!114 = !DILocation(line: 150, column: 11, scope: !8)
!115 = !DILocation(line: 151, column: 11, scope: !8)
!116 = !DILocation(line: 152, column: 12, scope: !8)
!117 = !DILocation(line: 153, column: 5, scope: !8)
!118 = !DILocation(line: 154, column: 12, scope: !8)
!119 = !DILocation(line: 155, column: 5, scope: !8)
!120 = !DILocation(line: 156, column: 12, scope: !8)
!121 = !DILocation(line: 157, column: 5, scope: !8)
!122 = !DILocation(line: 158, column: 5, scope: !8)
!123 = !DILocation(line: 160, column: 5, scope: !8)
!124 = !DILocation(line: 162, column: 5, scope: !8)
!125 = !DILocation(line: 164, column: 12, scope: !8)
!126 = !DILocation(line: 165, column: 5, scope: !8)
!127 = !DILocation(line: 167, column: 12, scope: !8)
!128 = !DILocation(line: 168, column: 5, scope: !8)
!129 = !DILocation(line: 169, column: 12, scope: !8)
!130 = !DILocation(line: 170, column: 12, scope: !8)
!131 = !DILocation(line: 171, column: 12, scope: !8)
!132 = !DILocation(line: 172, column: 5, scope: !8)
!133 = !DILocation(line: 173, column: 12, scope: !8)
!134 = !DILocation(line: 174, column: 12, scope: !8)
!135 = !DILocation(line: 175, column: 12, scope: !8)
!136 = !DILocation(line: 176, column: 5, scope: !8)
!137 = !DILocation(line: 177, column: 12, scope: !8)
!138 = !DILocation(line: 178, column: 12, scope: !8)
!139 = !DILocation(line: 179, column: 5, scope: !8)
!140 = !DILocation(line: 180, column: 5, scope: !8)
!141 = !DILocation(line: 182, column: 12, scope: !8)
!142 = !DILocation(line: 183, column: 12, scope: !8)
!143 = !DILocation(line: 184, column: 12, scope: !8)
!144 = !DILocation(line: 185, column: 12, scope: !8)
!145 = !DILocation(line: 186, column: 12, scope: !8)
!146 = !DILocation(line: 187, column: 12, scope: !8)
!147 = !DILocation(line: 188, column: 5, scope: !8)
!148 = !DILocation(line: 190, column: 5, scope: !8)
!149 = !DILocation(line: 192, column: 5, scope: !8)
!150 = !DILocation(line: 194, column: 12, scope: !8)
!151 = !DILocation(line: 195, column: 5, scope: !8)
!152 = !DILocation(line: 197, column: 5, scope: !8)
!153 = !DILocation(line: 199, column: 5, scope: !8)
!154 = !DILocation(line: 201, column: 5, scope: !8)
!155 = !DILocation(line: 203, column: 5, scope: !8)
!156 = !DILocation(line: 205, column: 5, scope: !8)
