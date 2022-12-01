// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
class ProductPrice {
  int id;
  int productId;
  double price;
  int quantity;
  int unitId;
  bool isDefault = false;
  DateTime createdAt;
  DateTime modifiedAt;
  int businessId;
  String unitCode;

  ProductPrice(this.id, this.productId, this.price, this.quantity, this.unitId);

  ProductPrice.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    productId = map['productId'];
  
    price = map['price'].toDouble();
    quantity = map['quantity'];
    unitId = map['unitId'];
    isDefault = map['isDefault'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    businessId = map['businessId'];
    unitCode = map['code'];
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj =  {'id': id, 'productId': productId,  'price': price, 'quantity': quantity, 'unitId': unitId, 'isDefault': isDefault.toString(), 'modifiedAt': modifiedAt.toString(), 'businessId ': businessId};
     if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }
    return _obj;
  }
}
