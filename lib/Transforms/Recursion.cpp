#include "hls/Transforms/Passes.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/IR/ImplicitLocOpBuilder.h"
#include "mlir/IR/Location.h"
#include "mlir/IR/TypeRange.h"
#include "mlir/IR/Value.h"
#include "mlir/IR/ValueRange.h"
#include "mlir/IR/OperationSupport.h"
#include "mlir/IR/Operation.h"
#include "mlir/Transforms/DialectConversion.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/MLIRContext.h"

#include <iostream>
#include <string>
#include <vector>

using namespace mlir;
using namespace hls;
using namespace mlir::scf;
using namespace mlir::arith;



namespace {
struct OptimizeTailRecursionPass : public OptimizeTailRecursionPassBase<OptimizeTailRecursionPass> {
  void runOnOperation() override;
};
struct OptimizeRecursionPass : public OptimizeRecursionPassBase<OptimizeRecursionPass> {
  void runOnOperation() override;
};
} // namespace



//Tail Recursion
void OptimizeTailRecursionPass::runOnOperation() {
  
  func::FuncOp func = getOperation(); //get funcOp
  auto context = func.getContext();

  OpBuilder builder(func.getBody());
  Location funcLoc = builder.getUnknownLoc();

  Block &entryBlock = func.getBody().front();
  Value firstArg = entryBlock.getArgument(0);

  Type firstArgType = firstArg.getType();
  Value firstArgIndex = builder.create<arith::IndexCastOp>(funcLoc,
                                            builder.getIndexType(), firstArg);
  // MemRefType dynamicBufferType =
  //     MemRefType::get(ShapedType::kDynamic,firstArgType);
  // Value inputMem = builder.create<memref::AllocaOp>(funcLoc, dynamicBufferType, firstArgIndex);
  MemRefType memRefType = MemRefType::get({512}, firstArgType);
  Value inputMem = builder.create<memref::AllocaOp>(funcLoc, memRefType);

  
  for(auto &op : func.front()){
    if (auto ifOp = dyn_cast<scf::IfOp>(op)) {
        Region &elseRegion = ifOp.getElseRegion();
        OpBuilder builder(&elseRegion.front().front());
        Location elseLoc = elseRegion.getLoc();

        //Get ifop condition value and constantop
        Value conditionValue = ifOp.getCondition();
        auto condop = conditionValue.getDefiningOp()->getOperand(1).getDefiningOp();
        int64_t ifConstOpInt = 1;
        if (auto constOp = dyn_cast<arith::ConstantIntOp>(condop)) {
          ifConstOpInt  = constOp.value();
        }

        //Initialize variables according to ifOp condaition
        for(int i=0; i < ifConstOpInt; i++){
            Value indexIfResult = builder.create<ConstantIndexOp>(elseLoc, i);
            Value valueIfResult = builder.create<ConstantIntOp>(elseLoc, 1, 32);
            builder.create<memref::StoreOp>(elseLoc, valueIfResult, inputMem, indexIfResult);     
        }  
        //input i32-> index
        Value inputNext = builder.create<arith::AddIOp>(builder.getUnknownLoc(), firstArg, 
                                builder.create<arith::ConstantIntOp>(builder.getUnknownLoc(), 1, 32));
        Value inputIndexNext= builder.create<arith::IndexCastOp>(builder.getUnknownLoc(), builder.getIndexType(), inputNext);
        Value lb = builder.create<arith::ConstantIndexOp>(elseLoc, ifConstOpInt);
        Value ub = builder.create<arith::ConstantIndexOp>(elseLoc, 512);//n
        Value step = builder.create<arith::ConstantIndexOp>(elseLoc, 1);

        scf::ForOp forOp = builder.create<mlir::scf::ForOp>(elseLoc, lb, inputIndexNext, step);
        //Update the returne value
        for (Operation &op : elseRegion.front()) {  //front
          if (auto returnOp = dyn_cast<mlir::func::ReturnOp>(&op)) {
              llvm::outs() << "return " << "\n";
          }
          else if (auto yieldOp = dyn_cast<mlir::scf::YieldOp>(&op)) {
              auto yieldValues = op.getOperands();
              // builder.setInsertionPointAfter(forOp);
              Value resultI32 = builder.create<arith::AddIOp>(builder.getUnknownLoc(), firstArg, 
                                builder.create<ConstantIntOp>(builder.getUnknownLoc(), -1, 32));
              Value resultIndex = builder.create<arith::IndexCastOp>(builder.getUnknownLoc(), builder.getIndexType(), resultI32);
              
              for(auto operand: yieldValues[0].getDefiningOp()->getOperands()){
                if(operand == firstArg){
                  resultIndex = builder.create<arith::IndexCastOp>(elseLoc,
                                            builder.getIndexType(), firstArg);
                }
              }
              memref::LoadOp output = builder.create<memref::LoadOp>(builder.getUnknownLoc(), inputMem, resultIndex);
              yieldValues[0].replaceAllUsesWith(output.getResult());
          }
        }
  
        Location forOpLoc = forOp.getRegion().getLoc();
        Value forIndex = forOp.getInductionVar();
        OpBuilder forOpBody(forOp.getRegion());
        //index -> i32
        Value forIndexI32 = forOpBody.create<arith::IndexCastOp>(forOpLoc, 
                                                  forOpBody.getIntegerType(32), forIndex);
        //Rewrite the code according to func.call
        llvm::SmallVector<Operation *> callVect;
        for (Operation &op : elseRegion.front()) {
          if (auto callOp = dyn_cast<mlir::func::CallOp>(&op)) {
              callVect.push_back(&op);
          }
        }
        auto positionOp = forIndexI32.getDefiningOp();
        llvm::SmallVector<Value > callVectLoad;
     
        for(auto &call: callVect){
          for (Value result : call->getOperands()) {
              //Replace the default argument in func.call with loop index. 
              result.getDefiningOp()->replaceUsesOfWith(firstArg, forIndexI32);
              //Move the related op from else to forop. 
              result.getDefiningOp()->moveAfter(positionOp);
              Value indexValue = forOpBody.create<arith::IndexCastOp>(forOpLoc,
                                            forOpBody.getIndexType(), result);
              //Load previously calculated values. 
              memref::LoadOp callLoad = forOpBody.create<memref::LoadOp>(forOpLoc, inputMem, indexValue);
              callVectLoad.push_back(callLoad.getResult());
              //Update the position of op to ensure sequential insertion.
              positionOp = callLoad;
          }
        }

        //Update the recursion.
        Operation *callCompute;
        for(auto &call: callVect){
            callCompute = call->getNextNode();
        }
 
        for(int i=0; i < callVect.size(); i++){
          for(Value calloutput: callVect[i]->getResults()){
              callCompute->replaceUsesOfWith(calloutput, callVectLoad[i]);
              callCompute->moveAfter(positionOp);
          }
          callVect[i]->erase();
        }
        forOp.walk([&](Operation *op) {
            op->replaceUsesOfWith(firstArg, forIndexI32);
        });
        // forOpBody.setInsertionPointAfter(callCompute);
        forOpBody.create<memref::StoreOp>(forOpBody.getUnknownLoc(), callCompute->getResult(0), inputMem, forIndex);    

    }//if (auto ifOp = dyn_cast<scf::IfOp>(op)) {
  }//for(auto &op : func.front()){
}


