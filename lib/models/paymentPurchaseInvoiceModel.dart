// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
class PaymentPurchaseInvoice {
  int id;
  int paymentId;
  int invoiceId;
  double amount;
  bool isCancel;
  DateTime createdAt;
  DateTime modifiedAt;
  String invoiceNumber;
  List<PurchaseInvoice> invoiceList;
  int businessId;

  PaymentPurchaseInvoice();

  PaymentPurchaseInvoice.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    paymentId = map['paymentId'];
    invoiceId = map['invoiceId'];
    amount = map['amount'].toDouble();
    isCancel = map['isCancel'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    invoiceNumber = map['invoiceNumber'];
    businessId = map['businessId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paymentId': paymentId,
      'invoiceId': invoiceId,
      'amount': amount,
      'isCancel': isCancel.toString(),
      'createdAt': createdAt.toString(),
      'modifiedAt': modifiedAt.toString(),
      'businessId ': businessId
    };
  }
}
