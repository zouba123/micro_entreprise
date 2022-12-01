// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
import 'package:accounting_app/models/productTypeModel.dart';

class TopSellingProductReportFilterModel {
  DateTime dateFrom;
  DateTime dateTo;
  ProductType productType;
  bool isActive;
  int totalSoldQtyFrom;
  int totalSoldQtyTo;
  double totalSoldAmountFrom;
  double totalSoldAmountTo;
  double productPriceFrom;
  double productPriceTo;

  TopSellingProductReportFilterModel();

  TopSellingProductReportFilterModel copyFrom(TopSellingProductReportFilterModel _obj) {
    TopSellingProductReportFilterModel _newObj = TopSellingProductReportFilterModel();
    _newObj.dateFrom = _obj.dateFrom;
    _newObj.dateTo = _obj.dateTo;
    _newObj.productType = _obj.productType;
    _newObj.isActive = _obj.isActive;
    _newObj.totalSoldQtyFrom = _obj.totalSoldQtyFrom;
    _newObj.totalSoldQtyTo = _obj.totalSoldQtyTo;
    _newObj.totalSoldAmountFrom = _obj.totalSoldAmountFrom;
    _newObj.totalSoldAmountTo = _obj.totalSoldAmountTo;
    _newObj.productPriceFrom = _obj.productPriceFrom;
    _newObj.productPriceTo = _obj.productPriceTo;
    return _newObj;
  }
}
