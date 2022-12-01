
// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
class ProductTax {
  int id;
  int productId;
  int taxMasterId;
  double percentage;
  DateTime createdAt;
  DateTime modifiedAt;
  String taxName;
  String taxGroupName;
  int businessId;

  ProductTax(this.id, this.productId, this.taxMasterId, this.percentage, this.taxName);

  ProductTax.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    productId = map['productId'];
    taxMasterId = map['taxMasterId'];
    percentage =  map['percentage'].toDouble();
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    taxName = map['taxName'];
    taxGroupName = map['groupName'];
    businessId = map['businessId'];
  }
    Map<String, dynamic> toMap(bool _isInsert) {
     var _obj = {
        'id': id,
        'productId': productId,
        'taxMasterId': taxMasterId,
        'percentage': percentage,
      
        'modifiedAt': modifiedAt.toString(),
        'businessId ': businessId
      };
       if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }
    return _obj;
    }
  }

