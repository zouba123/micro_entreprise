// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators
class ExpenseGeneralReportModel {
  String expenseName;
  double amount;
  DateTime transactionDate;
  String isSplitPayment;
  String billerName;
  String billerNumber;
  String categoryName;
  double paidAmount;
  double pendingAmount;

  ExpenseGeneralReportModel();

  ExpenseGeneralReportModel.fromMap(Map<String, dynamic> map) {
    try {
      expenseName = (map['expenseName'] != null) ? map['expenseName'] : '';
      amount = (map['expenseAmount'] != null) ? double.parse(map['expenseAmount'].toString()) : 0;
      transactionDate = (map['transactionDate'] != null) ? DateTime.parse(map['transactionDate'].toString()) : 0;
      isSplitPayment = map['isSplitPayment'] == 'true' ? 'Yes' : 'No';
      billerName = (map['billerName'] != null) ? map['billerName'] : '';
      billerNumber = (map['billerNumber'] != null) ? map['billerNumber'] : '';
      categoryName = (map['categoryName'] != null) ? map['categoryName'] : '';
      paidAmount = (map['paidAmount'] != null) ? double.parse(map['paidAmount'].toString()) : 0;
      pendingAmount = amount - paidAmount;
    } catch (e) {
      print('Exception - ExpenseGeneralReportModel.dart - fromMap(): ' + e.toString());
    }
  }
}
