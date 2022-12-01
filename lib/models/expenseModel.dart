// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:accounting_app/models/expensePaymentsModel.dart';
import 'package:accounting_app/models/paymentModel.dart';

class Expense {
  int id;
  int expenseCategoryId;
  String expenseCategoryName;
  double amount;
  DateTime transactionDate;
  DateTime weekLastDay;
  String paymentMode;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  String expenseName;
  bool isSplitPayment = false;
  bool isPaid = true;
  double totalDue = 0;
  double totalPaid = 0;
  String filePath;
  String tempFilePath;
  String oldFilePath;
  String billerName;
  String billNumber;
  String totalAmount;
  String categoryTotalSpends;
  String billerTotalSpends;
  Color color;
  int businessId;

  List<ExpensePayments> expensePaymentList = [];
  List<Payment> paymentList = [];

  Expense();

  Expense.fromMap(Map<String, dynamic> map) {
    id = map['id'];

    expenseCategoryId = map['expenseCategoryId'];
    amount = map['amount'] != null ? map['amount'].toDouble() : null;
    transactionDate = map['transactionDate'] != null ? DateTime.parse(map['transactionDate']) : null;
    paymentMode = map['paymentMode'] != null ? map['paymentMode'] : null;
    isDelete = map['isDelete'] == 'true' ? true : false;
    isPaid = map['isPaid'] == 'true' ? true : false;
    isSplitPayment = map['isSplitPayment'] == 'true' ? true : false;
    createdAt = map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null;
    modifiedAt = map['modifiedAt'] != null ? DateTime.parse(map['modifiedAt']) : null;
    expenseCategoryName = map['name'];
    expenseName = map['expenseName'];
    filePath = map['filePath'];
    billerName = map['billerName'];
    billNumber = map['billNumber'];
    totalAmount = map['totalAmount'] != null ? map['totalAmount'].toString() : null;
    categoryTotalSpends = map['categoryTotalSpends'] != null ? map['categoryTotalSpends'].toString() : null;
    billerTotalSpends = map['billerTotalSpends'] != null ? map['billerTotalSpends'].toString() : null;
    weekLastDay = map['weekLastDay'] != null ? DateTime.parse(map['weekLastDay']) : null;
    businessId = map['businessId'];
    color = RandomColor().randomColor(
      colorHue: ColorHue.multiple(colorHues: _hueType),
      colorSaturation: _colorSaturation,
      colorBrightness: _colorLuminosity,
    );
  }

  final List<ColorHue> _hueType = <ColorHue>[ColorHue.red, ColorHue.green, ColorHue.orange, ColorHue.blue, ColorHue.pink, ColorHue.purple, ColorHue.yellow];
  ColorBrightness _colorLuminosity = ColorBrightness.light;
  ColorSaturation _colorSaturation = ColorSaturation.custom(Range(65, 75));

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj = {'id': id, 'expenseCategoryId': expenseCategoryId, 'amount': amount, 'transactionDate': transactionDate.toString(), 'paymentMode': paymentMode, 'filePath': filePath, 'isDelete': isDelete.toString(), 'modifiedAt': modifiedAt.toString(), 'expenseName': expenseName, 'isPaid': isPaid.toString(), 'isSplitPayment': isSplitPayment.toString(), 'billerName': billerName, 'billNumber': billNumber, 'businessId ': businessId};
    if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }
    return _obj;
  }
}
