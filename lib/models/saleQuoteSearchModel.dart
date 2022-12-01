// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/productModel.dart';

class SaleQuoteSearch{
  Account account =  Account();
  Product product =  Product();
  double amountFrom;
  double amountTo;
  DateTime dateFrom;
  DateTime dateTo;
  bool isSearch;
  String status;
  bool isWithTax;
}