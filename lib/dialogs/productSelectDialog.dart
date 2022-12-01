// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/unitCombinationModel.dart';
import 'package:accounting_app/models/unitModel.dart';
import 'package:accounting_app/screens/productAddScreen.dart';
import 'package:flutter/material.dart';

class ProductSelectDialog extends Base {
  final int returnScreenId;
  final List<Product> selectedProducts;
  final ValueChanged<List<Product>> onValueSelected;
  ProductSelectDialog({@required a, @required o, @required this.returnScreenId, @required this.onValueSelected, this.selectedProducts}) : super(analytics: a, observer: o);
  @override
  _ProductSelectDialogState createState() => _ProductSelectDialogState(this.returnScreenId, this.selectedProducts, this.onValueSelected);
}

class _ProductSelectDialogState extends BaseState {
  int returnScreenId;
  List<Product> _productList;
  List<Product> _mainList = [];
//List<Product> _tempProductList = [];
  final List<Product> selectedProducts;
  final ValueChanged<List<Product>> onValueSelected;
  bool _isDataLoaded = false;

  _ProductSelectDialogState(this.returnScreenId, this.selectedProducts, this.onValueSelected) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_choose_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_choose_service'] : global.appLocaleValues['tle_choose_both']}',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: <Widget>[
          (returnScreenId == 1)
              ? SizedBox()
              : IconButton(
                  icon: Icon(Icons.add),
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: () async {
                    // Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductAddSreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  product: Product(),
                                  screenId: 1,
                                ))).then((v) {
                      setState(() {
                        if (v != null && v.isActive == true) {
                          _productList.add(v);
                          _mainList.add(v);
                        }
                      });
                    });
                  },
                ),
        ],
      ),
      body: (_isDataLoaded)
          ? Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_search_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_search_service'] : global.appLocaleValues['lbl_search_both']}',
                        style: Theme.of(context).primaryTextTheme.headline3,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) async {
                      _searchProducts(value);
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        hintText: '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_search_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_search_service'] : global.appLocaleValues['lbl_search_both']}'),
                  ),
                ),
                (_productList.length > 0)
                    ? Expanded(
                        child: Scrollbar(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom:60),
                            child: ListView.builder(
                              itemCount: _productList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    (index == 0) ? Divider() : SizedBox(),
                                    (returnScreenId == 0)
                                        ? CheckboxListTile(
                                            title: (br.getSystemFlagValue(global.systemFlagNameList.useProductSupplierCode) == 'true' && _productList[index].supplierProductCode != '')
                                                ? Text(
                                                    (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") ? '${_productList[index].supplierProductCode} ${_productList[index].name}   ${global.currency.symbol} ${_productList[index].productPriceList[0].price.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} / ${_productList[index].productPriceList[0].unitCode}' : '${_productList[index].supplierProductCode} ${_productList[index].name}   ${global.currency.symbol} ${_productList[index].productPriceList[0].price.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                  )
                                                : Row(
                                                    children: [
                                                      Text((br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                                          ? '${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + _productList[index].productCode.toString().length))}${_productList[index].productCode} ${_productList[index].name}   ${global.currency.symbol} ${_productList[index].productPriceList[0].price.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} / ${_productList[index].productPriceList[0].unitCode}'
                                                          : '${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + _productList[index].productCode.toString().length))}${_productList[index].productCode} ${_productList[index].name}   ${global.currency.symbol} ${_productList[index].productPriceList[0].price.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'),
                                                    ],
                                                  ),
                                            subtitle: Text('${_productList[index].productTypeName}'),
                                            value: _productList[index].isSelect,
                                            onChanged: (v) {
                                              if (returnScreenId == 0) {
                                                _productList[index].isSelect = v;
                                                _mainList.map((f) {
                                                  if (f.id == _productList[index].id) {
                                                    f.isSelect = v;
                                                  }
                                                }).toList();
                                              }
                                              setState(() {});
                                            },
                                          )
                                        : ListTile(
                                            title: Text('${_productList[index].name}'),
                                            subtitle: Text('${_productList[index].productTypeName}'),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  '${global.currency.symbol} ${_productList[index].productPriceList[0].price.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                                    ? Text(
                                                        ' / ${_productList[index].productPriceList[0].unitCode}',
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      )
                                                    : SizedBox()
                                              ],
                                            ),
                                            onTap: () {
                                              onValueSelected([_productList[index]]);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                    Divider()
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['txt_no_pro_found'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['txt_no_ser_found'] : global.appLocaleValues['txt_no_both_found']}',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
      bottomSheet: (_isDataLoaded)
          ? Container(
             color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FittedBox(
                            child: Text(
                              '${global.appLocaleValues['btn_select']}',
                              style: Theme.of(context).primaryTextTheme.headline2,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        List<Product> _product = [];
                        List<Unit> _unitList = [];
                        List<UnitCombination> _unitCombinationList = [];
                        if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
                          _unitList = await dbHelper.unitGetList();
                          _unitCombinationList = await dbHelper.unitCombinationGetList();
                        }
                        _mainList.forEach((item) {
                          if (item.isSelect) {
                            _product.add(item);
                          }
                        });
                        if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
                          _product.forEach((ele) {
                            UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == ele.unitCombinationId);
                            ele.unitList.add(_unitList.firstWhere((element) => element.id == _unitCombination.primaryUnitId));
                            if (_unitCombination.secondaryUnitId != null) {
                              ele.unitList.add(_unitList.firstWhere((element) => element.id == _unitCombination.secondaryUnitId));
                            }
                          });
                        }
                        int _a = 0;
                        _a = _productList.where((element) => element.isSelect).toList().length;
                        if (_a > 0) {
                          onValueSelected(_product);
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
          )
          : SizedBox(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _productList = [];
    _getData();
  }

  Future _getData() async {
    try {
      await _getProducts();
    } catch (e) {
      print('Exception - productSelectDialog.dart - _getData(): ' + e.toString());
    }
  }

  Future _getProducts() async {
    try {
      _mainList = await dbHelper.productGetList(isActive: true, isDelete: false);
      if (selectedProducts != null) {
        selectedProducts.forEach((element) {
          _mainList.removeWhere((e) => e.id == element.id);
        });
      }
      for (int i = 0; i < _mainList.length; i++) {
        _mainList[i].productPriceList = await dbHelper.productPriceGetList(_mainList[i].id);
      }
      _productList = _mainList.map((f) => f).toList();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - productSelectDialog.dart - _getProducts(): ' + e.toString());
    }
  }

  void _searchProducts(String query) {
    try {
      _productList.clear();
      if (query.length > 0) {
        _mainList.forEach((f) {
          if (f.name.contains(query) || f.supplierProductCode.contains(query) || f.productTypeName.contains(query) || f.unitPrice.toString().contains(query)) {
            _productList.add(f);
          }
        });
      } else {
        _productList = _mainList.map((f) => f).toList();
      }
    } catch (e) {
      print('Exception - productSelectDialog.dart - _searchProducts(): ' + e.toString());
    }
  }
}
