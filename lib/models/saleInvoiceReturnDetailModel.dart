// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnDetailTaxModel.dart';

class SaleInvoiceReturnDetail {
  int id;
  int invoiceId;
  int saleInvoiceReturnId;
  int productId;
  int unitId;
  int productUnitId;
  double quantity;
  double unitPrice;
  double soldUnitPrice;
  double amount;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  String productName;
  int productCode;
  String unitCode;
  String productTypeName;
  double actualUnitPrice;
  Product product;
  int businessId;
  double returnQuantity;
  List<SaleInvoiceReturnDetailTax> invoiceReturnDetailTaxList = [];
  bool isSelect = false; // use during invoice detail selection in return sale invoice
  bool isValidRQty = true; // use during add sale return
  int quantityOld;

  SaleInvoiceReturnDetail(this.id, this.invoiceId, this.saleInvoiceReturnId, this.productId, this.unitId, this.productUnitId, this.unitCode, this.quantity, this.unitPrice, this.soldUnitPrice, this.amount, this.productName, this.productCode, this.productTypeName, this.actualUnitPrice, this.isDelete, this.createdAt, this.modifiedAt, this.returnQuantity);

  SaleInvoiceReturnDetail.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    invoiceId = map['invoiceId'];
    saleInvoiceReturnId = map['saleInvoiceReturnId'];
    productId = map['productId'];
    unitId = map['unitId'];
    productUnitId = map['productUnitId'];
    quantity = map['quantity'].toDouble();
    unitPrice = map['unitPrice'].toDouble();
    soldUnitPrice = (map['soldUnitPrice'] != null) ? map['soldUnitPrice'].toDouble() : null;
    amount = map['amount'].toDouble();
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    productName = map['productName'];
    productCode = map['productCode'];
    unitCode = map['unitCode'];
    productTypeName = map['productTypeName'];
    actualUnitPrice = map['actualUnitPrice'].toDouble();
    businessId = map['businessId'];
    quantityOld = map['quantityOld'];
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj = {
      'id': id,
      'invoiceId': invoiceId,
      'saleInvoiceReturnId': saleInvoiceReturnId,
      'productId': productId,
      'unitId': unitId,
      'productUnitId': productUnitId,
      'unitCode': unitCode,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'soldUnitPrice': soldUnitPrice,
      'amount': amount,
      'isDelete': isDelete.toString(),
      'modifiedAt': modifiedAt.toString(),
      'productName': productName,
      'productCode': productCode,
      'productTypeName': productTypeName,
      'actualUnitPrice': actualUnitPrice,
      'businessId ': businessId,
      'quantityOld' : 0,
    };

    if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }

    return _obj;
  }
}
