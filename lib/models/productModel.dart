// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/productPriceModel.dart';
import 'package:accounting_app/models/productTaxModel.dart';
import 'package:accounting_app/models/unitModel.dart';

class Product {
  int id;
  int productCode;
  int unitCombinationId;
  String supplierProductCode;
  String name;
  String description;
  String type;
  String hsnCode;
  int productTypeId;
  double unitPrice = 0;
  String imagePath;
  bool isActive;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  String productTypeName;
  bool isSelect = false; // use during product selection in add invoice
  List<ProductTax> productTaxList = [];
  List<ProductPrice> productPriceList;
  List<Unit> unitList = []; // use during add update invoice.
  int businessId;
  double soldQty = 0; // use during showing top 5 sold products on dashboard

  Product() {
    //productTaxList = [];
    productPriceList = [];
  }

  Product.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    productCode = map['productCode'];
    unitCombinationId = map['unitCombinationId'];
    supplierProductCode = map['supplierProductCode'];
    name = map['name'];
    type = map['type'];
    description = map['description'];
    hsnCode = map['hsnCode'];
    productTypeId = map['productTypeId'];
    unitPrice = map['unitPrice'].toDouble();
    imagePath = map['imagePath'];
    isActive = map['isActive'] == 'true' ? true : false;
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    productTypeName = map['typeName'];
    businessId = map['businessId'];
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj = {
      'id': id,
      'productCode': productCode,
      'unitCombinationId': unitCombinationId,
      'supplierProductCode': supplierProductCode,
      'name': name,
      'type': type,
      'hsnCode': hsnCode,
      'description': description,
      'productTypeId': productTypeId,
      'unitPrice': unitPrice,
      'imagePath': imagePath,
      'isActive': isActive.toString(),
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
