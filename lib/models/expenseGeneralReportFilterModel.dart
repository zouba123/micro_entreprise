// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators
import 'package:accounting_app/models/expenseCategoryModel.dart';

class ExpenseGeneralReportFilterModel {
  double amountFrom;
  double amountTo;
  ExpenseCategory category;
  DateTime transactionDateFrom;
  DateTime transactionDateTo;
  double paidAmountFrom;
  double paidAmountTo;
  double pendingAmountFrom;
  double pendingAmountTo;

  ExpenseGeneralReportFilterModel();

  ExpenseGeneralReportFilterModel copyFrom(ExpenseGeneralReportFilterModel _obj) {
    ExpenseGeneralReportFilterModel _newObj = ExpenseGeneralReportFilterModel();
    _newObj.amountFrom = _obj.amountFrom;
    _newObj.amountTo = _obj.amountTo;
    _newObj.category = _obj.category;
    _newObj.transactionDateFrom = _obj.transactionDateFrom;
    _newObj.transactionDateTo = _obj.transactionDateTo;
    _newObj.paidAmountFrom = _obj.paidAmountFrom;
    _newObj.paidAmountTo = _obj.paidAmountTo;
    _newObj.pendingAmountFrom = _obj.pendingAmountFrom;
    _newObj.pendingAmountTo = _obj.pendingAmountTo;
    return _newObj;
  }
}
