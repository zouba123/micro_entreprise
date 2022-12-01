// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators
import 'package:accounting_app/models/accountModel.dart';

class Attendance {
  int id;
  int accountId;
  String accountType;
  String name;
  bool isAbsent = false;
  DateTime attendanceDate;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  int businessId;
  int selectionType;
  Account account =  Account();
  List<Attendance> present = [];
  List<Attendance> absent = [];

  Attendance(this.accountId, this.accountType, this.name, this.attendanceDate);

  Attendance.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    accountId = map['accountId'];
    attendanceDate = DateTime.parse(map['attendanceDate']);
    isAbsent = map['isAbsent'] == 'true' ? true : false;
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    businessId = map['businessId'];
    selectionType = map['selectionType'];
    //account.accountCode = int.parse(map['accountCode']);
    account.namePrefix = (map['namePrefix'] != null) ? map['namePrefix'] : '';
    account.firstName = (map['firstName'] != null) ? map['firstName'] : '';
    account.middleName = (map['middleName'] != null) ? map['middleName'] : '';
    account.lastName = (map['lastName'] != null) ? map['lastName'] : '';
    account.nameSuffix = (map['nameSuffix'] != null) ? map['nameSuffix'] : '';
    account.accountType = (map['accountType'] != null) ? map['accountType'] : '';
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj = {'id': id, 'accountId': accountId, 'attendanceDate': (attendanceDate != null) ? attendanceDate.toString().substring(0, 10) : '', 'isAbsent': isAbsent.toString(), 'selectionType': selectionType, 'isDelete': isDelete.toString(), 'modifiedAt': modifiedAt.toString(), 'businessId ': businessId};

    if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }
    return _obj;
  }
}
