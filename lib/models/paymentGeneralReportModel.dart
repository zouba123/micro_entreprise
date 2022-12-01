// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
class PaymentGeneralReportModel {
  double amount;
  DateTime transactionDate;
  String paymentType;
  String accountNamePrefix;
  String accountFirstName;
  String accountMiddleName;
  String accountLastName;
  String accountNameSuffix;
  String accountMobileCountryCode;
  String accountMobile;
  String accountEmail;
  String saleInvoiceNumber;
  String expenseName;

  PaymentGeneralReportModel();

  PaymentGeneralReportModel.fromMap(Map<String, dynamic> map) {
    try {
      amount = (map['paymentAmount'] != null) ? double.parse(map['paymentAmount'].toString()) : 0;
      transactionDate = (map['transactionDate'] != null) ? DateTime.parse(map['transactionDate']) : null;
      paymentType = (map['paymentType'] != null) ? map['paymentType'].toString() : '';
      accountNamePrefix = (map['accountNamePrefix'] != null) ? map['accountNamePrefix'] : '';
      accountFirstName = (map['accountFirstName'] != null) ? map['accountFirstName'] : '';
      accountMiddleName = (map['accountMiddleName'] != null) ? map['accountMiddleName'] : '';
      accountLastName = (map['accountLastName'] != null) ? map['accountLastName'] : '';
      accountNameSuffix = (map['accountNameSuffix'] != null) ? map['accountNameSuffix'] : '';
      accountMobileCountryCode = (map['accountMobileCountryCode'] != null) ? map['accountMobileCountryCode'] : '';
      accountMobile = (map['accountMobile'] != null) ? map['accountMobile'] : '';
      accountEmail = (map['accountEmail'] != null) ? map['accountEmail'] : '';
      saleInvoiceNumber = (map['invoiceNumber'] != null) ? map['invoiceNumber'] : '';
      expenseName = (map['expenseName'] != null) ? map['expenseName'] : '';
    } catch (e) {
      print('Exception - PaymentGeneralReportModel.dart - fromMap(): ' + e.toString());
    }
  }
}
