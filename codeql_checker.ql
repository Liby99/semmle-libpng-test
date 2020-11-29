import cpp
import semmle.code.cpp.dataflow.DataFlow

class DestroyWriteCall extends FunctionCall {
  DestroyWriteCall() {
    this.getTarget().getName() = "png_destroy_write_struct"
  }
}

class CreateInfoCall extends FunctionCall {
  CreateInfoCall() {
    this.getTarget().getName() = "png_create_info_struct"
  }
}

predicate zeroComparison(EqualityOperation e, Variable v) {
  exists (Expr zero |
    zero.getValue() = "0" |
    (zero = e.getLeftOperand() and
      v = e.getRightOperand().(VariableAccess).getTarget()) or
    (zero = e.getRightOperand() and
      v = e.getLeftOperand().(VariableAccess).getTarget()))
}

from
  EqualityOperation e,
  Variable info_ptr,
  IfStmt control,
  DestroyWriteCall destroy_write_call
where
  zeroComparison(e, info_ptr) and
  exists (AssignExpr assign |
    assign.getLValue().(VariableAccess).getTarget() = info_ptr |
    exists (CreateInfoCall info_call |
      assign.getRValue() = info_call)) and
  control.getControllingExpr() = e and
  destroy_write_call.getArgument(1).getValue() = "0" and
  not control.getThen().getBasicBlock().contains(destroy_write_call.getBasicBlock())
select e, control, destroy_write_call
