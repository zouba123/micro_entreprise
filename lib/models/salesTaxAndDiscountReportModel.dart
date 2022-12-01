// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
class SalesTaxAndDiscountReportModel {
  double totalDiscountAmount;
  double totalTaxAmount;
  String accountNamePrefix;
  String accountFirstName;
  String accountMiddleName;
  String accountLastName;
  String accountNameSuffix;
  String accountMobileCountryCode;
  String accountMobile;
  String accountEmail;
  DateTime accountRegistrationDate;

  SalesTaxAndDiscountReportModel();

  SalesTaxAndDiscountReportModel.fromMap(Map<String, dynamic> map) {
    try {
      totalDiscountAmount = (map['totalDiscount'] != null) ? double.parse(map['totalDiscount'].toString()) : 0;
      totalTaxAmount = (map['totaltax'] != null) ? double.parse(map['totaltax'].toString()) : 0;
      // accountNamePrefix = (map['accountNamePrefix'] != null) ? map['accountNamePrefix'] : '';
      // accountFirstName = (map['accountFirstName'] != null) ? map['accountFirstName'] : '';
      // accountMiddleName = (map['accountMiddleName'] != null) ? map['accountMiddleName'] : '';
      // accountLastName = (map['accountLastName'] != null) ? map['accountLastName'] : '';
      // accountNameSuffix = (map['accountNameSuffix'] != null) ? map['accountNameSuffix'] : '';
      // accountMobileCountryCode = (map['accountMobileCountryCode'] != null) ? map['accountMobileCountryCode'] : '';
      // accountMobile = (map['accountMobile'] != null) ? map['accountMobile'] : '';
      // accountEmail = (map['accountEmail'] != null) ? map['accountEmail'] : '';
    } catch (e) {
      print('Exception - SalesTaxAndDiscountReportModel.dart - fromMap(): ' + e.toString());
    }
  }
}
