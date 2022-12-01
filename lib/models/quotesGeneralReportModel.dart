// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
class QuotesGeneralReportModel {
  // int saleInvoiceId;
  String saleQuoteNumber;
  String saleQuoteVersion;
  double grossAmount;
  double discountAmount;
  double taxAmount;
  double netAmount;
  DateTime quoteDate;
  String saleInvoiceNumber;
  String status;
  String accountNamePrefix;
  String accountFirstName;
  String accountMiddleName;
  String accountLastName;
  String accountNameSuffix;
  String accountMobileCountryCode;
  String accountMobile;
  String accountEmail;

  QuotesGeneralReportModel();

  QuotesGeneralReportModel.fromMap(Map<String, dynamic> map) {
    try {
      // saleInvoiceId = map['saleInvoiceId'];
      saleQuoteNumber = (map['saleQuoteNumber'] != null) ? map['saleQuoteNumber'] : '';
      saleQuoteVersion = (map['saleQuoteVersion'] != null) ? map['saleQuoteVersion'] : '';
      grossAmount = (map['grossAmount'] != null) ? double.parse(map['grossAmount'].toString()) : 0;
      discountAmount = (map['discount'] != null) ? double.parse(map['discount'].toString()) : 0;
      taxAmount = (map['finalTax'] != null) ? double.parse(map['finalTax'].toString()) : 0;
      netAmount = (map['netAmount'] != null) ? double.parse(map['netAmount'].toString()) : 0;
      quoteDate = (map['quoteDate'] != null) ? DateTime.parse(map['quoteDate']) : null;
      status = (map['status'] != null) ? map['status'] : '';
      saleInvoiceNumber = (map['invoiceNumber'] != null) ? map['invoiceNumber'] : '';

      accountNamePrefix = (map['accountNamePrefix'] != null) ? map['accountNamePrefix'] : '';
      accountFirstName = (map['accountFirstName'] != null) ? map['accountFirstName'] : '';
      accountMiddleName = (map['accountMiddleName'] != null) ? map['accountMiddleName'] : '';
      accountLastName = (map['accountLastName'] != null) ? map['accountLastName'] : '';
      accountNameSuffix = (map['accountNameSuffix'] != null) ? map['accountNameSuffix'] : '';
      accountMobileCountryCode = (map['accountMobileCountryCode'] != null) ? map['accountMobileCountryCode'] : '';
      accountMobile = (map['accountMobile'] != null) ? map['accountMobile'] : '';
      accountEmail = (map['accountEmail'] != null) ? map['accountEmail'] : '';
    } catch (e) {
      print('Exception - getQuotesGeneralReport.dart - fromMap(): ' + e.toString());
    }
  }
}
