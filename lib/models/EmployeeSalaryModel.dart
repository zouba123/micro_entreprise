// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators
class EmployeeSalary {
  int id;
  int accountId;
  int employeeSalaryStructureId;
  double salaryAmount;
  DateTime startDate;
  DateTime endDate;
  String status;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  int businessId;
  double leaveCutAmount;

  EmployeeSalary(this.accountId,this.employeeSalaryStructureId, this.salaryAmount, this.startDate, this.endDate, this.status, this.leaveCutAmount);

  EmployeeSalary.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    accountId = map['accountId'];
    employeeSalaryStructureId = map['employeeSalaryStructureId'];
    salaryAmount = map['salaryAmount'].toDouble();
    startDate = DateTime.parse(map['startDate']);
    endDate = DateTime.parse(map['endDate']);
    status = map['status'];
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    businessId = map['businessId'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'accountId' : accountId, 'employeeSalaryStructureId': employeeSalaryStructureId, 'salaryAmount': salaryAmount, 'startDate': (startDate != null) ? startDate.toString() : '', 'endDate': (endDate != null) ? endDate.toString() : '', 'status': status, 'isDelete': isDelete.toString(), 'createdAt': createdAt.toString(), 'modifiedAt': modifiedAt.toString(), 'businessId ': businessId};
  }
}
