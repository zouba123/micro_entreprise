// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
class ProductGeneralReportModel {
  int productId;
  String productName;
  int productCode;
  String productHsnCode;
  String productTypeName;
  double productPrice;
  String productDescription;

  ProductGeneralReportModel();

  ProductGeneralReportModel.fromMap(Map<String, dynamic> map) {
    try {
      productId =  map['id'];
      productName = (map['name'] != null) ? map['name'] : '';
      productCode = (map['productCode'] != null) ? int.parse(map['productCode'].toString()) : 0;
      productHsnCode = (map['hsnCode'] != null) ? map['hsnCode'] : '';
      productTypeName = (map['typeName'] != null) ? map['typeName'] : '';
      productPrice = (map['price'] != null) ? double.parse(map['price'].toString()) : 0;
      productDescription = (map['description'] != null) ? map['description'] : '';
    } catch (e) {
      print('Exception - ProductGeneralReportModel.dart - fromMap(): ' + e.toString());
    }
  }
}
