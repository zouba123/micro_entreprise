// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
class ExpensePayments {
  int id;
  int expenseId;
  int paymentId;
  DateTime createdAt;
  DateTime modifiedAt;
  int businessId;
  ExpensePayments();
  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj = <String, dynamic>{'id': id, 'expenseId': expenseId, 'paymentId': paymentId,  'modifiedAt': modifiedAt != null ? modifiedAt.toIso8601String() : null, 'businessId': businessId};
    if (_isInsert) {
      _obj['createdAt'] = createdAt != null ? createdAt.toIso8601String() : null;
    }
    return _obj;
  }

  ExpensePayments.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    expenseId = map['expenseId'];
    paymentId = map['paymentId'];
    businessId = map['businessId'];
    createdAt = map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null;
    modifiedAt = map['modifiedAt'] != null ? DateTime.parse(map['modifiedAt']) : null;
  }
}