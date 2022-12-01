// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
class SaleInvoiceTax {
  int id;
  int invoiceId;
  int taxId;
  double percentage;
  double totalAmount;
  DateTime createdAt;
  DateTime modifiedAt;
  String taxName;
  int businessId;

  SaleInvoiceTax(this.id, this.invoiceId, this.taxId, this.percentage, this.totalAmount);

  SaleInvoiceTax.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    invoiceId = map['invoiceId'];
    taxId = map['taxId'];
    percentage = map['percentage'].toDouble();
    totalAmount = map['totalAmount'].toDouble();
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    taxName = map['taxName'];
    businessId = map['businessId'];
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj =  {
      'id': id,
      'invoiceId': invoiceId,
      'taxId': taxId,
      'percentage': percentage,
      'totalAmount': totalAmount,
      
      'modifiedAt': modifiedAt.toString(),
      'businessId ': businessId
    };

if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }
    return _obj;
  }
}
