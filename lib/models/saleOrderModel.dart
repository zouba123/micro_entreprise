// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentSaleOrderModel.dart';
import 'package:accounting_app/models/saleOrderDetailModel.dart';
import 'package:accounting_app/models/saleOrderDetailTaxModel.dart';
import 'package:accounting_app/models/saleOrderTaxModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';

class SaleOrder {
  int id;
  int saleOrderNumber;
  int accountId;
  double grossAmount;
  double finalTax;
  double discount;
  double netAmount;
  DateTime orderDate;
  DateTime deliveryDate;
  bool isComplete;
  String status;
  String remark;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  String voucherNumber;
  String taxGroup;
  int salesQuoteId;
  List<SaleOrderDetail> orderDetailList;
  List<SaleOrderTax> orderTaxList;
  List<SaleQuote> saleQuoteList = [];
  List<SaleOrderDetailTax> orderDetailTaxList;
  Payment payment = Payment();
  PaymentSaleOrder paymentSaleOrder = PaymentSaleOrder();
  int totalProducts;
  double remainAmount;
  double advanceAmount = 0;
  int businessId;
  Account account = Account();
  double paymentByCash = 0;
  double paymentByCheque = 0;
  double paymentByCard = 0;
  double paymentByNetBanking = 0;
  double paymentByEWallet = 0;
  bool isSelected = false; // used in import order in add invoie screen
  bool isEditable = true;
  bool showRemarkInPrint;
  int salesQuoteNumber;
  int salesQuoteVersion;

  int salesInvoiceId;
  int salesInvoiceNumber;
  SaleOrder() {
    orderDetailList = [];
    orderTaxList = [];
    orderDetailTaxList = [];
  }

  SaleOrder.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    saleOrderNumber = int.parse(map['saleOrderNumber']);
    voucherNumber = map['voucherNumber'];
    taxGroup = map['taxGroup'];
    accountId = map['accountId'];
    salesQuoteId = map['salesQuoteId'];
    grossAmount = map['grossAmount'].toDouble();
    finalTax = map['finalTax'].toDouble();
    discount = map['discount'].toDouble();
    netAmount = map['netAmount'].toDouble();
    orderDate = DateTime.parse(map['orderDate']);
    deliveryDate = DateTime.parse(map['deliveryDate']);
    isComplete = map['isComplete'] == 'true' ? true : false;
    status = map['status'];
    remark = map['remark'];
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    businessId = map['businessId'];
    showRemarkInPrint = map['showRemarkInPrint'] == 'true' ? true : false;
    salesQuoteNumber = (map['salesQuoteNumber'] != null) ? int.parse(map['salesQuoteNumber']) : null;
    salesQuoteVersion = (map['salesQuoteVersion'] != null) ? int.parse(map['salesQuoteVersion']) : null;

     salesInvoiceId = map['salesInvoiceId'];
    salesInvoiceNumber = (map['salesInvoiceNumber'] != null) ? int.parse(map['salesInvoiceNumber']) : null;

    account.accountCode = int.parse(map['accountCode']);
    account.namePrefix = (map['namePrefix'] != null) ? map['namePrefix'] : '';
    account.firstName = (map['firstName'] != null) ? map['firstName'] : '';
    account.middleName = (map['middleName'] != null) ? map['middleName'] : '';
    account.lastName = (map['lastName'] != null) ? map['lastName'] : '';
    account.nameSuffix = (map['nameSuffix'] != null) ? map['nameSuffix'] : '';
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj = {'id': id, 'saleOrderNumber': saleOrderNumber, 'showRemarkInPrint': showRemarkInPrint.toString(), 'voucherNumber': voucherNumber, 'taxGroup': taxGroup, 'accountId': accountId, 'grossAmount': grossAmount, 'finalTax': finalTax, 'discount': discount, 'netAmount': netAmount, 'orderDate': orderDate.toString(), 'deliveryDate': deliveryDate.toString(), 'isComplete': isComplete.toString(), 'status': status, 'remark': remark, 'isDelete': isDelete.toString(), 'modifiedAt': modifiedAt.toString(), 'businessId ': businessId, 'salesQuoteId': salesQuoteId};
    if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }
    return _obj;
  }
}
