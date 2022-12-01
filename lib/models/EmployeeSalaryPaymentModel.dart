// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators
import 'package:accounting_app/models/accountModel.dart';

class EmployeeSalaryPayment {
  int id;
  int employeeSalaryId;
  int paymentId;
  int accountId;
  double salaryAmount;
  DateTime transactionDate;
  bool isAdvanced;
  bool isActive;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  int businessId;
  Account account;

  EmployeeSalaryPayment();

  EmployeeSalaryPayment.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    employeeSalaryId = map['employeeSalaryId'];
    paymentId = map['paymentId'];
    accountId = map['accountId'];
    salaryAmount = map['salaryAmount'].toDouble();
    isAdvanced = map['isAdvanced'] == 'true' ? true : false;
    transactionDate = DateTime.parse(map['transactionDate']);
    isActive = map['isActive'] == 'true' ? true : false;
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    businessId = map['businessId'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'employeeSalaryId': employeeSalaryId, 'paymentId': paymentId, 'accountId': accountId, 'salaryAmount': salaryAmount, 'transactionDate': transactionDate.toString(), 'isActive': isActive.toString(), 'isAdvanced': isAdvanced.toString(), 'isDelete': isDelete.toString(), 'createdAt': createdAt.toString(), 'modifiedAt': modifiedAt.toString(), 'businessId ': businessId};
  }
}
