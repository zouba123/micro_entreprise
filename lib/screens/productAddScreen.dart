// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:accounting_app/dialogs/productTypeSelectDialog.dart';
import 'package:accounting_app/dialogs/selectTaxPercentageDialog.dart';
import 'package:accounting_app/dialogs/selectUnitDialog.dart';
import 'package:accounting_app/dialogs/unitCombinationSelectDialog.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/decimalTextInputFormatter.dart';
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/productPriceModel.dart';
import 'package:accounting_app/models/productTaxModel.dart';
import 'package:accounting_app/models/productTypeModel.dart';
import 'package:accounting_app/models/productTypeTaxModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/models/taxMasterPercentageModel.dart';
import 'package:accounting_app/models/unitCombinationModel.dart';
import 'package:accounting_app/models/unitModel.dart';
import 'package:accounting_app/screens/productScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';

class ProductAddSreen extends BaseRoute {
  final Product product;
  final int screenId;
  ProductAddSreen({@required a, @required o, @required this.screenId, this.product}) : super(a: a, o: o, r: 'ProductAddSreen');
  @override
  _ProductAddSreenState createState() => _ProductAddSreenState(this.product, this.screenId);
}

class _ProductAddSreenState extends BaseRouteState {
  Product product;
  final int screenId;
  TextEditingController _cName = TextEditingController();
  TextEditingController _cSupplierProductCode = TextEditingController();
  TextEditingController _cDescription = TextEditingController();
  TextEditingController _cTypeName = TextEditingController();
  TextEditingController _cProductTypeId = TextEditingController();
  TextEditingController _cUnitPrice = TextEditingController();
  TextEditingController _cProductCode = TextEditingController();
  TextEditingController _cHsnCode = TextEditingController();
  TextEditingController _cUnitCombination = TextEditingController();
  TextEditingController _cUnit = TextEditingController();
  List<String> _businessInventoryList;
  File _image;
  bool _autovalidate = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String _imagePath = '';
  final _fName = FocusNode();
  final _fSupplierProductCode = FocusNode();
  final _fDescription = FocusNode();
  final _fHsnCode = FocusNode();
  final _fProductTypeId = FocusNode();
  final _fUnitPrice = FocusNode();
  bool _isActive = true;
  var _key = GlobalKey<FormState>();
  bool _nameIsExist = false;
  int _generatedProductCode;
  ProductType _productType;
  bool _isTaxLoaded = false;
  List<TaxMaster> _taxList = [];
  List<TaxMasterPercentage> _taxMasterPercentageList = [];
  List<TextEditingController> _cTextEditingControllerList = [];
  bool _isTaxAddedAlready = true;
  List<UnitCombination> _unitCombinationList = [];
  List<Unit> _unitList = [];
  List<Unit> _respectedUnit = [];
  bool _isDataLoaded = false;
  bool _productUsed = false;

