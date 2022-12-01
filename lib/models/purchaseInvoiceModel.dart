// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceDetailModel.dart';
import 'package:accounting_app/models/purchaseInvoiceDetailTaxModel.dart';
import 'package:accounting_app/models/purchaseInvoiceTaxModel.dart';

class PurchaseInvoice {
  int id;
  String invoiceNumber;
  int accountId;
  double grossAmount;
  double finalTax;
  double discount;
  double netAmount;
  String taxGroup;
  DateTime invoiceDate;
  DateTime deliveryDate;
  bool isComplete;
  String status;
  String remark;
  String pdfPath;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  List<PurchaseInvoiceDetail> invoiceDetailList;
  List<PurchaseInvoiceTax> invoiceTaxList;
  List<PurchaseInvoiceDetailTax> invoiceDetailTaxList;
  Payment payment =  Payment();
  PaymentPurchaseInvoice paymentInvoice = PaymentPurchaseInvoice();
  int totalProducts;
  double remainAmount;
  int businessId;
  Account account =  Account();
  bool isSelect = false; // use during invoice selection in return invoice
  int returnProducts = 0;

  PurchaseInvoice() {
    invoiceDetailList = [];
    invoiceTaxList = [];
    invoiceDetailTaxList = [];
  }

  PurchaseInvoice.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    invoiceNumber = map['invoiceNumber'];
    accountId = map['accountId'];
    taxGroup = map['taxGroup'];
    grossAmount = map['grossAmount'].toDouble();
    finalTax = map['finalTax'].toDouble();
    discount = map['discount'].toDouble();
    netAmount = map['netAmount'].toDouble();
    invoiceDate = DateTime.parse(map['invoiceDate']);
    deliveryDate = DateTime.parse(map['deliveryDate']);
    isComplete = map['isComplete'] == 'true' ? true : false;
    status = map['status'];
    remark = map['remark'];
    pdfPath = (map['pdfPath'] != null) ? map['pdfPath'] : '';
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    businessId = map['businessId'];

    account.accountCode = int.parse(map['accountCode']);
    account.namePrefix = (map['namePrefix'] != null) ? map['namePrefix'] : '';
    account.firstName = (map['firstName'] != null) ? map['firstName'] : '';
    account.middleName = (map['middleName'] != null) ? map['middleName'] : '';
    account.lastName = (map['lastName'] != null) ? map['lastName'] : '';
    account.nameSuffix = (map['nameSuffix'] != null) ? map['nameSuffix'] : '';
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj =  {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'accountId': accountId,
      'grossAmount': grossAmount,
      'finalTax': finalTax,
      'taxGroup': taxGroup,
      'discount': discount,
      'netAmount': netAmount,
      'invoiceDate': invoiceDate.toString(),
      'deliveryDate': deliveryDate.toString(),
      'isComplete': isComplete,
      'status': status,
      'remark': remark,
      'pdfPath': pdfPath,
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
