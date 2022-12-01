// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
class SalesGeneralReportModel {
  // int saleInvoiceId;
  String saleInvoiceNumber;
  String saleQuoteNumber;
  String saleQuoteversion;
  String accountNamePrefix;
  String accountFirstName;
  String accountMiddleName;
  String accountLastName;
  String accountNameSuffix;
  String accountMobileCountryCode;
  String accountMobile;
  String accountEmail;
  
  double grossAmount;
  double discountAmount;
  double taxAmount;
  double netAmount;
  DateTime invoiceDate;
  DateTime deliveryDate;
  double paymentDone;
  double paymentPending;
  String status;

  SalesGeneralReportModel();

  SalesGeneralReportModel.fromMap(Map<String, dynamic> map) {
    try {
      // saleInvoiceId = map['saleInvoiceId'];
      saleInvoiceNumber = (map['invoiceNumber'] != null) ? map['invoiceNumber'].toString() : '';
      saleQuoteNumber = (map['saleQuoteNumber'] != null) ? map['saleQuoteNumber'].toString() : '';
      saleQuoteversion = (map['saleQuoteVersion'] != null) ? map['saleQuoteVersion'].toString() : '';
      accountNamePrefix = (map['accountNamePrefix'] != null) ? map['accountNamePrefix'] : '';
      accountFirstName = (map['accountFirstName'] != null) ? map['accountFirstName'] : '';
      accountMiddleName = (map['accountMiddleName'] != null) ? map['accountMiddleName'] : '';
      accountLastName = (map['accountLastName'] != null) ? map['accountLastName'] : '';
      accountNameSuffix = (map['accountNameSuffix'] != null) ? map['accountNameSuffix'] : '';
      accountMobileCountryCode = (map['accountMobileCountryCode'] != null) ? map['accountMobileCountryCode'] : '';
      accountMobile = (map['accountMobile'] != null) ? map['accountMobile'] : '';
      accountEmail = (map['accountEmail'] != null) ? map['accountEmail'] : '';
      grossAmount = (map['grossAmount'] != null) ? double.parse(map['grossAmount'].toString()) : 0;
      discountAmount = (map['discount'] != null) ? double.parse(map['discount'].toString()) : 0;
      taxAmount = (map['finalTax'] != null) ? double.parse(map['finalTax'].toString()) : 0;
      netAmount = (map['netAmount'] != null) ? double.parse(map['netAmount'].toString()) : 0;
      invoiceDate = (map['invoiceDate'] != null) ? DateTime.parse(map['invoiceDate']) : null;
      deliveryDate = (map['deliveryDate'] != null) ? DateTime.parse(map['deliveryDate']) : null;
      paymentDone = (map['paymentDone'] != null) ? double.parse(map['paymentDone'].toString()) : 0;
      paymentPending = netAmount - paymentDone;
      status = (map['status'] != null) ? map['status'] : '';
    } catch (e) {
      print('Exception - SalesGeneralReport.dart - fromMap(): ' + e.toString());
    }
  }
}
