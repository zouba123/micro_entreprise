// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/saleInvoiceDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceDetailTaxModel.dart';
import 'package:accounting_app/models/saleInvoiceTaxModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/saleOrderInvoiceModel.dart';
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/models/salesQuoteInvoiceModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';

class SaleInvoice {
  int id;
  int invoiceNumber;
  int accountId;
  int versionNumber;
  double grossAmount;
  double finalTax;
  double discount;
  double netAmount;
  DateTime invoiceDate;
  DateTime deliveryDate;
  bool isComplete;
  String status;
  String remark;
  bool generateByProductCategory;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  String voucherNumber;
  String taxGroup;
  List<SaleInvoiceDetail> invoiceDetailList;
  List<SaleInvoiceTax> invoiceTaxList;
  List<SaleInvoiceDetailTax> invoiceDetailTaxList;
  Payment payment = Payment();
  PaymentSaleInvoice paymentInvoice = PaymentSaleInvoice();
  int totalProducts;
  int returnProducts = 0;
  double remainAmount;
  int businessId;
  int salesQuoteId;
  Account account = Account();
  List<GenerateByCategory> generateByCategoryList = [];
  List<ReturnGenerateByCategory> returnGenerateByCategoryList = [];
  bool isSelect = false; // use during invoice selection in return invoice
  //SaleOrder saleOrder =  SaleOrder();
  List<SaleOrder> saleOrderList = [];
  List<SaleQuote> saleQuoteList = [];
  List<SaleOrderInvoice> saleOrderInvoiceList = [];
  List<SaleQuoteInvoice> saleQuoteInvoiceList = [];
  int salesQuoteNumber;
  int salesQuoteVersion;
  bool showRemarkInPrint;
  String pdfPath;
  bool includeAttachmentsEmail;
  bool isEmailSent = false;
  int salesOrderId;
  int salesOrderNumber;
  SaleInvoice() {
    invoiceDetailList = [];
    invoiceTaxList = [];
    invoiceDetailTaxList = [];
  }

  SaleInvoice.fromMap(Map<String, dynamic> map) {
    try {
      id = map['id'];
      invoiceNumber = int.parse(map['invoiceNumber']);
      voucherNumber = map['voucherNumber'];
      taxGroup = map['taxGroup'];
      accountId = map['accountId'];
      salesQuoteId = map['salesQuoteId'];
      grossAmount = map['grossAmount'].toDouble();
      finalTax = map['finalTax'].toDouble();
      discount = map['discount'].toDouble();
      netAmount = map['netAmount'].toDouble();
      invoiceDate = DateTime.parse(map['invoiceDate']);
      deliveryDate = DateTime.parse(map['deliveryDate']);
      isComplete = map['isComplete'] == 'true' ? true : false;
      generateByProductCategory = map['generateByProductCategory'] == 'true' ? true : false;
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

      salesQuoteNumber = (map['salesQuoteNumber'] != null) ? int.parse(map['salesQuoteNumber']) : null;
      salesQuoteVersion = (map['salesQuoteVersion'] != null) ? int.parse(map['salesQuoteVersion']) : null;
      showRemarkInPrint = map['showRemarkInPrint'] == 'true' ? true : false;

      pdfPath = (map['pdfPath'] != null) ? map['pdfPath'] : '';
      includeAttachmentsEmail = map['includeAttachmentsEmail'] == 'true' ? true : false;
      isEmailSent = map['isEmailSent'] == 'true' ? true : false;

      salesOrderId = map['salesOrderId'];
      salesOrderNumber = (map['salesOrderNumber'] != null) ? int.parse(map['salesOrderNumber']) : null;
    } catch (e) {
      print("Exception: SaleInvoiceModel.dart: fromMap():  ${e.toString()}");
    }
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj = {'id': id, 'invoiceNumber': invoiceNumber, 'voucherNumber': voucherNumber, 'taxGroup': taxGroup, 'accountId': accountId, 'grossAmount': grossAmount, 'finalTax': finalTax, 'discount': discount, 'netAmount': netAmount, 'invoiceDate': invoiceDate.toString(), 'deliveryDate': deliveryDate.toString(), 'isComplete': isComplete.toString(), 'generateByProductCategory': generateByProductCategory.toString(), 'status': status, 'remark': remark, 'isDelete': isDelete.toString(), 'modifiedAt': modifiedAt.toString(), 'businessId ': businessId, 'salesQuoteId': salesQuoteId, 'showRemarkInPrint': showRemarkInPrint.toString(), 'pdfPath': pdfPath, 'includeAttachmentsEmail': includeAttachmentsEmail.toString(), 'isEmailSent': isEmailSent.toString(), 'salesOrderId': salesOrderId};

    if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }

    return _obj;
  }
}

class GenerateByCategory {
  String productCategoryName;
  int quantity;
  double amount;
}

class ReturnGenerateByCategory {
  String productCategoryName;
  int quantity;
  double amount;
}
