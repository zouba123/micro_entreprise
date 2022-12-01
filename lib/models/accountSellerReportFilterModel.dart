// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators
class AccountSellerReportFilterModel {
  // int saleInvoiceId;
  DateTime firstOrderDateFrom;
  DateTime firstOrderDateTo;
  DateTime lastOrderDateFrom;
  DateTime lastOrderDateTo;
  double firstOrderAmountFrom;
  double firstOrderAmountTo;
  double lastOrderAmountFrom;
  double lastOrderAmountTo;
  double minOrderAmountFrom;
  double minOrderAmountTo;
  double maxOrderAmountFrom;
  double maxOrderAmountTo;
  double avgOrderAmountFrom;
  double avgOrderAmountTo;
  double totalSpendFrom;
  double totalSpendTo;
  double totalPaidFrom;
  double totalPaidTo;
  double totalPendingFrom;
  double totalPendingTo;
  int totalOrderFrom;
  int totalOrderTo;
  DateTime accountRegistrationFrom;
  DateTime accountRegistrationTo;
  String pincode;

  AccountSellerReportFilterModel();

  AccountSellerReportFilterModel copyFrom(AccountSellerReportFilterModel _obj) {
    AccountSellerReportFilterModel _newObj = AccountSellerReportFilterModel();
    _newObj.firstOrderDateFrom = _obj.firstOrderDateFrom;
    _newObj.firstOrderDateTo = _obj.firstOrderDateTo;
    _newObj.lastOrderDateFrom = _obj.lastOrderDateFrom;
    _newObj.lastOrderDateTo = _obj.lastOrderDateTo;
    _newObj.firstOrderAmountFrom = _obj.firstOrderAmountFrom;
    _newObj.firstOrderAmountTo = _obj.firstOrderAmountTo;
    _newObj.lastOrderAmountFrom = _obj.lastOrderAmountFrom;
    _newObj.lastOrderAmountTo = _obj.lastOrderAmountTo;
    _newObj.minOrderAmountFrom = _obj.minOrderAmountFrom;
    _newObj.minOrderAmountTo = _obj.minOrderAmountTo;
    _newObj.maxOrderAmountFrom = _obj.maxOrderAmountFrom;
    _newObj.maxOrderAmountTo = _obj.maxOrderAmountTo;
    _newObj.avgOrderAmountFrom = _obj.avgOrderAmountFrom;
    _newObj.avgOrderAmountTo = _obj.avgOrderAmountTo;
    _newObj.totalSpendFrom = _obj.totalSpendFrom;
    _newObj.totalSpendTo = _obj.totalSpendTo;
    _newObj.totalPaidFrom = _obj.totalPaidFrom;
    _newObj.totalPaidTo = _obj.totalPaidTo;
    _newObj.totalPendingFrom = _obj.totalPendingFrom;
    _newObj.totalPendingTo = _obj.totalPendingTo;
    _newObj.totalOrderFrom = _obj.totalOrderFrom;
    _newObj.totalOrderTo = _obj.totalOrderTo;
    _newObj.accountRegistrationFrom = _obj.accountRegistrationFrom;
    _newObj.accountRegistrationTo = _obj.accountRegistrationTo;
    _newObj.pincode = _obj.pincode;
    return _newObj;
  }
}
