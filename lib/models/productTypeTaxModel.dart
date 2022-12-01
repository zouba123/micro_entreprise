// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
class ProductTypeTax {
  int id;
  int productTypeId;
  int taxMasterId;
  double percentage;
  DateTime createdAt;
  DateTime modifiedAt;
  String taxName;
  String groupName;
  int businessId;

  ProductTypeTax(this.id, this.productTypeId, this.taxMasterId, this.percentage, this.taxName);

  ProductTypeTax.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    productTypeId = map['productTypeId'];
    taxMasterId = map['taxMasterId'];
    percentage = map['percentage'].toDouble();
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    taxName = map['taxName'];
    groupName = map['groupName'];
    businessId = map['businessId'];
  }
  Map<String, dynamic> toMap() {
    return {'id': id, 'productTypeId': productTypeId, 'taxMasterId': taxMasterId, 'percentage': percentage, 'createdAt': createdAt.toString(), 'modifiedAt': modifiedAt.toString(), 'businessId ': businessId};
  }
}
