// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/productModel.dart';

class SaleOrderDetail {
  int id;
  int saleOrderId;
  int productId;
  double quantity;
  double invoicedQuantity;
  double unitPrice;
  int unitId;
  int productUnitId;
  double amount;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  String productName;
  int productCode;
//  String supplierProductCode;
  String productTypeName;
  double actualUnitPrice;
  Product product;
  int businessId;
  String unitCode;
  bool isSelect = false; // use in select product during sale invoice retrun
  int quantityOld;
  int invoicedQuantityOld;
  String productDescription;

  SaleOrderDetail(this.id, this.saleOrderId, this.productId, this.unitId, this.productUnitId, this.unitCode, this.quantity, this.invoicedQuantity, this.unitPrice, this.amount, this.productName, this.productCode, this.productTypeName, this.actualUnitPrice, this.isDelete, this.createdAt, this.modifiedAt, this.productDescription);

  SaleOrderDetail.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    saleOrderId = map['saleOrderId'];
    productId = map['productId'];
    unitId = map['unitId'];
    productUnitId = map['productUnitId'];
    quantity = map['quantity'].toDouble();
    invoicedQuantity = map['invoicedQuantity'].toDouble();
    unitPrice = map['unitPrice'].toDouble();
    amount = map['amount'].toDouble();
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    productName = map['productName'];
    productCode = map['productCode'];
    //  supplierProductCode = map['supplierProductCode'];
    productTypeName = map['productTypeName'];
    actualUnitPrice = map['actualUnitPrice'].toDouble();
    unitCode = map['unitCode'];
    businessId = map['businessId'];
    quantityOld = map['quantityOld'];
    invoicedQuantityOld = map['invoicedQuantityOld'];
    productDescription = map['productDescription'];
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj = {
      'id': id,
      'saleOrderId': saleOrderId,
      'productId': productId,
      'quantity': quantity,
      'invoicedQuantity': invoicedQuantity,
      'unitPrice': unitPrice,
      'unitId': unitId,
      'productUnitId': productUnitId,
      'unitCode': unitCode,
      'amount': amount,
      'isDelete': isDelete.toString(),
      'modifiedAt': modifiedAt.toString(),
      'productName': productName,
      'productCode': productCode,
      'productTypeName': productTypeName,
      'actualUnitPrice': actualUnitPrice,
      'businessId ': businessId,
      'quantityOld': 0,
      "invoicedQuantityOld": 0,
       'productDescription': productDescription,
    };

    if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }
    return _obj;
  }
}
