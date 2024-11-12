#include "mlir/IR/BuiltinOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/SymbolTable.h"

#include "hls/Transforms/Passes.h"
#include <stack>

#include "llvm/ADT/STLExtras.h" 
using namespace mlir;

//op in func, other no call
namespace {
bool isRecursiveCall(Operation *op, Operation *func) {
  auto callOp = dyn_cast<func::CallOp>(op);
  if (!callOp) return false;
  auto sym = callOp.getCallableForCallee().dyn_cast<SymbolRefAttr>();
  if (!sym) return false;
  return SymbolTable::lookupNearestSymbolFrom(callOp, sym) == func;
}

struct MarkRecursivePass
    : public PassWrapper<MarkRecursivePass, OperationPass<func::FuncOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(MarkRecursivePass)

  StringRef getArgument() const final { return "mark-recursive"; }
  StringRef getDescription() const final { return "Mark recursive functions."; }

  struct StateInfo {
    Operation *op;
    int baseState;
    int preStates = 0, postStates = 0;
    int regionStates[2] = {0, 0};

    StateInfo(Operation *_op, int base): op{_op}, baseState{base} {
      if (isa<scf::ForOp, scf::WhileOp>(op))
        preStates = postStates = 1;
      else if (auto ifOp = dyn_cast<scf::IfOp>(op); ifOp && !ifOp.getElseRegion().empty())
        postStates = 1;
    }

    int totalStates()
    { return preStates + postStates + regionStates[0] + regionStates[1]; }

    int currentState(int region) {
      assert(region >= 0 && region < 2);
      int s = baseState + preStates;
      if (regionStates[region] == 0) return s;
      for (int i = 0; i <= region; ++i)
        s += regionStates[i];
      return s;
    }
  };

  void runOnOperation() override {
    Operation *outerFunc = getOperation();
    std::stack<StateInfo> stateStack;
    stateStack.emplace(outerFunc, 0);
    llvm::SmallVector<Operation *> callVect;
    std::function<std::pair<int,int>(Operation*)> getState = [&](Operation* op) {
      auto parentOp = op->getParentOp();
      auto region = op->getParentRegion()->getRegionNumber();
      if (stateStack.top().op != parentOp)
        getState(parentOp);
      auto& top = stateStack.top();
      assert(top.op == parentOp);
      auto state = top.currentState(region);
      if (isa<func::CallOp>(op)) {
        ++top.regionStates[region];
        return std::pair{state, top.currentState(region)};
      }
      assert((isa<scf::IfOp, scf::ForOp, scf::WhileOp>(op)));
      stateStack.emplace(op, state);
      return std::pair{0, 0};
    };
    
    outerFunc->walk([&](Operation *op, const WalkStage &stage) {
      OpBuilder b(op);
      if (isRecursiveCall(op, outerFunc)) {
        auto state = getState(op);
        op->setAttr("state_base", b.getI32IntegerAttr(state.first));
        op->setAttr("state_finish", b.getI32IntegerAttr(state.second));
        callVect.push_back(op);
      }
      else if (auto& top = stateStack.top(); top.op == op) {
        if (stage.isBeforeAllRegions()) {
          assert(op == outerFunc);
          return WalkResult::advance();
        }
        auto region = stage.getNextRegion() - 1;
        assert(region >= 0 && region < 2);
        if (stage.isAfterAllRegions()) {
          auto totalStates = top.totalStates();
          if (totalStates == 0) {
            assert(op == outerFunc);
            return WalkResult::advance();
          }
          op->setAttr("state_base", b.getI32IntegerAttr(top.baseState));
          op->setAttr("state_finish", b.getI32IntegerAttr(top.baseState + totalStates));
          stateStack.pop();
          if (!stateStack.empty()) {
            auto& top = stateStack.top();
            assert(top.op == op->getParentOp());
            auto region = op->getParentRegion()->getRegionNumber();
            top.regionStates[region] += totalStates;
          }
        }
        op->setAttr("state_region" + std::to_string(region),
                    b.getI32IntegerAttr(top.regionStates[region]));
      }
      return WalkResult::advance();
    });

    //find custom-value
    auto func = dyn_cast<func::FuncOp>(outerFunc);
    llvm::SmallVector<Value> arguments;
    for (Value operand : func.front().getArguments()) {
      arguments.push_back(operand);
    }
    llvm::DenseMap <int, Value> pos2value;
    int number = 0;
    for(int i=0; i < callVect.size(); i++){
      Operation *currOp = callVect[i];
      if(auto next=i+1; next < callVect.size()){
        OpBuilder b(callVect[i]);
        int pos = -1;
        Value carryValue;
        Operation *nextOp = callVect[next];
        if(currOp->getBlock()==nextOp->getBlock() && currOp->isBeforeInBlock(nextOp)){
          for(int j=0; j < currOp->getNumOperands(); j++){
            Value operandCall =  currOp->getOperand(j);
            if(!llvm::is_contained(arguments, operandCall) && operandCall.getType().isa<IntegerType>()){
              pos2value[j] = operandCall;
            }
          }
        }
        if(pos2value.size() > 0){
          int level = arguments.size();
          std::stack<Operation *> opStack;
          opStack.emplace(nextOp);
          for(int i=0; i < level+level && !opStack.empty(); i++){
            auto findOp = opStack.top(); opStack.pop();
            for(auto [index, operand] : llvm::enumerate(findOp->getOperands())){
              for(auto &element: pos2value){
                if((operand == element.second) && findOp != currOp && index == element.first){// &&currOp->getOperand(pos) != nextOp->getOperand(pos)
                  currOp->setAttr("operand#" + std::to_string(index), b.getI32IntegerAttr(index));
                  number += 1;
                }
              }
              if(operand.getDefiningOp() != nullptr)
              opStack.emplace(operand.getDefiningOp());
            }
          }
        }
        if(number != 0)
          currOp->setAttr("carry_value", b.getI32IntegerAttr(number));
      }
    }//for(int i=0; i < callVect.size(); i++){

    
    for(int i=0; i < callVect.size(); i++){ 
      callVect[i]->getBlock()->walk([&](Operation *op) { 
        if(op == callVect[i]) 
          return WalkResult::interrupt();
        auto operands = SmallVector<Value, 4>(callVect[i]->getOperands().begin(),
                                      callVect[i]->getOperands().end());  
        if(!llvm::is_contained(operands, op->getResult(0))){
          op->moveAfter(callVect[i]);
        }                    
      });

    }
  }
};

} // namespace


std::unique_ptr<Pass> hls::createMarkRecursivePass() {
  return std::make_unique<MarkRecursivePass>();
}
