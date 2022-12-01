// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators
import 'package:accounting_app/models/accountModel.dart';

class EmployeeSalaryStructures {
  int id;
  int accountId;
  String salaryType;
  double salary;
  double leaveCutAmount;
  DateTime startDate;
  bool isActive;
  bool isDelete;
  Account account;
  DateTime createdAt;
  DateTime modifiedAt;
  int businessId;

  EmployeeSalaryStructures();

  EmployeeSalaryStructures.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    accountId = map['accountId'];
    salaryType = map['salaryType'];
    salary = map['salary'].toDouble();
    leaveCutAmount = map['leaveCutAmount'].toDouble();
    startDate = DateTime.parse(map['startDate']);
    isActive = map['isActive'] == 'true' ? true : false;
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    businessId = map['businessId'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'accountId': accountId, 'salaryType': salaryType, 
    'salary': salary, 
    'leaveCutAmount' : leaveCutAmount,
    'startDate': (startDate != null) ? startDate.toString() : '', 'isActive': isActive.toString(), 'isDelete': isDelete.toString(), 'createdAt': createdAt.toString(), 'modifiedAt': modifiedAt.toString(), 'businessId ': businessId};
  }
}
