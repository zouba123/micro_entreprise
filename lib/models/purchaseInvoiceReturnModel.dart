// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnDetailModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnTaxModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceModel.dart';
import 'package:accounting_app/models/paymentModel.dart';

class PurchaseInvoiceReturn {
  int id;
  String purchaseInvoiceNumber;
  int purchaseInvoiceId;
  String transactionGroupId;
  int accountId;
  double grossAmount;
  double finalTax;
  double discount;
  double netAmount;
  DateTime invoiceDate;
  bool isComplete;
  bool isRefundTax;
  String status;
  String remark;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  List<PurchaseInvoiceReturnDetail> invoiceReturnDetailList = [];
  List<PurchaseInvoiceReturnTax> invoiceReturnTaxList = [];
  Payment payment =  Payment();
  PaymentSaleInvoice paymentInvoice = PaymentSaleInvoice();
  int totalProducts;
  double remainAmount;
  int businessId;
  double totalSpent;
  Account account =  Account();
  List<PurchaseInvoiceReturn> childList = [];
  bool isSelect = false; // use during invoice selection in return invoice

  PurchaseInvoiceReturn(this.id, this.purchaseInvoiceId, this.transactionGroupId, this.purchaseInvoiceNumber, this.accountId, this.netAmount, this.discount, this.grossAmount, this.finalTax, this.invoiceDate, this.isRefundTax, this.status, this.account);

  // SaleInvoiceReturn();

  PurchaseInvoiceReturn.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    purchaseInvoiceId = map['purchaseInvoiceId'];
    transactionGroupId = map['transactionGroupId'];
    purchaseInvoiceNumber = map['purchaseInvoiceNumber'];
    accountId = map['accountId'];
    grossAmount = map['grossAmount'].toDouble();
    finalTax = map['finalTax'].toDouble();
    discount = map['discount'].toDouble();
    netAmount = map['netAmount'].toDouble();
    invoiceDate = DateTime.parse(map['invoiceDate']);
    isComplete = map['isComplete'] == 'true' ? true : false;
    isRefundTax = map['isRefundTax'] == 'true' ? true : false;
    status = map['status'];
    remark = map['remark'];
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    businessId = map['businessId'];
    totalSpent = map['totalSpent'] != null ? double.parse(map['totalSpent'].toString()) : 0.0;

    account.accountCode = int.parse(map['accountCode']);
    account.namePrefix = (map['namePrefix'] != null) ? map['namePrefix'] : '';
    account.firstName = (map['firstName'] != null) ? map['firstName'] : '';
    account.middleName = (map['middleName'] != null) ? map['middleName'] : '';
    account.lastName = (map['lastName'] != null) ? map['lastName'] : '';
    account.nameSuffix = (map['nameSuffix'] != null) ? map['nameSuffix'] : '';
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    print(invoiceDate.toString());

    var _obj = {
      'id': id,
      'purchaseInvoiceId': purchaseInvoiceId,
      'transactionGroupId': transactionGroupId,
      'purchaseInvoiceNumber': purchaseInvoiceNumber,
      'accountId': accountId,
      'grossAmount': grossAmount,
      'finalTax': finalTax,
      'discount': discount,
      'netAmount': netAmount,
      'invoiceDate': invoiceDate.toString(),
      'isComplete': isComplete.toString(),
      'isRefundTax': isRefundTax.toString(),
      'status': status,
      'remark': remark,
      'isDelete': isDelete.toString(),
      'modifiedAt': modifiedAt.toString(),
      'businessId ': businessId
    };

 if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }

return _obj;
  }
}
