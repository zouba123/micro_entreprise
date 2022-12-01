// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/accountModel.dart';

class PaymentGeneralReportFilterModel {
  // SaleInvoice invoice;
  Account account;
  String paymentType;
  // Expense expense;
  DateTime dateFrom;
  DateTime dateTo;
  double amountFrom;
  double amountTo;
  bool isCancel = false;

  PaymentGeneralReportFilterModel();

  PaymentGeneralReportFilterModel copyFrom(PaymentGeneralReportFilterModel _obj) {
    PaymentGeneralReportFilterModel _newObj = PaymentGeneralReportFilterModel();
    // _newObj.invoice = _obj.invoice;
    _newObj.account = _obj.account;
    _newObj.paymentType = _obj.paymentType;
    // _newObj.expense = _obj.expense;
    _newObj.dateFrom = _obj.dateFrom;
    _newObj.dateTo = _obj.dateTo;
    _newObj.amountFrom = _obj.amountFrom;
    _newObj.amountTo = _obj.amountTo;
    _newObj.isCancel = _obj.isCancel;
    return _newObj;
  }
}
