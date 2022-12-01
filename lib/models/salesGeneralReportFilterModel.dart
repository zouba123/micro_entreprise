// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/accountModel.dart';

class SalesGeneralReportFilterModel {
  // int saleInvoiceId;
  Account account;
  DateTime invoiceDateFrom;
  DateTime invoiceDateTo;
  DateTime deliveryDateFrom;
  DateTime deliveryDateTo;
  double netAmountFrom;
  double netAmountTo;
  String invoiceStatus;
  double taxAmountFrom;
  double taxAmountTo;
  double discountAmountFrom;
  double discountAmountTo;
  double paymentDoneAmountFrom;
  double paymentDoneAmountTo;
  double paymentPendingAmountFrom;
  double paymentPendingAmountTo;

  SalesGeneralReportFilterModel();

  SalesGeneralReportFilterModel copyFrom(SalesGeneralReportFilterModel _obj) {
    SalesGeneralReportFilterModel _newObj = SalesGeneralReportFilterModel();

    _newObj.account = _obj.account;
    _newObj.invoiceDateFrom = _obj.invoiceDateFrom;
    _newObj.invoiceDateTo = _obj.invoiceDateTo;
    _newObj.deliveryDateFrom = _obj.deliveryDateFrom;
    _newObj.deliveryDateTo = _obj.deliveryDateTo;
    _newObj.netAmountFrom = _obj.netAmountFrom;
    _newObj.netAmountTo = _obj.netAmountTo;
    _newObj.invoiceStatus = _obj.invoiceStatus;
    _newObj.taxAmountFrom = _obj.taxAmountFrom;
    _newObj.taxAmountTo = _obj.taxAmountTo;
    _newObj.discountAmountFrom = _obj.discountAmountFrom;
    _newObj.discountAmountTo = _obj.discountAmountTo;
    _newObj.paymentDoneAmountFrom = _obj.paymentDoneAmountFrom;
    _newObj.paymentDoneAmountTo = _obj.paymentDoneAmountTo;
    _newObj.paymentPendingAmountFrom = _obj.paymentPendingAmountFrom;
    _newObj.paymentPendingAmountTo = _obj.paymentPendingAmountTo;

    return _newObj;
  }
}
