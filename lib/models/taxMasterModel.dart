// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:flutter/material.dart';

class TaxMaster {
  int id;
  String taxName;
  double percentage;
  int applyOrder;
  String description;
  bool isApplyOnProduct;
  String groupName;
  bool isActive;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  int businessId;
  double taxAmount = 0; // used during sale invoice return add/edit
  TextEditingController controller = TextEditingController();

  TaxMaster();

  TaxMaster.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    taxName = map['taxName'];
    percentage = map['percentage'].toDouble();
    groupName = map['groupName'];
    applyOrder = map['applyOrder'];
    description = (map['description'] != null) ? map['description'] : '';
    isApplyOnProduct = map['isApplyOnProduct'] == 'true' ? true : false;
    isActive = map['isActive'] == 'true' ? true : false;
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    businessId = map['businessId'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'taxName': taxName, 'groupName': groupName, 'percentage': percentage, 'applyOrder': applyOrder, 'description': description, 'isApplyOnProduct': isApplyOnProduct.toString(), 'isActive': isActive.toString(), 'isDelete': isDelete.toString(), 'createdAt': createdAt.toString(), 'modifiedAt': modifiedAt.toString(), 'businessId ': businessId};
  }
}
