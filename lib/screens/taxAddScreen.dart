// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/dialogs/selectTaxPercentageDialog.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/decimalTextInputFormatter.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/models/taxMasterPercentageModel.dart';
import 'package:accounting_app/screens/taxScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;

class TaxAddScreen extends BaseRoute {
  final TaxMaster taxMaster;
  final int applyOrder;
  TaxAddScreen({@required a, @required o, this.taxMaster, this.applyOrder}) : super(a: a, o: o, r: 'TaxAddScreen');
  @override
  _TaxAddScreenState createState() => _TaxAddScreenState(this.taxMaster, this.applyOrder);
}

class _TaxAddScreenState extends BaseRouteState {
  final int applyOrder;
  TextEditingController _cTaxName = TextEditingController();
  TextEditingController _cTaxPercentage = TextEditingController();
  TextEditingController _cDescription = TextEditingController();
  final _fTaxName = FocusNode();
  final _fTaxPercentage = FocusNode();
  final _fDescription = FocusNode();
  bool _applyOnProduct = false;
  bool _isActive = false;
  int screenId;
  bool _isTaxExist = false;
  bool _autovalidate = false;
  List<TaxMasterPercentage> _taxMasterPercentageList;

  var _key = GlobalKey<FormState>();
  TaxMaster taxMaster;
  _TaxAddScreenState(this.taxMaster, this.applyOrder) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: taxMaster.id != null
              ? Text(global.appLocaleValues['tle_update_tax'], style: Theme.of(context).appBarTheme.titleTextStyle)
              : Text(
                  global.appLocaleValues['tle_add_tax'],
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await _onSubmit();
              },
              child: Text(global.appLocaleValues['btn_save'], style: Theme.of(context).primaryTextTheme.headline2),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _key,
            autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(global.appLocaleValues['lbl_tax_name'], style: Theme.of(context).primaryTextTheme.headline3),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 10),
                      child: TextFormField(
                        controller: _cTaxName,
                        readOnly: true,
                        textInputAction: TextInputAction.next,
                        //   inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Za-z]'))],
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))],

                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          border: nativeTheme().inputDecorationTheme.border,
                          // hintText: 'ex.(CGST, SGST)',
                          errorText: (_isTaxExist) ? global.appLocaleValues['lbl_tax_name_err_vld'] : null,
                          // labelText: global.appLocaleValues['lbl_tax_name'],
                          suffixIcon: Icon(
                            Icons.star,
                            size: 9,
                            color: Colors.red,
                          ),
                        ),
                        focusNode: _fTaxName,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(_fTaxPercentage);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return global.appLocaleValues['lbl_tax_name_err_req'];
                          } else if (_isTaxExist) {
                            return global.appLocaleValues['lbl_tax_name_err_vld'];
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _checkNameExist(value);
                        },
                      ),
                    ),
                    Text(global.appLocaleValues['lbl_percentage'], style: Theme.of(context).primaryTextTheme.headline3),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: TextFormField(
                        controller: _cTaxPercentage,
                        textInputAction: TextInputAction.next,
                        maxLength: 5,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: nativeTheme().inputDecorationTheme.border,
                          counterText: '',
                          hintText: 'ex.(9, 12)',
                          // labelText: global.appLocaleValues['lbl_percentage'],
                          suffixIcon: Icon(
                            Icons.star,
                            size: 9,
                            color: Colors.red,
                          ),
                        ),
                        inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        focusNode: _fTaxPercentage,
                        onTap: () async {
                          await _editTax();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return global.appLocaleValues['lbl_percentage_err_req'];
                          } else if (value.contains(RegExp('[a-zA-Z]'))) {
                            return global.appLocaleValues['vel_enter_number_only'];
                          }
                          return null;
                        },
                      ),
                    ),
                    Text('${global.appLocaleValues['lbl_desc']} (${global.appLocaleValues['lbl_optional']})', style: Theme.of(context).primaryTextTheme.headline3),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 10),
                      child: TextFormField(
                        maxLines: 8,
                        controller: _cDescription,
                        focusNode: _fDescription,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: '${global.appLocaleValues['lbl_desc']}',
                          border: nativeTheme().inputDecorationTheme.border,
                          // labelText: ,
                          alignLabelWithHint: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              // Padding(
              //   padding: EdgeInsets.only(left: 10, right: 10),
              //   child: Column(
              //     children: <Widget>[
              //       // Text(
              //       //   'Select Tax',
              //       //   style: TextStyle(color: Colors.grey, fontSize: 15),
              //       // ),
              //       CheckboxListTile(
              //         title: Text('${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_apply_tax_on_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_apply_tax_on_service'] : global.appLocaleValues['lbl_apply_tax_on_both']}'),
              //         value: _applyOnProduct,
              //         onChanged: (bool val) {
              //           setState(() {
              //             _applyOnProduct = val;
              //             print(_applyOnProduct);
              //           });
              //         },
              //       ),
              //       CheckboxListTile(
              //         title: Text(global.appLocaleValues['lbl_active']),
              //         value: _isActive,
              //         onChanged: (bool val) {
              //           setState(() {
              //             _isActive = val;
              //             print(_isActive);
              //           });
              //         },
              //       )
              //     ],
              //   ),
              // )
            ]),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      if (taxMaster == null) {
        taxMaster = TaxMaster();
        _isActive = (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true') ? true : false;
        _applyOnProduct = (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') ? true : false;
        taxMaster.applyOrder = applyOrder;
      } else {
        await _fillData();
      }
      setState(() {});
    } catch (e) {
      print('Exception - TaxAddScreen.dart - _getData(): ' + e.toString());
    }
  }

  // Future _getOrder() async {
  //   _order = await dbHelper.taxMatserCount();
  // }

  Future _fillData() async // display details during update expense
  {
    try {
      _cTaxName.text = taxMaster.taxName;
      _cTaxPercentage.text = taxMaster.percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _cDescription.text = taxMaster.description.toString();
      _isActive = taxMaster.isActive;
      _applyOnProduct = taxMaster.isApplyOnProduct;
    } catch (e) {
      print('Exception - TaxAddScreen.dart - _fillData(): ' + e.toString());
    }
  }

  Future _onSubmit() async {
    try {
      if (_key.currentState.validate()) {
        showLoader(global.appLocaleValues['txt_wait']);
        setState(() {});
        taxMaster.taxName = _cTaxName.text.trim();
        taxMaster.percentage = double.parse(_cTaxPercentage.text.trim());
        taxMaster.description = _cDescription.text.trim();
        taxMaster.isApplyOnProduct = _applyOnProduct;
        taxMaster.isActive = _isActive;

        List<TaxMaster> _taxMasterList = await dbHelper.taxMasterGetList(groupName: taxMaster.groupName);
        for (int i = 0; i < _taxMasterList.length; i++) {
          if (_taxMasterList[i].id == taxMaster.id) {
            _taxMasterList[i] = taxMaster;
          }
          _taxMasterList[i].percentage = double.parse(_cTaxPercentage.text.trim());
          await dbHelper.taxMasterUpdate(_taxMasterList[i]);
        }
        hideLoader();
        setState(() {});
        if (screenId == 0) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TaxScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TaxScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )));
        }
      } else {
        _autovalidate = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - TaxAddScreen.dart - _onSubmit(): ' + e.toString());
    }
  }

  Future _checkNameExist(value) async {
    try {
      if (taxMaster.id == null) {
        _isTaxExist = await dbHelper.taxMasterCheckNameExist(taxName: value);
      } else {
        _isTaxExist = await dbHelper.taxMasterCheckNameExist(taxName: value, taxId: taxMaster.id);
      }
      setState(() {});
    } catch (e) {
      print('Exception - taxAddScreen.dart - _cheackNameExist(): ' + e.toString());
    }
  }

  Future _editTax() async {
    try {
      if (_taxMasterPercentageList == null) {
        _taxMasterPercentageList = await dbHelper.taxMasterPercentageGetList();
      }
      List<TaxMasterPercentage> _tempList = _taxMasterPercentageList.where((element) => element.taxId == taxMaster.id).toList();
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
          _cTaxPercentage.text = value.toString();
          setState(() {});
        }
      });
    } catch (e) {
      print('Exception - taxAddScreen.dart - _editTax(): ' + e.toString());
    }
  }
}