  _ProductAddSreenState(this.product, this.screenId) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: product.id != null
            ? Text(
                (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product')
                    ? global.appLocaleValues['tle_update_product']
                    : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service')
                        ? global.appLocaleValues['tle_update_service']
                        : global.appLocaleValues['tle_update_both'],
                style: Theme.of(context).appBarTheme.titleTextStyle)
            : Text(
                (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product')
                    ? global.appLocaleValues['tle_add_product']
                    : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service')
                        ? global.appLocaleValues['tle_add_service']
                        : global.appLocaleValues['tle_add_both'],
                style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await _onSubmit();
            },
            child: Text(global.appLocaleValues['btn_save'], style: Theme.of(context).primaryTextTheme.headline2),
          )
        ],
      ),
      body: (_isDataLoaded)
          ? WillPopScope(
              onWillPop: () {
                if (screenId == 0) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => ProductScreen(
                            a: widget.analytics,
                            o: widget.observer,
                          )));
                } else {
                  Navigator.of(context).pop();
                }
                return null;
              },
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Form(
                    key: _key,
                    autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                    child: Stack(
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.grey[50],
                                          foregroundColor: Theme.of(context).primaryColorLight,
                                          radius: 70,
                                          child: ClipOval(
                                            child: (_imagePath != '')
                                                ? Image.file(File(_imagePath))
                                                : Icon(
                                                    Icons.local_mall,
                                                    size: 110,
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 100, top: 80),
                                          child: FloatingActionButton(
                                            backgroundColor: Colors.grey[50],
                                            child: Icon(
                                              Icons.add_a_photo,
                                              size: 25,
                                              color: Theme.of(context).primaryColorLight,
                                            ),
                                            onPressed: () async {
                                              await _openUploadPicOptions(context);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Both')
                                    ? TextFormField(
                                        controller: _cTypeName,
                                        decoration: InputDecoration(
                                          border: nativeTheme().inputDecorationTheme.border,
                                          hintText: global.appLocaleValues['lbl_type_name'],
                                          labelText: global.appLocaleValues['lbl_type_name'],
                                          suffixIcon: Icon(
                                            Icons.star,
                                            size: 9,
                                            color: Colors.red,
                                          ),
                                        ),
                                        readOnly: true,
                                        onTap: () => _selectTypeName(),
                                      )
                                    : SizedBox(),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_name'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_name'] : global.appLocaleValues['lbl_both_name']}',
                                        style: Theme.of(context).primaryTextTheme.headline3)),
                                Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 10),
                                  child: TextFormField(
                                    controller: _cName,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      errorText: _nameIsExist
                                          ? '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_name_err_vld'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_name_err_vld'] : global.appLocaleValues['lbl_both_name_err_vld']}'
                                          : null,
                                      border: nativeTheme().inputDecorationTheme.border,
                                      hintText:
                                          '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_name'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_name'] : global.appLocaleValues['lbl_both_name']}',
                                      suffixIcon: Icon(
                                        Icons.star,
                                        size: 9,
                                        color: Colors.red,
                                      ),
                                    ),
                                    textCapitalization: TextCapitalization.sentences,
                                    keyboardType: TextInputType.text,
                                    onChanged: (String value) {
                                      _checkNameExist(value);
                                    },
                                    focusNode: _fName,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context).requestFocus(_fProductTypeId);
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_name_err_req'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_name_err_req'] : global.appLocaleValues['lbl_both_name_err_req']}';
                                      }
                                      // else if (value.contains(RegExp('[0-9]'))) {
                                      //   return global.appLocaleValues['vel_character_only'];
                                      // }
                                      else if (_nameIsExist == true) {
                                        return '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_name_err_vld'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_name_err_vld'] : global.appLocaleValues['lbl_both_name_err_vld']}';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_category'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_category'] : global.appLocaleValues['lbl_both_category']}',
                                        style: Theme.of(context).primaryTextTheme.headline3)),
                                Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 10),
                                  child: TextFormField(
                                    controller: _cProductTypeId,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText:
                                          '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_category'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_category'] : global.appLocaleValues['lbl_both_category']}',
                                      border: nativeTheme().inputDecorationTheme.border,
                                      suffixIcon: Icon(
                                        Icons.star,
                                        size: 9,
                                        color: Colors.red,
                                      ),
                                    ),
                                    textCapitalization: TextCapitalization.sentences,
                                    keyboardType: TextInputType.text,
                                    focusNode: _fProductTypeId,
                                    readOnly: true,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context).requestFocus(_fUnitPrice);
                                    },
                                    validator: (v) {
                                      if (v.isEmpty) {
                                        return '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_category_err_req'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_category_err_req'] : global.appLocaleValues['lbl_both_category_err_req']}';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") ? Align(alignment: Alignment.centerLeft, child: Text(global.appLocaleValues['lbl_unit_combintion'], style: Theme.of(context).primaryTextTheme.headline3)) : SizedBox(),
                                (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 5, bottom: 10),
                                        child: TextFormField(
                                          controller: _cUnitCombination,
                                          decoration: InputDecoration(
                                            border: nativeTheme().inputDecorationTheme.border,
                                            suffixIcon: Icon(
                                              Icons.star,
                                              size: 9,
                                              color: Colors.red,
                                            ),
                                          ),
                                          readOnly: true,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return global.appLocaleValues['lbl_unit_com_err_req'];
                                            }
                                            return null;
                                          },
                                          onTap: () async {
                                            await _selectCombination();
                                          },
                                        ),
                                      )
                                    : SizedBox(),
                                (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 0.0),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(global.appLocaleValues['lbl_unit_price'], style: Theme.of(context).primaryTextTheme.headline3),
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 5.0),
                                                        child: Container(
                                                          width: 160,
                                                          child: TextFormField(
                                                              controller: _cUnitPrice,
                                                              textInputAction: TextInputAction.next,
                                                              inputFormatters:
                                                                  (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                                                              maxLength: 6,
                                                              decoration: InputDecoration(
                                                                border: nativeTheme().inputDecorationTheme.border,
                                                                counterText: '',
                                                                hintText: global.appLocaleValues['lbl_unit_price'],
                                                                suffixIcon: Icon(
                                                                  Icons.star,
                                                                  size: 9,
                                                                  color: Colors.red,
                                                                ),
                                                              ),
                                                              textCapitalization: TextCapitalization.sentences,
                                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                              focusNode: _fUnitPrice,
                                                              validator: (v) {
                                                                if (v.isEmpty) {
                                                                  return global.appLocaleValues['lbl_unit_price_err_req'];
                                                                } else if (v.contains(RegExp('[a-zA-Z]'))) {
                                                                  return global.appLocaleValues['vel_enter_number_only'];
                                                                }
                                                                return null;
                                                              },
                                                              onChanged: (value) {
                                                                product.productPriceList[0].price = double.parse(value);
                                                                setState(() {});
                                                              },
                                                              onFieldSubmitted: (v) {
                                                                FocusScope.of(context)
                                                                    .requestFocus((br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service' && br.getSystemFlagValue(global.systemFlagNameList.useProductSupplierCode) == 'true') ? _fSupplierProductCode : _fDescription);
                                                              }),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  // Text('/',style: TextStyle(color: Colors.grey,fontSize: 30)),
                                                  // SizedBox(
                                                  //   width: 10,
                                                  // ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(global.appLocaleValues['lbl_unit'], style: Theme.of(context).primaryTextTheme.headline3),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 5.0),
                                                          child: TextFormField(
                                                            controller: _cUnit,
                                                            decoration: InputDecoration(
                                                              // labelText: global.appLocaleValues['lbl_unit'],
                                                              border: nativeTheme().inputDecorationTheme.border,
                                                              suffixIcon: Icon(
                                                                Icons.star,
                                                                size: 9,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                            readOnly: true,
                                                            validator: (value) {
                                                              if (value.isEmpty) {
                                                                return global.appLocaleValues['lbl_unit_err_req'];
                                                              }
                                                              return null;
                                                            },
                                                            onTap: () async {
                                                              await _selectUnit();
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            (_cUnit.text.isNotEmpty)
                                                ? Padding(
                                                    padding: const EdgeInsets.only(top: 3),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          ' 1 ${_cUnit.text} = ${global.currency.symbol} ${_cUnitPrice.text} ${global.appLocaleValues['lbl_without_tax']}',
                                                          style: TextStyle(color: Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Align(alignment: Alignment.centerLeft, child: Text(global.appLocaleValues['lbl_unit_price'], style: Theme.of(context).primaryTextTheme.headline3)),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: TextFormField(
                                                controller: _cUnitPrice,
                                                textInputAction: TextInputAction.next,
                                                inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                                                maxLength: 6,
                                                decoration: InputDecoration(
                                                  border: nativeTheme().inputDecorationTheme.border,
                                                  counterText: '',
                                                  hintText: global.appLocaleValues['lbl_unit_price'],
                                                  suffixIcon: Icon(
                                                    Icons.star,
                                                    size: 9,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                textCapitalization: TextCapitalization.sentences,
                                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                focusNode: _fUnitPrice,
                                                validator: (v) {
                                                  if (v.isEmpty) {
                                                    return global.appLocaleValues['lbl_unit_price_err_req'];
                                                  } else if (v.contains(RegExp('[a-zA-Z]'))) {
                                                    return global.appLocaleValues['vel_enter_number_only'];
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  product.productPriceList[0].price = double.parse(value);
                                                  setState(() {});
                                                },
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context).requestFocus((br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service' && br.getSystemFlagValue(global.systemFlagNameList.useProductSupplierCode) == 'true') ? _fSupplierProductCode : _fDescription);
                                                }),
                                          ),
                                        ],
                                      ),
                                (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service' && br.getSystemFlagValue(global.systemFlagNameList.useProductSupplierCode) == 'true')
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: TextFormField(
                                          controller: _cSupplierProductCode,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: global.appLocaleValues['lbl_product_supplier'],
                                            labelText: '${global.appLocaleValues['lbl_product_supplier']} (${global.appLocaleValues['lbl_optional']})',
                                            border: nativeTheme().inputDecorationTheme.border,
                                          ),
                                          focusNode: _fSupplierProductCode,
                                          onFieldSubmitted: (v) {
                                            FocusScope.of(context).requestFocus(_fHsnCode);
                                          },
                                        ),
                                      )
                                    : SizedBox(),
                                (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true')
                                    ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text('${global.appLocaleValues['lbl_hsn_code']} (${global.appLocaleValues['lbl_optional']})', style: Theme.of(context).primaryTextTheme.headline3),
                                        ),
                                      )
                                    : SizedBox(),
                                (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true')
                                    ? Padding(
                                        padding: EdgeInsets.only(bottom: 10, top: 5),
                                        child: TextFormField(
                                          controller: _cHsnCode,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: global.appLocaleValues['lbl_hsn_code'],
                                            // labelText: '${global.appLocaleValues['lbl_hsn_code']} (${global.appLocaleValues['lbl_optional']})',
                                            border: nativeTheme().inputDecorationTheme.border,
                                          ),
                                          focusNode: _fHsnCode,
                                          onFieldSubmitted: (v) {
                                            FocusScope.of(context).requestFocus(_fDescription);
                                          },
                                        ),
                                      )
                                    : SizedBox(),
                                Align(alignment: Alignment.centerLeft, child: Text('${global.appLocaleValues['lbl_desc']} (${global.appLocaleValues['lbl_optional']})', style: Theme.of(context).primaryTextTheme.headline3)),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: TextFormField(
                                    maxLines: 8,
                                    controller: _cDescription,
                                    focusNode: _fDescription,
                                    textCapitalization: TextCapitalization.sentences,
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
                          (product.productTaxList.length != 0) ? Divider() : SizedBox(),
                          (product.productTaxList.length != 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        global.appLocaleValues['tle_tax'],
                                        style: TextStyle(color: Colors.grey, fontSize: 15),
                                      ),
                                      (product.productTaxList.length != 0 && _isTaxLoaded == true)
                                          ? ListView.builder(
                                              itemCount: product.productTaxList.length,
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Text(
                                                      '${product.productTaxList[index].taxName}',
                                                      style: TextStyle(color: Colors.grey, fontSize: 17),
                                                    )),
                                                    Expanded(
                                                        child: Padding(
                                                      padding: const EdgeInsets.only(top: 10),
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                        onTap: () async {
                                                          await _editTax(index);
                                                        },
                                                        readOnly: true,
                                                        decoration: InputDecoration(
                                                          border: nativeTheme().inputDecorationTheme.border,
                                                        ),
                                                        controller: _cTextEditingControllerList[index],
                                                        inputFormatters:
                                                            (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                                                        onChanged: (value) {
                                                          product.productTaxList[index].percentage = double.parse(value);
                                                        },
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return global.appLocaleValues['lbl_tax_err_req'];
                                                          } else if (value.contains(RegExp('[a-zA-Z]'))) {
                                                            return global.appLocaleValues['vel_enter_number_only'];
                                                          }
                                                          return null;
                                                        },
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
                                )
                              : SizedBox(),
                          (!_isTaxAddedAlready && product.productTaxList.length > 0)
                              ? Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Text(
                                    '${global.appLocaleValues['txt_tax_warning']}',
                                    style: TextStyle(color: Colors.red, fontSize: 15),
                                  ),
                                )
                              : SizedBox(),
                          Divider(),
                          SizedBox(
                            height: 50,
                            child: ListTile(
                              leading: Text(global.appLocaleValues['lbl_active']),
                              trailing: Switch(
                                value: _isActive,
                                onChanged: (value) {
                                  setState(() {
                                    _isActive = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _fProductTypeId.removeListener(_focusListener);
    _fUnitPrice.removeListener(_unitPriceListener);
  }

  Future _getProductTaxes() async {
    try {
      product.productTaxList = await dbHelper.productTaxGetList(productIdList: [product.id]);
      _isTaxLoaded = true;
      if (product.productTaxList.length < 1) {
        await _getTaxList();
        _isTaxAddedAlready = false;
      } else {
        product.productTaxList.forEach((items) {
          _cTextEditingControllerList.add(TextEditingController(text: '${items.percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'));
        });
      }
      setState(() {});
    } catch (e) {
      print('Exception - productAddScreen.dart - _getProductTaxes(): ' + e.toString());
    }
  }

  Future _getTaxList() async {
    try {
      _taxList = await dbHelper.taxMasterGetList(isActive: true, isApplyPerProduct: true);
      for (int i = 0; i < _taxList.length; i++) {
        ProductTax _productTax = ProductTax(null, product.id, _taxList[i].id, _taxList[i].percentage, _taxList[i].taxName);
        _productTax.taxGroupName = _taxList[i].groupName;
        product.productTaxList.add(_productTax);
        _cTextEditingControllerList.add(TextEditingController(text: '${_taxList[i].percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'));
      }
      setState(() {});
    } catch (e) {
      print('Exception - productAddScreen.dart - _getTaxList(): ' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      _fProductTypeId.addListener(_focusListener);
      _fUnitPrice.addListener(_unitPriceListener);
      _businessInventoryList = br.getSystemFlag(global.systemFlagNameList.businessInventory).valueList.split(',');
      if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
        await _getUnitCombination();
        await _getUnits();
        _fetchUnitCode();
      }
      _taxMasterPercentageList = await dbHelper.taxMasterPercentageGetList();
      if (product.id == null) {
        await _getDefaultCategory();
        _generateProductCode();
        if (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == "Both") {
          _cTypeName.text = _businessInventoryList[0];
        } else {
          _cTypeName.text = br.getSystemFlagValue(global.systemFlagNameList.businessInventory);
        }
        UnitCombination _temp;
        if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
          _temp = _unitCombinationList.firstWhere((element) => element.id == int.parse(br.getSystemFlagValue(global.systemFlagNameList.defaultUnitCombination)));
          _respectedUnit.add(_unitList.firstWhere((element) => element.id == _temp.primaryUnitId));
          if (_temp.secondaryUnitId != null) {
            _respectedUnit.add(_unitList.firstWhere((element) => element.id == _temp.secondaryUnitId));
          }
          product.unitCombinationId = _temp.id;
        } else {
          product.unitCombinationId = 16;
        }
        ProductPrice _productPrice = ProductPrice(null, null, 0, 1, (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") ? _temp.primaryUnitId : 15);
        _productPrice.isDefault = true;
        product.productPriceList.add(_productPrice);
        if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
          _cUnitCombination.text = (_temp.secondaryUnit != null) ? "${_temp.primaryUnit} - ${_temp.secondaryUnit}" : "${_temp.primaryUnit}";
          _cUnit.text = _unitList.firstWhere((element) => element.id == _temp.primaryUnitId).code;
        }
        _cUnitPrice.text = product.productPriceList.firstWhere((element) => element.isDefault).price.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      } else {
        if (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
          await _getProductTaxes();
        }
        int _count = await dbHelper.productExistInInvoice(productId: product.id);
        if (_count > 0) {
          _productUsed = true;
        }
        _imagePath = product.imagePath;
        _cName.text = product.name;
        _cTypeName.text = product.type;
        _cProductTypeId.text = product.productTypeName;
        _cSupplierProductCode.text = product.supplierProductCode;
        _generatedProductCode = product.productCode;
        _cProductCode.text =
            '${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + product.productCode.toString().length))}${product.productCode}';
        _cDescription.text = product.description.toString();
        _cHsnCode.text = product.hsnCode;
        _isActive = product.isActive;
        if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
          UnitCombination _temp = _unitCombinationList.firstWhere((element) => element.id == product.unitCombinationId);
          _respectedUnit.add(_unitList.firstWhere((element) => element.id == _temp.primaryUnitId));
          if (_temp.secondaryUnitId != null) {
            _respectedUnit.add(_unitList.firstWhere((element) => element.id == _temp.secondaryUnitId));
          }
          _cUnitCombination.text = (_temp.secondaryUnit != null) ? "${_temp.primaryUnit} - ${_temp.secondaryUnit}" : "${_temp.primaryUnit}";
          _cUnit.text = _unitList.firstWhere((element) => element.id == product.productPriceList[0].unitId).code;
        }
        product.productPriceList = await dbHelper.productPriceGetList(product.id);
        _cUnitPrice.text = product.productPriceList.firstWhere((element) => element.isDefault).price.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
        //   _unitSelectedValue = product.productPriceList[0].unitId;
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - productAddScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _getUnitCombination() async {
    try {
      _unitCombinationList = await dbHelper.unitCombinationGetList();
    } catch (e) {
      print('Exception - productAddScreen.dart - _getUnitCombination(): ' + e.toString());
    }
  }

  Future _getDefaultCategory() async {
    try {
      List<ProductType> _productTypeList = await dbHelper.productTypeGetList(searchString: 'General');
      _productType = (_productTypeList.length > 0) ? _productTypeList[0] : null;
      _cProductTypeId.text = (_productType != null) ? _productType.name : '';
      setState(() {});
    } catch (e) {
      print('Exception - productAddScreen.dart - _getDefaultCategory(): ' + e.toString());
    }
  }

  Future _getUnits() async {
    try {
      _unitList = await dbHelper.unitGetList();
    } catch (e) {
      print('Exception - productAddScreen.dart - _getUnit(): ' + e.toString());
    }
  }

  void _fetchUnitCode() {
    try {
      _unitCombinationList.forEach((element) {
        element.primaryUnitCode = _unitList.firstWhere((e) => e.id == element.primaryUnitId).code;
        if (element.secondaryUnitId != null) {
          element.secondaryUnitCode = _unitList.firstWhere((e) => e.id == element.secondaryUnitId).code;
        }
      });
    } catch (e) {
      print('Exception - productAddScreen.dart - _fetchUnitCode(): ' + e.toString());
    }
  }

  Future _checkNameExist(value) async {
    try {
      if (product.id == null) {
        _nameIsExist = await dbHelper.productCheckNameExist(productName: value);
      } else {
        _nameIsExist = await dbHelper.productCheckNameExist(productName: value, productId: product.id);
      }
      setState(() {});
    } catch (e) {
      print('Exception - productAddScreen.dart - _cheackNameExist(): ' + e.toString());
    }
  }

  Future<Null> _focusListener() async {
    try {
      if (_fProductTypeId.hasFocus) {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductTypeSelectDialog(
                a: widget.analytics,
                o: widget.observer,
                selectedProductType: (obj) async {
                  _productType = obj;
                  _cProductTypeId.text = obj.name;
                  if (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true' && product.id == null) {
                    _isTaxLoaded = false;
                    product.productTaxList.clear();
                    _cTextEditingControllerList.clear();
                    List<ProductTypeTax> _productTypeTaxList = await dbHelper.productTypeTaxGetList(productTypeId: obj.id);
                    _isTaxLoaded = true;
                    if (_productTypeTaxList.length != 0) {
                      _productTypeTaxList.forEach((_productTypeTax) {
                        ProductTax _productTax = ProductTax(null, null, _productTypeTax.taxMasterId, _productTypeTax.percentage, _productTypeTax.taxName);
                        _productTax.taxGroupName = _productTypeTax.groupName;
                        product.productTaxList.add(_productTax);
                        _cTextEditingControllerList.add(TextEditingController(text: '${_productTypeTax.percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'));
                      });
                    } else {
                      List<TaxMaster> _taxMaster = await dbHelper.taxMasterGetList(isActive: true, isApplyPerProduct: true);
                      _isTaxLoaded = true;
                      _taxMaster.forEach((_taxMaster) {
                        ProductTax _productTax = ProductTax(null, null, _taxMaster.id, _taxMaster.percentage, _taxMaster.taxName);
                        _productTax.taxGroupName = _taxMaster.groupName;
                        product.productTaxList.add(_productTax);
                        _cTextEditingControllerList.add(TextEditingController(text: '${_taxMaster.percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'));
                      });
                    }
                  } else if (product.id != null && product.productTaxList.length != 0) {
                    _isTaxLoaded = false;
                    product.productTaxList.clear();
                    _cTextEditingControllerList.clear();
                    List<ProductTypeTax> _productTypeTaxList = await dbHelper.productTypeTaxGetList(productTypeId: obj.id);
                    _isTaxLoaded = true;
                    if (_productTypeTaxList.length != 0) {
                      _productTypeTaxList.forEach((_productTypeTax) {
                        ProductTax _productTax = ProductTax(null, null, _productTypeTax.taxMasterId, _productTypeTax.percentage, _productTypeTax.taxName);
                        _productTax.taxGroupName = _productTypeTax.groupName;
                        product.productTaxList.add(_productTax);
                        _cTextEditingControllerList.add(TextEditingController(text: '${_productTypeTax.percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'));
                      });
                    } else {
                      List<TaxMaster> _taxMaster = await dbHelper.taxMasterGetList(isActive: true, isApplyPerProduct: true);
                      _isTaxLoaded = true;
                      _taxMaster.forEach((_taxMaster) {
                        ProductTax _productTax = ProductTax(null, null, _taxMaster.id, _taxMaster.percentage, _taxMaster.taxName);
                        _productTax.taxGroupName = _taxMaster.groupName;
                        product.productTaxList.add(_productTax);
                        _cTextEditingControllerList.add(TextEditingController(text: '${_taxMaster.percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'));
                      });
                    }
                  }
                  setState(() {});
                })));
        setState(() {});
        FocusScope.of(context).requestFocus(_fUnitPrice);
      }
    } catch (e) {
      print('Exception - productAddScreen.dart - _focusListener(): ' + e.toString());
    }
  }

  Future _selectCombination() async {
    try {
      if (!_productUsed) {
        bool _isSelected = false;
        await Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => UnitCombinationSelectDialog(
                      a: widget.analytics,
                      o: widget.observer,
                      unitCombinationList: _unitCombinationList,
                    )))
            .then((value) {
          if (value != null) {
            _unitCombinationList = value.toList();
            _isSelected = true;
          }
        });
        if (_isSelected) {
          product.unitCombinationId = _unitCombinationList.firstWhere((element) => element.isSelected).id;
          _respectedUnit.clear();
          double _price = (product.productPriceList.length > 0) ? product.productPriceList[0].price : null;
          UnitCombination _temp = _unitCombinationList.firstWhere((element) => element.id == product.unitCombinationId);
          _respectedUnit.add(_unitList.firstWhere((element) => element.id == _temp.primaryUnitId));
          if (_temp.secondaryUnitId != null) {
            _respectedUnit.add(_unitList.firstWhere((element) => element.id == _temp.secondaryUnitId));
          }
          product.productPriceList.removeWhere((element) => element.isDefault);
          ProductPrice _productPrice = ProductPrice(null, null, _price, 1, _temp.primaryUnitId);
          _productPrice.isDefault = true;
          product.productPriceList.insert(0, _productPrice);
          _cUnitCombination.text = (_temp.secondaryUnit != null) ? "${_temp.primaryUnit} - ${_temp.secondaryUnit}" : "${_temp.primaryUnit}";
          _cUnit.text = _unitList.firstWhere((element) => element.id == _temp.primaryUnitId).code;
          setState(() {});
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(global.appLocaleValues['lbl_com_set_err_vld']),
        ));
      }
    } catch (e) {
      print('Exception - productAddScreen.dart - _selectCombination(): ' + e.toString());
    }
  }

  Future _selectUnit() async {
    try {
      bool _isSelected = false;
      await showDialog(
          context: context,
          builder: (_) {
            return SelectUnitDialog(
              a: widget.analytics,
              o: widget.observer,
              unitList: _respectedUnit,
            );
          }).then((value) {
        if (value != null) {
          _unitList = value.toList();
          _isSelected = true;
        }
      });
      if (_isSelected) {
        product.productPriceList[0].unitId = _unitList.firstWhere((element) => element.isSelected).id;
        _cUnit.text = _unitList.firstWhere((element) => element.isSelected).code;
      }
      setState(() {});
    } catch (e) {
      print('Exception - productAddScreen.dart - _selectUnit(): ' + e.toString());
    }
  }

  void _selectTypeName() {
    try {
      _businessInventoryList.removeWhere((element) => element == "Both");
      AlertDialog _dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        content: ListView.builder(
          itemCount: _businessInventoryList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('${_businessInventoryList[index]}'),
                  onTap: () {
                    _cTypeName.text = _businessInventoryList[index];
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
                ((_businessInventoryList.length - 1) != index) ? Divider() : SizedBox()
              ],
            );
          },
        ),
      );

      showDialog(builder: (context) => _dialog, context: context);
    } catch (e) {
      print('Exception - productAddScreen.dart - _selectTypeName(): ' + e.toString());
    }
  }

  Future _generateProductCode() async {
    try {
      _generatedProductCode = await dbHelper.productGetNewProductCode();
      String _productCode = '${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}$_generatedProductCode';
      _productCode = '${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}' + '${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - _productCode.length)}' + '$_generatedProductCode';
      _cProductCode.text = _productCode;
    } catch (e) {
      print('Exception - productAddScreen.dart - _generatedProductCode(): ' + e.toString());
    }
  }

  Future _getPath() async {
    try {
      _imagePath = global.productsImagesDirectoryPath;
    } catch (e) {
      print('Exception - productAddScreen.dart - _getPath(): ' + e.toString());
    }
  }

  Future _onSubmit() async {
    try {
      if (_key.currentState.validate()) {
        showLoader(global.appLocaleValues['txt_wait']);
        setState(() {});
        product.productCode = _generatedProductCode;
        product.supplierProductCode = _cSupplierProductCode.text.trim();
        product.name = _cName.text.trim();
        product.type = _cTypeName.text.trim();
        product.description = _cDescription.text.trim();
        product.hsnCode = _cHsnCode.text.trim();
        product.productTypeId = (_productType != null) ? _productType.id : product.productTypeId;
        product.productPriceList.forEach((element) {
          if (element.price == null) {
            element.price = 0;
          }
        });
        //   product.unitPrice = double.parse(_cUnitPrice.text.trim());
        product.imagePath = _imagePath;
        print('image: ${product.imagePath}');
        product.isActive = _isActive;
        print(product);
        if (product.id == null) {
          product.id = await dbHelper.productInsert(product);
        } else {
          await dbHelper.productUpdate(product);
        }
        hideLoader();
        setState(() {});
        if (screenId == 0) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => ProductScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )));
        } else if (screenId == 1) {
          product.productTypeName = _cProductTypeId.text;
          product.productPriceList[0].unitCode = _cUnit.text;
          Navigator.of(context).pop(product);
        }
      } else {
        _autovalidate = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - productAddScreen.dart - _onSubmit(): ' + e.toString());
    }
  }

  Future _openUploadPicOptions(context) async {
    //choose options for upload pic
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext bcon) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(global.appLocaleValues['txt_camera']),
                  onTap: () async {
                    await _picImageCamera();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_album,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(global.appLocaleValues['txt_gallery']),
                  onTap: () async {
                    await _picImageGallery();
                    Navigator.pop(context);
                  },
                ),
                (_imagePath != '')
                    ? ListTile(
                        leading: Icon(
                          Icons.cancel,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(global.appLocaleValues['txt_remove_profile']),
                        onTap: () {
                          setState(() {
                            _imagePath = '';
                          });
                          Navigator.pop(context);
                        },
                      )
                    : SizedBox(),
                ListTile(
                  leading: Icon(
                    Icons.cancel,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  title: Text(global.appLocaleValues['txt_cancel']),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  Future _picImageCamera() async {
    try {
      // when user select camera for upload pic
      global.isAppOperation = true;
      ImagePicker _picker = ImagePicker();
      final img = await _picker.pickImage(source: ImageSource.camera);
      if (img != null) {
        _getPath();
        global.isAppOperation = true;
        File croppedFile = await ImageCropper.cropImage(
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          sourcePath: img.path,
          maxWidth: 512,
          maxHeight: 512,
        );
        if (croppedFile != null) {
          setState(() {
            _image = croppedFile;
          });
          String imgTime = DateTime.now().toString();
          final File newImage = await _image.copy('$_imagePath/img$imgTime.png');

          _imagePath = newImage.path;
        }
      }
    } catch (e) {
      print('Exception - productAddScreen.dart - _picImageCamera(): ' + e.toString());
    }
  }

  Future _picImageGallery() async {
    // when user select gallary for upload pic
    try {
      global.isAppOperation = true;
      ImagePicker _picker = ImagePicker();
      final img = await _picker.pickImage(source: ImageSource.gallery);

      if (img != null) {
        _getPath();
        global.isAppOperation = true;
        File croppedFile = await ImageCropper.cropImage(
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          sourcePath: img.path,
          maxWidth: 512,
          maxHeight: 512,
        );
        if (croppedFile != null) {
          print(img.path);
          setState(() {
            _image = croppedFile;
          });
          String imgTime = DateTime.now().toString();
          final File newImage = await _image.copy('$_imagePath/img$imgTime.png');

          _imagePath = newImage.path;
        }
      }
    } catch (e) {
      print('Exception - productAddScreen.dart - _picImageGallery(): ' + e.toString());
    }
  }

  void _unitPriceListener() {
    try {
      if (_fUnitPrice.hasFocus) {
        if (_cUnitPrice.text == '${0.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}') {
          _cUnitPrice.clear();
        }
      } else {
        if (_cUnitPrice.text == '') {
          _cUnitPrice.text = '${0.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}';
        }
      }
      setState(() {});
    } catch (e) {
      print('Exception - productAddScreen.dart - _unitPriceListener(): ' + e.toString());
    }
  }

  Future _editTax(index) async {
    try {
      List<TaxMasterPercentage> _tempList = _taxMasterPercentageList.where((element) => element.taxId == product.productTaxList[index].taxMasterId).toList();
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
          for (int i = 0; i < product.productTaxList.length; i++) {
            if (product.productTaxList[index].taxGroupName == product.productTaxList[i].taxGroupName) {
              product.productTaxList[i].percentage = value;
            }
            _cTextEditingControllerList[i].text = '${product.productTaxList[i].percentage}';
          }
          setState(() {});
        }
      });
    } catch (e) {
      print('Exception - productTypeAddScreen.dart - _editTax(): ' + e.toString());
    }
  }
}
