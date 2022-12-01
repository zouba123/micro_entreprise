// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
class SystemFlag {
  int id;
  String name;
  String value;
  String defaultValue;
  String valueList;
  String description;
  String lable;
  bool isActive;
  bool isDelete;
  String createdAt;
  String modifiedAt;
  int businessId;

  SystemFlag(this.id, this.name, this.value, this.defaultValue, this.valueList, this.description, this.isActive, this.isDelete, this.createdAt, this.modifiedAt);

  SystemFlag.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    value = map['value'];
    defaultValue = map['defaultValue'];
    lable = map['lable'];
    valueList = map['valueList'];
    description = map['description'];
    isActive = map['isActive'] == 'true' ? true : false;
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = map['createdAt'];
    modifiedAt = map['modifiedAt'];
    businessId = map['businessId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'defaultValue': defaultValue,
      'lable': lable,
      'valueList': valueList,
      'description': description,
      'isActive': isActive,
      'isDelete': isDelete,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
      'businessId ': businessId
    };
  }
}
