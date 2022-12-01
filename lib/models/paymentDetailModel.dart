// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
class PaymentDetail {
  int id;
  int paymentId;
  double amount;
  String paymentMode;
  String remark;
  bool isCancel;
  DateTime createdAt;
  DateTime modifiedAt;
  bool isRecentlyAdded = false;
  int businessId;
  bool deletedFromScreen = false;
  bool isEdited = false;

  PaymentDetail(this.id, this.paymentId, this.amount, this.paymentMode, this.remark, this.isCancel, this.createdAt, this.modifiedAt);

  PaymentDetail.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    paymentId = map['paymentId'];
    amount = map['amount'].toDouble();
    paymentMode = map['paymentMode'];
    isCancel = map['isCancel'] == 'true' ? true : false;
    remark = (map['remark'] != null) ? map['remark'] : '';
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    businessId = map['businessId'];
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj = {'id': id, 'paymentId': paymentId, 'amount': amount, 'paymentMode': paymentMode, 'isCancel': isCancel.toString(), 'remark': remark, 'modifiedAt': modifiedAt.toString(), 'businessId ': businessId};
  
   if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }
    return _obj;
  }
}