void derecursion(func::FuncOp func){

  Block &entryBlock = func.getBody().front();
  Value firstArg = entryBlock.getArgument(0);
  Type  firstType = firstArg.getType();

  //This part prepares to build the stack for user-defined variables.
  llvm::SmallVector<Operation*, 6> constantOps; 
  scf::IfOp ifoptemp;

  for(auto &op: func.front()){
    if (auto constantOp = dyn_cast<ConstantOp>(&op)) {
        constantOps.push_back(&op);
    }
    if (isa<IfOp>(&op)) {
      ifoptemp = dyn_cast<IfOp>(&op);
      break;
    }
  }
  

  OpBuilder builder(func.getBody());

  // Type elementType = IntegerType::get(context, 32, IntegerType::Signless);
  Location funcLoc = func.getLoc();
  //sp
  Value ValueSP = builder.create<ConstantIntOp>(funcLoc, 0, 32);//int sp = 0
  

  int64_t size = 512;
  MemRefType memRefType = MemRefType::get({size}, ValueSP.getType());
  
  //Creating stacks
  llvm::DenseMap <memref::AllocaOp, Value> stackToInputValue;
  llvm::SmallVector<memref::AllocaOp> stackInput;
  llvm::SmallVector<Value> inputValue;
  //Traverse all arguments and create a stack for each of them.
  for (Value operand : func.front().getArguments()) {
      Type inputType = operand.getType();
      MemRefType inputmemRefType = MemRefType::get({size}, inputType);
      memref::AllocaOp inputmemRef = builder.create<memref::AllocaOp>(funcLoc, inputmemRefType);
      stackToInputValue[inputmemRef] = operand;
      inputValue.push_back(operand);
      stackInput.push_back(inputmemRef);
  }

  //stack_state
  memref::AllocaOp stack_state = builder.create<memref::AllocaOp>(funcLoc, memRefType);


  //Initialize the stack and the required variables
  Value spIndex = builder.create<arith::IndexCastOp>(funcLoc, builder.getIndexType(), ValueSP);
  builder.create<memref::StoreOp>(funcLoc, ValueSP, stack_state, spIndex);

  for(auto stack: stackInput){
      Value stackIndex = builder.create<arith::IndexCastOp>(funcLoc, builder.getIndexType(), ValueSP);
      builder.create<memref::StoreOp>(funcLoc, stackToInputValue[stack], stack, stackIndex);
  }

  bool haveReturn = true;
  bool haveCarryValue = false;
  if(func.getResultTypes().empty()){
    haveReturn = false;
  }
  

  // Block::BlockArgListType FuncArguments = func.front().getArguments();

  //Analyse func.call and create the relevant storage.
  llvm::DenseMap <Operation*, bool> callTraversal;
  llvm::SmallVector<Operation *, 9> callVect;
  // llvm::SmallVector<Operation *, 6> callVect;
  std::string funcName{func.getSymName().data()};
  func.walk([&](func::CallOp call) {
    std::string calleeName{call.getCallee().data()};
    if (funcName == calleeName) {
      callVect.push_back(call);
      if(call.getOperation()->hasAttr("carry_value")){
        haveCarryValue=true;
        llvm::outs() << "have a carry " << "\n";
      }
      callTraversal[call] = false;
    }
  });
  llvm::DenseMap <Operation*, bool> callInIf;
  llvm::SmallVector<scf::IfOp>      callInIfwithop;
  llvm::DenseMap <Operation*, bool> callInWhile;
  ifoptemp.getElseRegion().walk([&](scf::IfOp op){
    op.walk([&](func::CallOp call) {
      for(auto callop: callVect){
        if(callInIf[callop])  continue;
        if(call == dyn_cast<func::CallOp>(callop)){
          if(call == ifoptemp || llvm::is_contained(callInIfwithop, op)) continue;
          callInIf[callop] = true;
          callInIfwithop.push_back(op);
        }
      }
    });
  });
  ifoptemp.getElseRegion().walk([&](scf::WhileOp  op){
    op.walk([&](func::CallOp call) {
      for(auto callop: callVect){
        if(callInWhile[callop])  continue;
        if(call == dyn_cast<func::CallOp>(callop))
          callInWhile[callop] = true;
      }
    });
  });


  //The number of case is the number of fuun.calls increased by 1.
  std::vector<int64_t> stateTemp; 
  int finish_max = 0;
  for(int i=0; i<callVect.size(); i++){
      int finish = callVect[i]->getAttr("state_finish").dyn_cast<IntegerAttr>().getInt();
      if(finish > finish_max) finish_max = finish;
  }
  for(int i=0; i <= finish_max; i++){
    stateTemp.push_back(i);
  }
  ArrayRef<int64_t> stateNumber(stateTemp);

  Value while1 = builder.create<ConstantIntOp>(funcLoc, 1,1);

  //Type
  SmallVector<Type, 3> resultTypes;
  resultTypes.push_back(ValueSP.getType());
  resultTypes.push_back(while1.getType());
  if(haveReturn){
      resultTypes.push_back(func.getResultTypes()[0]);
  }
  ArrayRef<Type> whileOpResultType(resultTypes);

  //Value
  SmallVector<Value, 3> resultTypesValue;
  resultTypesValue.push_back(ValueSP);
  resultTypesValue.push_back(while1);
  if(haveReturn){
      Value retval = builder.create<ConstantIntOp>(funcLoc, 0, func.getResultTypes()[0]);//int return = 0
      resultTypesValue.push_back(retval);
  }

  ValueRange whileOpResultValues(resultTypesValue);

  llvm::SmallDenseMap <Value, Value> inputValue2InputWhileValue;

  builder.setInsertionPointAfter(ifoptemp);
  scf::WhileOp whileOp = builder.create<scf::WhileOp>(funcLoc,
    whileOpResultType, whileOpResultValues, 
    [&](OpBuilder &b, Location loc, ValueRange args) {
      ImplicitLocOpBuilder builder(loc, b);
      builder.create<scf::ConditionOp>(args[1], args);
    },
    [&](OpBuilder &b, Location loc, ValueRange args) {
      ImplicitLocOpBuilder builder(loc, b);

    //sp = args[0];
    Value spIndex = builder.create<arith::IndexCastOp>(loc, builder.getIndexType(), args[0]);
    Value spNext = builder.create<arith::AddIOp>(loc, args[0], 
                                builder.create<ConstantIntOp>(loc, 1, 32));
    Value spIndexNext = builder.create<arith::IndexCastOp>(loc, builder.getIndexType(), spNext);
    Value state = builder.create<memref::LoadOp>(loc, stack_state, spIndex);
    Value stateIndex = builder.create<arith::IndexCastOp>(loc, builder.getIndexType(), state);

    //At the beginning of the whileop, all the values of the current level (sp) are loaded.
    for(auto stack: stackInput){
        Value inputInWhile = builder.create<memref::LoadOp>(loc, stack, spIndex);
        inputValue2InputWhileValue[stackToInputValue[stack]] = inputInWhile;
    }
    llvm::SmallDenseMap <Value, Value> carryValue2Load;

    if(haveCarryValue){
      //The carry value will be loaded. (sp++)
      for(int i=0; i < inputValue.size(); i++){
        if(callVect.front()->hasAttr("operand#" + std::to_string(i))){
          Value carryValue = builder.create<memref::LoadOp>(loc, stackInput[i], spIndexNext);
          carryValue2Load[callVect.front()->getOperands()[i]] = carryValue;
        }
      }
    }

    Operation * ifoptemp;
    Value conditionValue;
    for(auto &op : func.front()){
      if (auto ifOp = dyn_cast<scf::IfOp>(op)) {
          ifoptemp  = &op;
          conditionValue = ifOp.getCondition();
      }
    }
    scf::IndexSwitchOp StateSwitch = builder.create<scf::IndexSwitchOp>(loc,
            whileOpResultType, stateIndex, stateNumber, stateNumber.size());//whileOpResultType
    OpBuilder switchBuilder(StateSwitch);        
    Location swtichLoc = StateSwitch.getLoc();
      switchBuilder.createBlock(&StateSwitch.getDefaultRegion());
      // StateSwitch.getDefaultBlock().addArgument(ValueSP.getType(), funcLoc);
      switchBuilder.create<scf::YieldOp>(swtichLoc, args);
      //change case0
      for(auto &outerop: func.front()){
        if(auto ifOp = dyn_cast<scf::IfOp>(outerop)){
          Region &thenRegion = ifOp.getThenRegion();
          for (Operation &op : thenRegion.front()) {
            if(auto yieldOp = dyn_cast<scf::YieldOp>(&op)) {
                //This part implements the state analysis and 
                //the return of parameters for the if branch (source code) in case0.
                /* 
                  Those ops are created in thenregion.
                  retval=n+1;(if have)
                  if(sp==0){
                      break;
                  }else{
                      sp--;
                  }
                */
                OpBuilder builder(&thenRegion.front().front());
                Location ifLoc = thenRegion.getLoc(); 
                builder.setInsertionPoint(thenRegion.front().getTerminator());
                Value cmpiEq = builder.create<arith::CmpIOp>(ifLoc, 
                    arith::CmpIPredicate::eq, args[0], ValueSP);//sp==0
                Value cmpiNe = builder.create<arith::CmpIOp>(ifLoc, 
                    arith::CmpIPredicate::ne, args[0], ValueSP);//sp！=0
                Value spIf = args[0];
                spIf = builder.create<scf::IfOp>(ifLoc, cmpiEq,
                [&](OpBuilder &b, Location loc){
                    b.create<scf::YieldOp>(loc, ValueRange{spIf});//arg
                },
                [&](OpBuilder &b, Location loc){
                    Value caseIfElseBodyYield = b.create<arith::AddIOp>(loc, args[0], 
                                b.create<ConstantIntOp>(loc, -1, 32));
                    b.create<scf::YieldOp>(loc, ValueRange{caseIfElseBodyYield});
                }).getResult(0);
                //TODO: Handle custom variables better, deal with carrying variables into loops.

                SmallVector<Value> yieldVec; yieldVec.push_back(spIf); yieldVec.push_back(cmpiNe);

                if(haveReturn){
                  // Value yieldOpValue = op.getOperand(0);
                  yieldVec.push_back(args[2]);
                }
                op.setOperands(ValueRange{yieldVec});
            }
          }
 
        //begin 

        Region &elseRegion = ifOp.getElseRegion();
        Operation *callTempOp;
        int64_t state_base_num = 0;

        Value caseSpNext;
        for(auto &callFunc: callVect){
          auto stateBaseAttr = callFunc->getAttr("state_base");
          auto stateBaseInt = stateBaseAttr.dyn_cast<IntegerAttr>();
          auto state_base = stateBaseInt.getInt();
          if(!state_base){
              state_base_num++;
              callTempOp = callFunc;
              Block *currBlock = callFunc->getBlock();
              OpBuilder callBlockBuilder = OpBuilder(&currBlock->front());
              Location callBlockLoc = currBlock->front().getLoc();

              auto stateFinishAttr = callFunc->getAttr("state_finish");
              auto stateFinishInt = stateFinishAttr.dyn_cast<IntegerAttr>();
              auto state_finish = stateFinishInt.getInt();
              //sp state
              Value callSp = callBlockBuilder.create<ConstantIntOp>(callBlockLoc, state_finish, 32);//get sp state

              Value  callSpIndex = callBlockBuilder.create<arith::IndexCastOp>(callBlockLoc, builder.getIndexType(), args[0]);
              callBlockBuilder.create<memref::StoreOp>(callBlockLoc, callSp, stack_state, callSpIndex);

              caseSpNext = callBlockBuilder.create<arith::AddIOp>(callBlockLoc, args[0], //sp++
                  callBlockBuilder.create<ConstantIntOp>(callBlockLoc, 1, 32));

              Value  callSpNextIndex = callBlockBuilder.create<arith::IndexCastOp>(callBlockLoc, builder.getIndexType(), caseSpNext);
              Value callSpValue0 = callBlockBuilder.create<ConstantIntOp>(callBlockLoc, 0, 32);
              callBlockBuilder.create<memref::StoreOp>(callBlockLoc, callSpValue0, stack_state, callSpNextIndex);
              callBlockBuilder.setInsertionPoint(callFunc);
              int64_t operandNum = callFunc->getNumOperands();

              for(int64_t i=0; i < operandNum; i++){   
                callBlockBuilder.create<memref::StoreOp>(callBlockLoc, callFunc->getOperand(i), stackInput[i], callSpNextIndex);
              }
              if(auto op = currBlock->getTerminator())
                op->setOperands(ValueRange{spNext});//return sp++
          }
        }
        {
          SmallVector<Value> yieldVec;
          // Value caseSpNext;
          if(haveReturn){
            if(state_base_num > 1){   
              caseSpNext = callTempOp->getBlock()->getParentOp()->getResult(0);
              //callTempOp->getBlock()->getParent()->getParentOp();

              yieldVec.push_back(caseSpNext); yieldVec.push_back(while1); yieldVec.push_back(args[2]);
              // elseRegion.front().getTerminator()->setOperands(ValueRange{caseSpNext, while1, args[2]});
            }
            else{
              yieldVec.push_back(caseSpNext); yieldVec.push_back(while1); yieldVec.push_back(args[2]);
              // elseRegion.front().getTerminator()->setOperands(ValueRange{caseSpNext, while1, args[2]});
            }
          }
          else{
            yieldVec.push_back(caseSpNext); yieldVec.push_back(while1); 
              //elseRegion.front().getTerminator()->setOperands(ValueRange{caseSpNext, while1});//结尾返回值
          }
          
          elseRegion.front().getTerminator()->setOperands(ValueRange{yieldVec});
        }
          // Value yieldOpValue = op.getOperand(0);
          // SmallVector<Value> yieldVec1; //yieldVec.push_back(spIf); yieldVec.push_back(cmpiNe);
          // if(haveReturn){
          //   if(state_base_num > 1){   
          //     caseSpNext = callTempOp->getBlock()->getParentOp()->getResult(0);
          //     //callTempOp->getBlock()->getParent()->getParentOp();

          //     yieldVec1.push_back(caseSpNext); yieldVec1.push_back(while1); yieldVec1.push_back(args[2]);
          //     // elseRegion.front().getTerminator()->setOperands(ValueRange{caseSpNext, while1, args[2]});
          //   }
          //   else{
          //     yieldVec1.push_back(caseSpNext); yieldVec1.push_back(while1); yieldVec1.push_back(args[2]);
          //     // elseRegion.front().getTerminator()->setOperands(ValueRange{caseSpNext, while1, args[2]});
          //   }
          // }
          // else{
          //   yieldVec1.push_back(caseSpNext); yieldVec1.push_back(while1); 
          //     //elseRegion.front().getTerminator()->setOperands(ValueRange{caseSpNext, while1});//结尾返回值
          // }


          // // if(haveReturn) yieldVec.push_back(yieldOpValue);
          // if(haveCarryValue) yieldVec1.push_back(args[yieldVec1.size()-1]);
          // elseRegion.front().getTerminator()->setOperands(ValueRange{yieldVec1});
    

        // if(haveReturn){
        //   if(state_base_num > 1){   
        //     caseSpNext = callTempOp->getBlock()->getParentOp()->getResult(0);
        //     //callTempOp->getBlock()->getParent()->getParentOp();
        //     elseRegion.front().getTerminator()->setOperands(ValueRange{caseSpNext, while1, args[2]});
        //   }
        //   else{
        //     elseRegion.front().getTerminator()->setOperands(ValueRange{caseSpNext, while1, args[2]});
        //   }
        // }
        // else{
        //     elseRegion.front().getTerminator()->setOperands(ValueRange{caseSpNext, while1});//结尾返回值
        // }
      }
    }//change case0

    //Rewrite ifOp and then port to case0.
    switchBuilder.createBlock(&StateSwitch.getCaseRegions()[0]);
    OpBuilder caseBuilder = OpBuilder(StateSwitch.getCaseRegions()[0]);
    Location caseLoc = StateSwitch.getCaseRegions()[0].getLoc();
    auto caseIfOp = caseBuilder.create<scf::IfOp>(caseLoc, whileOpResultType, conditionValue);
    conditionValue.getDefiningOp()->moveBefore(StateSwitch);//move cond before ifOp, after state_stack.
    caseIfOp.getThenRegion().takeBody(dyn_cast<scf::IfOp>(ifoptemp).getThenRegion());
    caseIfOp.getElseRegion().takeBody(dyn_cast<scf::IfOp>(ifoptemp).getElseRegion());


    //Rewrite ifOp that contains recursion (in the outer if-else region).
    // if(callInIf.size() > 0){
    //   for(auto ifop: callInIfwithop){
    //       caseBuilder.setInsertionPoint(ifop);
    //       auto recursionIfOp = caseBuilder.create<scf::IfOp>(caseLoc, whileOpResultType, ifop.getCondition());
    //       recursionIfOp.getThenRegion().takeBody(ifop.getThenRegion());
    //       recursionIfOp.getElseRegion().takeBody(ifop.getElseRegion());

    //       SmallVector<Value> yieldVec;
    //       // Value caseSpNext;
    //       Value caseSpNext = caseBuilder.create<arith::AddIOp>(caseLoc, args[0], //sp++
    //               caseBuilder.create<ConstantIntOp>(caseLoc, 1, 32));
    //       if(haveReturn){
    //           yieldVec.push_back(caseSpNext); yieldVec.push_back(while1); yieldVec.push_back(args[2]);
    //       }
    //       else{
    //         yieldVec.push_back(caseSpNext); yieldVec.push_back(while1); 
    //       }
          
    //       recursionIfOp.getThenRegion().front().getTerminator()->setOperands(ValueRange{yieldVec});
    //       recursionIfOp.getElseRegion().front().getTerminator()->setOperands(ValueRange{yieldVec});
          
    //   }
    // }


    //Update the input arguments value
    // StateSwitch.getCaseBlock(0).walk([&](Operation *op) {
    
    switchBuilder.create<scf::YieldOp>(swtichLoc,caseIfOp.getResults());

    //Assign cases according to func.call
    llvm::DenseMap <int64_t, llvm::SmallVector<Operation *>> case2call;
    for(auto &callFunc: callVect){
      auto stateBaseAttr = callFunc->getAttr("state_base");
      auto stateBaseInt = stateBaseAttr.dyn_cast<IntegerAttr>();
      auto state_base = stateBaseInt.getInt();

      auto stateFinishAttr = callFunc->getAttr("state_finish");
      auto stateFinishInt = stateFinishAttr.dyn_cast<IntegerAttr>();
      auto state_finish = stateFinishInt.getInt();
      if(state_base == 0){
        case2call[state_finish].push_back(callFunc);
      }
      else{
        case2call[state_base].push_back(callFunc);
        case2call[state_finish].push_back(callFunc);
      }
    }

        
    for(int i=1; i < stateNumber.size(); i++){
      switchBuilder.createBlock(&StateSwitch.getCaseRegions()[i]);
      OpBuilder otherCaseBuilder = OpBuilder(StateSwitch.getCaseRegions()[i]);
      Location otherCaseLoc = StateSwitch.getCaseRegions()[i].getLoc();
      if(case2call[i].size() ==1){
          auto cmpiEq = otherCaseBuilder.create<arith::CmpIOp>(otherCaseLoc, 
            arith::CmpIPredicate::eq, args[0], ValueSP);//sp==0
          auto cmpiNe = otherCaseBuilder.create<arith::CmpIOp>(otherCaseLoc, 
            arith::CmpIPredicate::ne, args[0], ValueSP);//sp！=0
          Value spIf = args[0];
          spIf = otherCaseBuilder.create<scf::IfOp>(otherCaseLoc, cmpiEq,
            [&](OpBuilder &b, Location loc){
                b.create<scf::YieldOp>(loc, ValueRange{spIf});//arg
            },
            [&](OpBuilder &b, Location loc){
                Value caseIfElseBodyYield = b.create<arith::AddIOp>(loc, args[0], 
                            b.create<ConstantIntOp>(loc, -1, 32));
                b.create<scf::YieldOp>(loc, ValueRange{caseIfElseBodyYield});
          }).getResult(0);
        
          SmallVector<Value> yieldVec;
          if(haveReturn){
            yieldVec.push_back(spIf);yieldVec.push_back(cmpiNe);yieldVec.push_back(args[2]);
            // switchBuilder.create<scf::YieldOp>(swtichLoc,ValueRange(
            //                     {spIf,cmpiNe,args[2]}));
          }
          else{
            yieldVec.push_back(spIf);yieldVec.push_back(cmpiNe);
            // switchBuilder.create<scf::YieldOp>(swtichLoc,ValueRange(
            //                     {spIf,cmpiNe}));
          }

          switchBuilder.create<scf::YieldOp>(swtichLoc,ValueRange{yieldVec});
          // if(haveReturn){
          //   switchBuilder.create<scf::YieldOp>(swtichLoc,ValueRange(
          //                       {spIf,cmpiNe,args[2]}));
          // }
          // else{
          //   switchBuilder.create<scf::YieldOp>(swtichLoc,ValueRange(
          //                       {spIf,cmpiNe}));
          // }

          auto &casePosOp = StateSwitch.getCaseRegions()[i].front().front();
          bool findReady = false;

         
          // for(auto &moveOp: case2call[i].front()->getBlock()->getOperations()){
  
          //   if(findReady){
          //     llvm::outs() << "Operation: " << moveOp.getName().getStringRef() << "\n";
          //     if(dyn_cast<scf::YieldOp>(moveOp)) return WalkResult::interrupt();
          //     moveOp.moveBefore(&casePosOp);
          //   }
          //   if(&moveOp == case2call[i].front()) findReady = true;
          // }  

          // for (auto iter = case2call[i].front()->getBlock()->rbegin();
          //     iter != case2call[i].front()->getBlock()->rend(); iter++) {
                // (*iter).dump();
            // changed = true;
            // toErase.push_back(&*iter);
          // }

          // for(auto &op: case2call[i].front()->getBlock()->getOperations()){
          //   llvm::outs() << "alll : " << op.getName().getStringRef() << " " << findReady << "\n";
          //   if(findReady){
          //     llvm::outs() << "Operation: " << op.getName().getStringRef() << "\n";
          //     if(dyn_cast<scf::YieldOp>(op)) break;
          //     op.moveBefore(&casePosOp);
          //   }
          //   if(&op == case2call[i].front()){ findReady = true;}

          // }
          // llvm::outs() << "qqq: " <<  case2call[i].front()->getParentOp()->getName().getStringRef() << "\n";
       
          case2call[i].front()->getBlock()->walk([&] (Operation *op) { 
            if(findReady && (case2call[i].front()->getParentOp() == op->getParentOp())){
              if(dyn_cast<scf::YieldOp>(op)){
                 return WalkResult::interrupt();
              }
              op->moveBefore(&casePosOp);
            }
            if(op == case2call[i].front()) findReady = true;
          });
      }
      else{
        int64_t operandNum = case2call[i].back()->getNumOperands();
        Value  callSpIndex = otherCaseBuilder.create<arith::IndexCastOp>(otherCaseLoc, builder.getIndexType(), args[0]);
        //There is a data dependency with the previous func.call
        if(haveReturn){
          for(int64_t j=0; j < operandNum; j++){
            if(case2call[i].back()->getOperand(j) == case2call[i].front()->getResult(0)){
              auto otherCaseStoreOp = otherCaseBuilder.create<memref::StoreOp>(otherCaseLoc, case2call[i].back()->getOperand(j), stackInput[j], callSpIndex);
              otherCaseStoreOp->replaceUsesOfWith(case2call[i].front()->getResult(0), args[2]);

              // case2call[i].front()->replaceAllUsesWith(ValueRange{args[2]});
            } 
          }
        }
        auto stateFinishAttr = case2call[i].back()->getAttr("state_finish");
        auto stateFinishInt = stateFinishAttr.dyn_cast<IntegerAttr>();
        auto state_finish = stateFinishInt.getInt();
        
        //sp state
        Value callSp = otherCaseBuilder.create<ConstantIntOp>(otherCaseLoc, state_finish, 32);//get sp state

        
        otherCaseBuilder.create<memref::StoreOp>(otherCaseLoc, callSp, stack_state, callSpIndex);

        // Value caseSpNext = otherCaseBuilder.create<arith::AddIOp>(otherCaseLoc, args[0], //sp++
        //     otherCaseBuilder.create<ConstantIntOp>(otherCaseLoc, 1, 32));

        // Value  callSpNextIndex = otherCaseBuilder.create<arith::IndexCastOp>(otherCaseLoc, builder.getIndexType(), caseSpNext);
        Value callSpValue0 = otherCaseBuilder.create<ConstantIntOp>(otherCaseLoc, 0, 32);
        otherCaseBuilder.create<memref::StoreOp>(otherCaseLoc, callSpValue0, stack_state, spIndexNext);

        auto &casePosOp = StateSwitch.getCaseRegions()[i].front().front();
        
        // for(Value operand: case2call[i].back()->getOperands()){
        //   if(!dyn_cast<func::CallOp>(operand.getDefiningOp()))
        //     operand.getDefiningOp()->moveBefore(&casePosOp);
        // }
        if(case2call[i].size()==2){
          bool findReady = false;
          case2call[i].front()->getBlock()->walk([&] (Operation *op) { 
            if(findReady){
              if(dyn_cast<func::CallOp>(op) && llvm::is_contained(callVect, op)) return WalkResult::interrupt();
              op->moveBefore(&casePosOp);
            }
            if(op == case2call[i].front()) findReady = true;
          });
        }
      

        for(int64_t j=0; j < operandNum; j++){   
          auto otherCaseStoreOp = otherCaseBuilder.create<memref::StoreOp>(otherCaseLoc, case2call[i].back()->getOperand(j), stackInput[j], spIndexNext);
          if(case2call[i].back()->getOperand(j) == case2call[i].front()->getResult(0)){
            otherCaseStoreOp->replaceUsesOfWith(case2call[i].front()->getResult(0), args[2]);
          }
        }

        // assert(case2call[i].front()->getNumOperands() == case2call[i].back()->getNumOperands());
        // for(int j=0; j < case2call[i].front()->getNumOperands(); j++){
        //   int pos = -1;
        //   if(case2call[i].front()->hasAttr("carry_value")){
        //     pos = case2call[i].front()->getAttr("carry_value").dyn_cast<IntegerAttr>().getInt();
        //   }
        //   if(case2call[i].front()->getOperand(j) == case2call[i].back()->getOperand(j) &&
        //      !llvm::is_contained(inputValue, case2call[i].front()->getOperand(j)) && (pos != j) ){

        //     Operation *originalOp = case2call[i].front()->getOperand(j).getDefiningOp();
        //     Operation *cloneOp = case2call[i].front()->getOperand(j).getDefiningOp()->clone();
        //     StateSwitch.getCaseRegions()[i].front().push_front(cloneOp);
            
        //     // cloneOp->moveAfter(&StateSwitch.getCaseRegions()[i].front().front());
        // //     // auto builder = OpBuilder(&casePosOp);
        // //     // otherCaseBuilder.setInsertionPoint(&casePosOp);
        //     // otherCaseBuilder.insert(cloneOp);break;
        //     StateSwitch.getCaseRegions()[i].front().walk([&](Operation *op){
        //       op->replaceUsesOfWith(originalOp->getResult(0), cloneOp->getResult(0));
        //     });
        //   }
        // }

        SmallVector<Value, 3> yieldVec;
        yieldVec.push_back(spNext);yieldVec.push_back(while1);
          if(haveReturn){
            yieldVec.push_back(args[2]);
            // switchBuilder.create<scf::YieldOp>(swtichLoc,ValueRange(
            //                     {spIf,cmpiNe,args[2]}));
          }
          // else{
          //   yieldVec.push_back(spNext);yieldVec.push_back(while1);
          //   // switchBuilder.create<scf::YieldOp>(swtichLoc,ValueRange(
          //   //                     {spIf,cmpiNe}));
          // }
          // if(haveCarryValue) yieldVec.push_back(args[yieldVec.size()]);
          switchBuilder.create<scf::YieldOp>(swtichLoc,ValueRange{yieldVec});

        // if(haveReturn){
        //   switchBuilder.create<scf::YieldOp>(swtichLoc,ValueRange(
        //                         {caseSpNext,while1,args[2]}));
        // }
        // else{
        //   switchBuilder.create<scf::YieldOp>(swtichLoc,ValueRange(
        //                         {caseSpNext,while1}));
        // }
      }

      StateSwitch.getCaseRegions()[i].front().walk([&] (Operation *op) {
        for(auto &value: carryValue2Load){
              op->replaceUsesOfWith(value.first, value.second);
        }
      });

    }    

    builder.create<YieldOp>(loc, StateSwitch.getResults());

    
  });//whileOp.builder

  if(haveReturn){
      entryBlock.back().setOperands(whileOp.getResult(2));
  }
  func.walk([&](Operation *op) {
    if(auto indexcast = dyn_cast<arith::IndexCastOp>(op)){
        for(auto operand: op->getOperands()){
          if(llvm::is_contained(inputValue, operand))
            op->moveAfter(inputValue2InputWhileValue[operand].getDefiningOp());
        }
    }
    if(auto memStore = dyn_cast<memref::StoreOp>(op)){
      if(llvm::is_contained(inputValue, op->getOperand(0))){
          Operation *posOp = (*op).clone();
          if(!llvm::is_contained(stackInput, op->getOperand(1).getDefiningOp()))
            op->moveAfter(inputValue2InputWhileValue[op->getOperand(0)].getDefiningOp());
      }
    }
  });
  //Update the input arguments value
  whileOp.walk([&](Operation *op) {
    for(auto &value: inputValue2InputWhileValue){
        op->replaceUsesOfWith(value.first, value.second);
    }
  });


  llvm::outs() << "callInIfwithop.size() " <<callInIfwithop.size()<< "\n";
  // if(callInIfwithop.size() > 0){
  //   for(auto ifop: callInIfwithop){
  //     ifop.getOperation()->erase();
  //   }
  // }
  for(auto &op : func.front()){
      if (auto ifOp = dyn_cast<scf::IfOp>(op)) {
          op.erase();
          break;
      }
  }
  if(callInIfwithop.size() > 0){
    
    // for(auto ifop: callInIfwithop){
    //   ifop.getOperation()->erase();
    // }
    // for(int64_t i=callInIfwithop.size(); i > 0; i--){
    //   callInIfwithop[i-1].getOperation()->erase();
    // }
  }

  func.dump();

  for(int64_t i=callVect.size(); i > 0; i--){
    callVect[i-1]->erase();
  }
  
  
}


void OptimizeRecursionPass::runOnOperation() {
  
  std::string topFunc;

  func::FuncOp func = getOperation(); //get funcOp
  std::string funcName{func.getSymName().data()};
  func.walk([&](func::CallOp call) {
    std::string calleeName{call.getCallee().data()};
    if (funcName == calleeName) {
      if(call.getOperation()->hasAttr("state_base")){
        topFunc = funcName;
      }
    }
  });
  if(topFunc == funcName)
    derecursion(func);

}

std::unique_ptr<Pass> hls::createOptimizeTailRecursionPass() {
  return std::make_unique<OptimizeTailRecursionPass>();
}
std::unique_ptr<Pass> hls::createOptimizeRecursionPass() {
  return std::make_unique<OptimizeRecursionPass>();
}

