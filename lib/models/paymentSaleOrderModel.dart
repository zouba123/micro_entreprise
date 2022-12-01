// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/saleOrderModel.dart';

class PaymentSaleOrder {
  int id;
  int paymentId;
  int saleOrderId;
  double amount;
  bool isCancel;
  DateTime createdAt;
  DateTime modifiedAt;
  String orderNumber;
  List<SaleOrder> orderList;
  int businessId;

  PaymentSaleOrder();

  PaymentSaleOrder.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    paymentId = map['paymentId'];
    saleOrderId = map['saleOrderId'];
    amount = map['amount'].toDouble();
    isCancel = map['isCancel'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    orderNumber = map['saleOrderNumber'];
    businessId = map['businessId'];
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj =  {'id': id, 'paymentId': paymentId, 'saleOrderId': saleOrderId, 'amount': amount, 'isCancel': isCancel.toString(),  'modifiedAt': modifiedAt.toString(), 'businessId ': businessId};
     if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }
    return _obj;
  }
}
