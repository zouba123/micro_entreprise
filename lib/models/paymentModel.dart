// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/paymentDetailModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceReturnModel.dart';
import 'package:accounting_app/models/paymentSaleOrderModel.dart';
import 'package:accounting_app/models/paymentSaleQuotesModel.dart';

class Payment {
  int id;
  int accountId;
  double amount;
  DateTime transactionDate;
  String paymentType;
  String remark;
  bool isCancel;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  List<PaymentDetail> paymentDetailList;
  PaymentSaleInvoice paymentInvoice =  PaymentSaleInvoice();
  PaymentSaleOrder paymentSaleOrder =  PaymentSaleOrder();
  PaymentSaleQuotes paymentSaleQuote =  PaymentSaleQuotes();
  PaymentPurchaseInvoice paymentPurchaseInvoice =  PaymentPurchaseInvoice();
  PaymentSaleInvoiceReturn paymentSaleInvoiceReturn =  PaymentSaleInvoiceReturn();
  PaymentPurchaseInvoiceReturn paymentPurchaseInvoiceReturn =  PaymentPurchaseInvoiceReturn();
  String invoiceNumber;
  String orderNumber;
  int saleQuoteNumber;
  bool isSaleInvoiceRef = false;
  bool isPurchaseInvoiceRef = false;
  bool isSaleInvoiceReturnRef = false;
  bool isPurchaseInvoiceReturnRef = false;
  bool isExpenseRef = false;
  bool isSaleOrderRef = false;
  int businessId;
  Account account;

  Payment() {
    paymentDetailList = [];
  }

  Payment.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    accountId = map['accountId'];
    amount = map['amount'].toDouble();
    transactionDate = DateTime.parse(map['transactionDate']);
    paymentType = map['paymentType'];
    remark = map['remark'];
    isCancel = map['isCancel'] == 'true' ? true : false;
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    businessId = map['businessId'];

    // account.accountCode = int.parse(map['accountCode']);
    // account.namePrefix = (map['namePrefix'] != null) ? map['namePrefix'] : '';
    // account.firstName = (map['firstName'] != null) ? map['firstName'] : '';
    // account.middleName = (map['middleName'] != null) ? map['middleName'] : '';
    // account.lastName = (map['lastName'] != null) ? map['lastName'] : '';
    // account.nameSuffix = (map['nameSuffix'] != null) ? map['nameSuffix'] : '';
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    print(transactionDate.toString());
    var _obj = {'id': id, 'accountId': accountId, 'amount': amount, 'transactionDate': transactionDate.toString(), 'paymentType': paymentType, 'remark': remark, 'isCancel': isCancel.toString(), 'isDelete': isDelete.toString(), 'modifiedAt': modifiedAt.toString(), 'businessId ': businessId};
    if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }
    return _obj;
  }
}
