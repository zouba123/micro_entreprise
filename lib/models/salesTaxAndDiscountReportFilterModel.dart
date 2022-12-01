// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
class SalesTaxAndDiscountReportFilterModel {
  DateTime salesInvoiceDateFrom;
  DateTime salesInvoiceDateTo;
  DateTime accountRegistrationDateFrom;
  DateTime accountRegistrationDateTo;
  String accountPincode;
  double totalDiscountAmountFrom;
  double totalDiscountAmountTo;
  double totalTaxAmountFrom;
  double totalTaxAmountTo;

  SalesTaxAndDiscountReportFilterModel();

  SalesTaxAndDiscountReportFilterModel copyFrom(SalesTaxAndDiscountReportFilterModel _obj) {
    SalesTaxAndDiscountReportFilterModel _newObj = SalesTaxAndDiscountReportFilterModel();
    _newObj.salesInvoiceDateFrom = _obj.salesInvoiceDateFrom;
    _newObj.salesInvoiceDateTo = _obj.salesInvoiceDateTo;
    _newObj.accountRegistrationDateFrom = _obj.accountRegistrationDateFrom;
    _newObj.accountRegistrationDateTo = _obj.accountRegistrationDateTo;
    _newObj.accountPincode = _obj.accountPincode;
    _newObj.totalDiscountAmountFrom = _obj.totalDiscountAmountFrom;
    _newObj.totalDiscountAmountTo = _obj.totalDiscountAmountTo;
    _newObj.totalTaxAmountFrom = _obj.totalTaxAmountFrom;
    _newObj.totalTaxAmountTo = _obj.totalTaxAmountTo;
    return _newObj;
  }
}
