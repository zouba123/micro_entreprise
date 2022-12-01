// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators
class AccountSellerReportModel {
  // int saleInvoiceId;
  DateTime firstOrderDate;
  DateTime lastOrderDate;
  double firstOrderAmount;
  double lastOrderAmount;
  double minOrderAmount;
  double maxOrderAmount;
  double avgOrderAmount;
  int totalOrders;
  double totalSpend;
  double totalPaid;
  double totalPending;
  String accountNamePrefix;
  String accountFirstName;
  String accountMiddleName;
  String accountLastName;
  String accountNameSuffix;
  String accountMobileCountryCode;
  String accountMobile;
  String accountEmail;
  DateTime accountRegistrationDate;

  AccountSellerReportModel();

  AccountSellerReportModel.fromMap(Map<String, dynamic> map) {
    try {
      // saleInvoiceId = map['saleInvoiceId'];
      firstOrderDate = (map['firstOrderDate'] != null) ? DateTime.parse(map['firstOrderDate']) : null;
      lastOrderDate = (map['firstOrderDate'] != null) ? DateTime.parse(map['lastOrderDate']) : null;
      firstOrderAmount = (map['firstOrderAmount'] != null) ? double.parse(map['firstOrderAmount'].toString()) : 0;
      lastOrderAmount = (map['lastOrderAmount'] != null) ? double.parse(map['lastOrderAmount'].toString()) : 0;
      minOrderAmount = (map['minOrderAmount'] != null) ? double.parse(map['minOrderAmount'].toString()) : 0;
      maxOrderAmount = (map['maxOrderAmount'] != null) ? double.parse(map['maxOrderAmount'].toString()) : 0;
      avgOrderAmount = (map['avgOrderAmount'] != null) ? double.parse(map['avgOrderAmount'].toString()) : 0;
      totalOrders = (map['totalOrders'] != null) ? int.parse(map['totalOrders'].toString()) : 0;


      totalSpend = (map['totalSpend'] != null) ? double.parse(map['totalSpend'].toString()) : 0;
      totalPaid = (map['totalPaid'] != null) ? double.parse(map['totalPaid'].toString()) : 0;
      totalPending =  totalSpend - totalPaid;

      // accountNamePrefix = (map['accountNamePrefix'] != null) ? map['accountNamePrefix'] : '';
      // accountFirstName = (map['accountFirstName'] != null) ? map['accountFirstName'] : '';
      // accountMiddleName = (map['accountMiddleName'] != null) ? map['accountMiddleName'] : '';
      // accountLastName = (map['accountLastName'] != null) ? map['accountLastName'] : '';
      // accountNameSuffix = (map['accountNameSuffix'] != null) ? map['accountNameSuffix'] : '';
      // accountMobileCountryCode = (map['accountMobileCountryCode'] != null) ? map['accountMobileCountryCode'] : '';
      // accountMobile = (map['accountMobile'] != null) ? map['accountMobile'] : '';
      // accountEmail = (map['accountEmail'] != null) ? map['accountEmail'] : '';
      // accountRegistrationDate = (map['accountRegistrationDate'] != null) ? DateTime.parse(map['accountRegistrationDate']) : null;
    } catch (e) {
      print('Exception - SalesGeneralReport.dart - fromMap(): ' + e.toString());
    }
  }
}
