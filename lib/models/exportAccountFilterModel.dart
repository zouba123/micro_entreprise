// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators

class ExportAccountFilterModel {
  // int saleInvoiceId;
  DateTime registrationDateFrom;
  DateTime registrationDateTo;
  String pincode;

  ExportAccountFilterModel();

  ExportAccountFilterModel copyFrom(ExportAccountFilterModel _obj) {
    ExportAccountFilterModel _newObj = ExportAccountFilterModel();
    _newObj.registrationDateFrom = _obj.registrationDateFrom;
    _newObj.registrationDateTo = _obj.registrationDateTo;
    _newObj.pincode = _obj.pincode;
    return _newObj;
  }
}
