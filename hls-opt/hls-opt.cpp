// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
// #include "mlir/InitAllPasses.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "hls/InitAllDialects.h"
#include "hls/InitAllPasses.h"


int main(int argc, char **argv) {
//     mlir::registerAllPasses();
// //   mlir::registerPassManagerCLOptions();
//     mlir::DialectRegistry registry;
//     registry.insert<mlir::func::FuncDialect>();
//     registry.insert<mlir::arith::ArithDialect>();
    mlir::DialectRegistry registry;
    mlir::registerAllDialects(registry);
    mlir::hls::registerAllPasses();


  return mlir::failed(mlir::MlirOptMain(
      argc, argv, "HLS Optimization Tool", registry, true));
}

