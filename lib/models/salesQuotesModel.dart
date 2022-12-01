// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/saleQuoteDetailModel.dart';
import 'package:accounting_app/models/saleQuoteDetailTaxModel.dart';
import 'package:accounting_app/models/saleQuoteTaxModel.dart';

class SaleQuote {
  int id;
  int saleQuoteNumber;
  int versionNumber;
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
  List<SaleQuoteDetail> quoteDetailList;
  List<SaleQuoteTax> quoteTaxList;
  List<SaleQuoteDetailTax> quoteDetailTaxList;
  Payment payment = Payment();
  // PaymentSaleQuotes paymentSaleQuote = PaymentSaleQuotes();
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
  int saleInvoiceId;
  int saleInvoiceNumber;
   int saleOrderId;
  int saleOrderNumber;
  bool showRemarkInPrint;
  bool includeAttachmentsEmail;
  bool isEmailSent = false;
  String pdfPath;
  SaleQuote() {
    quoteDetailList = [];
    quoteTaxList = [];
    quoteDetailTaxList = [];
  }

  SaleQuote.fromMap(Map<String, dynamic> map) {
    try {
      id = map['id'];
      saleQuoteNumber = int.parse(map['saleQuoteNumber']);
      versionNumber = int.parse(map['versionNumber']);
      voucherNumber = map['voucherNumber'];
      taxGroup = map['taxGroup'];
      accountId = map['accountId'];
      grossAmount = map['grossAmount'].toDouble();
      finalTax = map['finalTax'].toDouble();
      discount = map['discount'].toDouble();
      netAmount = map['netAmount'].toDouble();
      orderDate = DateTime.parse(map['orderDate']);
      deliveryDate = DateTime.parse(map['deliveryDate']);
      isComplete = map['isComplete'] == 'true' ? true : false;
      showRemarkInPrint = map['showRemarkInPrint'] == 'true' ? true : false;
      status = map['status'];
      remark = map['remark'];
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
      saleInvoiceId = map['invoiceId'];
      saleInvoiceNumber = (map['invoiceNumber'] != null) ? int.parse(map['invoiceNumber']) : null;
      saleOrderId = map['orderId'];
      saleOrderNumber = (map['saleOrderNumber'] != null) ? int.parse(map['saleOrderNumber']) : null;
      isEmailSent = map['isEmailSent'] == 'true' ? true : false;
      includeAttachmentsEmail = map['includeAttachmentsEmail'] == 'true' ? true : false;
      pdfPath = (map['pdfPath'] != null) ? map['pdfPath'] : '';
    } catch (e) {
      print('Exception: salesQuotesModel.dart - fromJson(): ${e.toString()}');
    }
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj = {
      'id': id,
      'saleQuoteNumber': saleQuoteNumber,
      'versionNumber': versionNumber,
      'voucherNumber': voucherNumber,
      'taxGroup': taxGroup,
      'accountId': accountId,
      'grossAmount': grossAmount,
      'finalTax': finalTax,
      'discount': discount,
      'netAmount': netAmount,
      'orderDate': orderDate.toString(),
      'deliveryDate': deliveryDate.toString(),
      'isComplete': isComplete.toString(),
      'showRemarkInPrint': showRemarkInPrint.toString(),
      'status': status,
      'remark': remark,
      'isDelete': isDelete.toString(),
      'modifiedAt': modifiedAt.toString(),
      'businessId ': businessId,
      'pdfPath': pdfPath,
      'isEmailSent': isEmailSent.toString(),
      'includeAttachmentsEmail': includeAttachmentsEmail.toString(),
    };
    if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }
    return _obj;
  }
}
