// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/dialogs/selectTaxPercentageDialog.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/decimalTextInputFormatter.dart';
import 'package:accounting_app/models/productTypeModel.dart';
import 'package:accounting_app/models/productTypeTaxModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/models/taxMasterPercentageModel.dart';
import 'package:accounting_app/screens/productTypeScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;

class ProductTypeAddSreen extends BaseRoute {
  final ProductType productType;
  final int screenId;
  ProductTypeAddSreen({@required a, @required o, @required this.screenId, this.productType}) : super(a: a, o: o, r: 'ProductTypeAddSreen');
  @override
  _ProductTypeAddSreenState createState() => _ProductTypeAddSreenState(this.productType, this.screenId);
}

class _ProductTypeAddSreenState extends BaseRouteState {
  ProductType productType;
  int screenId;
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isTaxAddedAlready = true;
  TextEditingController _cName = TextEditingController();
  TextEditingController _cDescription = TextEditingController();
  List<TextEditingController> _cTextEditingControllerList = [];
  bool _autovalidate = false;
  var _fName = FocusNode();
  var _fDescription = FocusNode();
  bool _typeIsExist = false;
  List<TaxMaster> _taxList = [];
  List<TaxMasterPercentage> _taxMasterPercentageList = [];

  _ProductTypeAddSreenState(this.productType, this.screenId) : super();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: productType.id == null
              ? Text(
                  '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_add_product_cat'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_add_service_cat'] : global.appLocaleValues['tle_add_both_cat']}',
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                )
              : Text(
                  '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_update_product_cat'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_update_service_cat'] : global.appLocaleValues['tle_update_both_cat']}',
                  style: Theme.of(context).appBarTheme.titleTextStyle),
          actions: <Widget>[
            TextButton(
              child: Text(
                global.appLocaleValues['btn_save'],
                style: Theme.of(context).primaryTextTheme.headline2,
              ),
              onPressed: () async {
                await _onSubmit();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_cat'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_cat'] : global.appLocaleValues['lbl_both_cat']}',
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 10),
                        child: TextFormField(
                          controller: _cName,
                          focusNode: _fName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(_fDescription);
                          },
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.star,
                                size: 9,
                                color: Colors.red,
                              ),
                              border: nativeTheme().inputDecorationTheme.border,
                              hintText:
                                  '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_cat'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_cat'] : global.appLocaleValues['lbl_both_cat']}',
                              // labelText: '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_cat'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_cat'] : global.appLocaleValues['lbl_both_cat']}',
                              errorText: _typeIsExist
                                  ? '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_cat_err_vld'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_cat_err_vld'] : global.appLocaleValues['lbl_both_cat_err_vld']}'
                                  : null),
                          onChanged: (value) async {
                            await _productTypeIsExist(value);
                          },
                          validator: (v) {
                            if (v.isEmpty) {
                              return '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_cat_err_req'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_cat_err_req'] : global.appLocaleValues['lbl_both_cat_err_req']}';
                            } else if (v.contains(RegExp('[0-9]'))) {
                              return global.appLocaleValues['vel_character_only'];
                            } else if (_typeIsExist == true) {
                              return '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_cat_err_vld'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_cat_err_vld'] : global.appLocaleValues['lbl_both_cat_err_vld']}';
                            }
                            return null;
                          },
                        ),
                      ),
                      Text(
                        '${global.appLocaleValues['lbl_desc']} (${global.appLocaleValues['lbl_optional']})',
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          controller: _cDescription,
                          focusNode: _fDescription,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: global.appLocaleValues['lbl_desc'],
                            border: nativeTheme().inputDecorationTheme.border,
                            alignLabelWithHint: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                (productType.productTypeTaxList != null)
                    ? (productType.productTypeTaxList.length != 0)
                        ? Column(
                            children: <Widget>[
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      global.appLocaleValues['tle_tax'],
                                      style: TextStyle(color: Colors.grey, fontSize: 15),
                                    ),
                                    (productType.productTypeTaxList != null)
                                        ? ListView.builder(
                                            itemCount: productType.productTypeTaxList.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      '${productType.productTypeTaxList[index].taxName}',
                                                      style: TextStyle(color: Colors.grey, fontSize: 17),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                    padding: EdgeInsets.only(top: 10),
                                                    child: TextFormField(
                                                      readOnly: true,
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                      inputFormatters:
                                                          (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                                                      onChanged: (value) {
                                                        productType.productTypeTaxList[index].percentage = double.parse(value);
                                                      },
                                                      controller: _cTextEditingControllerList[index],
                                                      validator: (value) {
                                                        if (value.isEmpty) {
                                                          return global.appLocaleValues['lbl_tax_err_req'];
                                                        } else if (value.contains(RegExp('[a-zA-Z]'))) {
                                                          return global.appLocaleValues['vel_enter_number_only'];
                                                        }
                                                        return null;
                                                      },
                                                      onTap: () async {
                                                        await _editTax(index);
                                                      },
                                                      decoration: InputDecoration(
                                                        border: nativeTheme().inputDecorationTheme.border,
                                                        hintStyle: TextStyle(color: Colors.black),
                                                      ),
                                                    ),
                                                  ))
                                                ],
                                              );
                                            })
                                        : Center(
                                            child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10,
                                              ),
                                              FittedBox(
                                                child: Text(
                                                  global.appLocaleValues['txt_tax'],
                                                  style: TextStyle(color: Colors.grey, fontSize: 18),
                                                ),
                                              )
                                            ],
                                          ))
                                  ],
                                ),
                              ),
                            ],
                          )
                        : SizedBox()
                    : SizedBox(),
                (!_isTaxAddedAlready && productType.productTypeTaxList.length > 0)
                    ? Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          '${global.appLocaleValues['txt_tax_warning']}',
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        ),
                      )
                    : SizedBox(),
              ])),
        ));
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      if (productType != null) {
        await _filldata();
        if (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
          await _getTaxPercentages();
        }
      } else {
        productType = ProductType();
        if (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
          await _getTaxList();
          await _getTaxPercentages();
        }
      }
    } catch (e) {
      print('Exception - productTypeAddScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _filldata() async {
    try {
      _cName.text = productType.name;
      _cDescription.text = productType.description;
      productType.productTypeTaxList = await dbHelper.productTypeTaxGetList(productTypeId: productType.id);
      if (productType.productTypeTaxList.length == 0 && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
        await _getTaxList();
        _isTaxAddedAlready = false;
      } else {
        productType.productTypeTaxList.forEach((item) {
          _cTextEditingControllerList.add(TextEditingController(text: item.percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))));
        });
      }
      setState(() {});
    } catch (e) {
      print('Exception - productTypeAddScreen.dart - _filldata(): ' + e.toString());
    }
  }

  Future _onSubmit() async {
    try {
      if (_formKey.currentState.validate()) {
        showLoader(global.appLocaleValues['txt_wait']);
        setState(() {});
        productType.name = _cName.text.trim();
        productType.description = _cDescription.text.trim();
        if (productType.id == null) {
          productType.id = await dbHelper.productTypeInsert(productType);
        } else {
          bool _taxChangesApplyOnProducts = false;
          if (productType.productTypeTaxList.length != 0 && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
            AlertDialog _dialog = AlertDialog(
              shape: nativeTheme().dialogTheme.shape,
              title: Text(
                global.appLocaleValues['tle_tax_changes'],
                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              ),
              content: Text(
                  '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_tax_changes_product_desc'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_tax_changes_service_desc'] : global.appLocaleValues['tle_tax_changes_both_desc']}'),
              actions: <Widget>[
                TextButton(
                  // textColor: Theme.of(context).primaryColor,
                  child: Text(global.appLocaleValues['btn_no']),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                TextButton(
                  // textColor: Theme.of(context).primaryColor,
                  child: Text(global.appLocaleValues['btn_yes']),
                  onPressed: () {
                    _taxChangesApplyOnProducts = true;
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
            await showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
          }
          await dbHelper.productTypeUpdate(productType, _taxChangesApplyOnProducts, _isTaxAddedAlready);
        }
        hideLoader();
        setState(() {});
        if (screenId == 0) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductTypeScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )));
        } else if (screenId == 1) {
          Navigator.of(context).pop(productType);
        }
      } else {
        _autovalidate = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - productTypeAddScreen.dart - _onSubmit(): ' + e.toString());
    }
  }

  Future _productTypeIsExist(value) async {
    try {
      _typeIsExist = productType.id != null ? await dbHelper.productTypeCheckTypeExist(productTypeName: value, productTypeId: productType.id) : await dbHelper.productTypeCheckTypeExist(productTypeName: value);
      setState(() {});
    } catch (e) {
      print('Exception - productTypeAddScreen.dart - _productTypeIsExist(): ' + e.toString());
    }
  }

  Future _getTaxList() async {
    _taxList = await dbHelper.taxMasterGetList(isActive: true, isApplyPerProduct: true);
    for (int i = 0; i < _taxList.length; i++) {
      ProductTypeTax _productTypeTax = ProductTypeTax(null, null, _taxList[i].id, _taxList[i].percentage, _taxList[i].taxName);
      _productTypeTax.groupName = _taxList[i].groupName;
      productType.productTypeTaxList.add(_productTypeTax);
      _cTextEditingControllerList.add(TextEditingController(text: '${_taxList[i].percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'));
    }
    setState(() {});
  }

  Future _getTaxPercentages() async {
    try {
      _taxMasterPercentageList = await dbHelper.taxMasterPercentageGetList();
    } catch (e) {
      print('Exception - productTypeAddScreen.dart - _getTaxPercentages(): ' + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _editTax(index) async {
    try {
      List<TaxMasterPercentage> _tempList = _taxMasterPercentageList.where((element) => element.taxId == productType.productTypeTaxList[index].taxMasterId).toList();
      await showDialog(
          context: context,
          builder: (_) {
            return SelectTaxPercentageDialog(
              a: widget.analytics,
              o: widget.observer,
              percentageList: _tempList,
            );
          }).then((value) {
        if (value != null) {
          for (int i = 0; i < productType.productTypeTaxList.length; i++) {
            if (productType.productTypeTaxList[index].groupName == productType.productTypeTaxList[i].groupName) {
              productType.productTypeTaxList[i].percentage = value;
            }
            _cTextEditingControllerList[i].text = '${productType.productTypeTaxList[i].percentage}';
          }
          setState(() {});
        }
      });
    } catch (e) {
      print('Exception - productTypeAddScreen.dart - _editTax(): ' + e.toString());
    }
  }
}
