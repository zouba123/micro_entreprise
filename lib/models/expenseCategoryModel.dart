// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators
class ExpenseCategory {
  int id;
  String name;
  String description;
  bool isActive;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  int businessId;
  bool isMaster;
  int parentCategoryId;
  bool hasLeaf;

  ExpenseCategory();

  ExpenseCategory.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    parentCategoryId = map['parentCategoryId'];
    hasLeaf = map['parentCategoryId'] != null ? true : false;
    name = map['name'];
    description = map['description'];
    isActive = map['isActive'] == 'true' ? true : false;
    isDelete = map['isDelete'] == 'true' ? true : false;
    isMaster = map['isMaster'] == 'isMaster' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    businessId = map['businessId'];
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj = {'id': id, 'parentCategoryId': parentCategoryId, 'name': name, 'description': description, 'isActive': isActive.toString(), 'isDelete': isDelete.toString(), 'isMaster': isMaster.toString(), 'modifiedAt': modifiedAt.toString(), 'businessId ': businessId};
    if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }
    return _obj;
  }
}
