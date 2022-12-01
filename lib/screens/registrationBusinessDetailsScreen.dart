// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable, unused_field
import 'dart:io';


import 'package:accounting_app/models/taxMasterPercentageModel.dart';
import 'package:accounting_app/models/unitCombinationModel.dart';
import 'package:accounting_app/models/unitModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/businessModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/screens/registrationPersonalDetailsScreen.dart';
import 'package:accounting_app/screens/registrationSetSecurityPinScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class RegistrationBusinessDetailsScreen extends BaseRoute {
  RegistrationBusinessDetailsScreen({@required a, @required o}) : super(a: a, o: o, r: 'RegistrationBusinessDetailsScreen');
  @override
  _RegistrationBusinessDetailsScreenState createState() => _RegistrationBusinessDetailsScreenState();
}

class _RegistrationBusinessDetailsScreenState extends BaseRouteState {
  var _formKey = GlobalKey<FormState>();
  var _fName = FocusNode();
  var _fAddressLine1 = FocusNode();
  var _fregistrationNo = FocusNode();
  var _cregistrationNo = TextEditingController();
  var _fGstNo = FocusNode();
  var _cGstNo = TextEditingController();
  var _cName = TextEditingController();
  var _cAddressLine1 = TextEditingController();
  List<String> _businessInventoryValueList;
  // int _selectedValue = 0;
  File _image;
  var _logoPath;
  bool _autovalidate = false;
  bool _showMore = false;
  bool _isTaxEnabled = false;
  bool _isTaxProductWiseEnabled = false;
  List<TaxMaster> _taxMasterList;
  List<TaxMasterPercentage> _taxMasterPercentageList;
  var _cDateFormat = TextEditingController();
  var _cDecimalPlaces = TextEditingController();
  var _cAccountCodePrefix = TextEditingController();
//  var _cAccountCodeMaxLen = TextEditingController();
  var _cProductCodePrefix = TextEditingController();
  var _cProductCodeMaxLen = TextEditingController();
  var _cInvoiceNoPrefix = TextEditingController();
  var _cInvoiceNoMaxLen = TextEditingController();
  var _cDefaultUnitOfMeasure = TextEditingController();
  var _cFinantialMonth = TextEditingController();
  var _fDateFormat = FocusNode();
//  var _fAccountCodeMaxLen = FocusNode();
  var _fProductCodeMaxLen = FocusNode();
  var _fInvoiceNoMaxLen = FocusNode();
  var _fNode = FocusNode();
//  List<String> _accountCodeMaxLengthValueList = new List();
  List<String> _productCodeMaxLengthValueList =  List();
  List<String> _invoiceNoMaxLengthValueList =  List();
  List<String> _dateFormatValueList =  List();
  var _key = GlobalKey<ScaffoldState>();
  // String _accountCodeExample = '0001';
  String _productCodeExample = '0001';
  String _invoiceNoExample = '00001';
  String _decimalPlacesExample;
  bool _isEnablePurchaseSupplierModule = false;
  bool _isSalesReturnEnable = false;
  bool _isUnitEnable = false;
  bool _isEmployeeEnable = false;
  bool _isPurchaseReturnEnable = false;
  bool _isSaleOrderEnable = false;
  List<UnitCombination> _unitCombinationList =  List();
  List<Unit> _unitList =  List();
  var _cBusinessInventory = TextEditingController();

  _RegistrationBusinessDetailsScreenState() : super();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          Navigator.of(context).push(PageTransition(
              type: PageTransitionType.leftToRight,
              child: RegistrationPersonalDetailsScreen(
                a: widget.analytics,
                o: widget.observer,
              )));
          return null;
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 7.5,
                  ),
                  Center(
                    child: Text(
                      global.appLocaleValues['lbl_business_detail'],
                      style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(global.appLocaleValues['lbl_business_detail_desc'], style: Theme.of(context).primaryTextTheme.headline6),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            Stack(
                              children: <Widget>[
                                Container(
                                  width: 120,
                                  height: 120,
                                  child: Card(
                                      child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Center(
                                            child: (_logoPath != null) ? Image.file(File(_logoPath)) : Text('Logo', style: Theme.of(context).primaryTextTheme.headline6),
                                          ))),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 90, top: 80),
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      _openUploadPicOptions(context);
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(global.appLocaleValues['lbl_business_name'] + ' (' + global.appLocaleValues['lbl_optional'] + ')', style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              focusNode: _fName,
                              controller: _cName,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z, ]'))],
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_fAddressLine1);
                              },
                              onChanged: (v) {
                                global.business.name = v;
                              },
                              decoration: InputDecoration(
                                hintText: global.appLocaleValues['lbl_business_name'],
                                border: nativeTheme().inputDecorationTheme.border,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text('${global.appLocaleValues['lbl_business_address']} (${global.appLocaleValues['lbl_optional']})', style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              focusNode: _fAddressLine1,
                              controller: _cAddressLine1,
                              onChanged: (v) {
                                global.business.addressLine1 = v;
                              },
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_fregistrationNo);
                              },
                              decoration: InputDecoration(
                                hintText: '${global.appLocaleValues['lbl_business_address']} (${global.appLocaleValues['lbl_optional']})',
                                border: nativeTheme().inputDecorationTheme.border,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text('${global.appLocaleValues['lbl_business_regno']} ', style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              focusNode: _fregistrationNo,
                              controller: _cregistrationNo,
                              textInputAction: TextInputAction.next,
                              onChanged: (v) {
                                global.business.registrationNo = v;
                              },
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_fGstNo);
                              },
                              decoration: InputDecoration(hintText: global.appLocaleValues['lbl_business_regno'], border: OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text('${global.appLocaleValues['lbl_gst_no']} (${global.appLocaleValues['lbl_optional']})', style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              focusNode: _fGstNo,
                              controller: _cGstNo,
                              textInputAction: TextInputAction.done,
                              onChanged: (v) {
                                global.business.gstNo = v;
                              },
                              validator: (v) {
                                if (v.isNotEmpty) {
                                  if (v.trim().indexOf('-') == 0 || v.trim().indexOf('-') == (v.length - 1)) {
                                    return global.appLocaleValues['lbl_gst_no_err_vld'];
                                  }
                                }
                                return null;
                              },
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Z0-9,-]'))],
                              decoration: InputDecoration(hintText: '${global.appLocaleValues['lbl_gst_no']} (${global.appLocaleValues['lbl_optional']})', border: OutlineInputBorder()),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(bottom: !_showMore ? 70 : 0),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: Text(
                                  (!_showMore) ? global.appLocaleValues['btn_show_advance'] : global.appLocaleValues['btn_hide_advance'],
                                  style: TextStyle(color: Theme.of(context).primaryColor),
                                ),
                                onTap: () async {
                                  _showMore = !_showMore;
                                  if (_showMore && (_taxMasterList == null || _taxMasterList.length < 1)) {
                                    await _fillData();
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                            (_showMore)
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 0.0),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 5),
                                            child: Text('${global.appLocaleValues['tle_system_config']}', style: Theme.of(context).primaryTextTheme.headline6.copyWith(fontSize: 25)),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 5),
                                            child: Text('${global.appLocaleValues['lbl_business_inventory_desc']}', style: Theme.of(context).primaryTextTheme.headline6),
                                          ),
                                        ),
                                        TextFormField(
                                          textCapitalization: TextCapitalization.characters,
                                          readOnly: true,
                                          controller: _cBusinessInventory,
                                          textInputAction: TextInputAction.done,
                                          onTap: () {
                                            _fBusinessInventoryListerner();
                                          },
                                          decoration: InputDecoration(border: OutlineInputBorder()),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 5, top: 10),
                                            child: Text('${global.appLocaleValues['lbl_date_format']}', style: Theme.of(context).primaryTextTheme.headline6),
                                          ),
                                        ),
                                        TextFormField(
                                          textCapitalization: TextCapitalization.sentences,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          focusNode: _fDateFormat,
                                          readOnly: true,
                                          controller: _cDateFormat,
                                          decoration: InputDecoration(
                                            hintText: '',
                                            suffixIcon: Icon(
                                              Icons.star,
                                              size: 9,
                                              color: Colors.red,
                                            ),
                                            border: nativeTheme().inputDecorationTheme.border,
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              global.appLocaleValues['lbl_date_format_example'],
                                              style: TextStyle(color: Colors.grey, fontSize: 15),
                                            ),
                                            Text(
                                              '${DateFormat(_cDateFormat.text).format(DateTime.now())}',
                                              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 5),
                                            child: Text('${global.appLocaleValues['lbl_decimal_places']}', style: Theme.of(context).primaryTextTheme.headline6),
                                          ),
                                        ),
                                        TextFormField(
                                          textCapitalization: TextCapitalization.sentences,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          onTap: () async {
                                            await _chooseDecimalPlaces();
                                          },
                                          readOnly: true,
                                          controller: _cDecimalPlaces,
                                          decoration: InputDecoration(
                                            hintText: '',
                                            suffixIcon: Icon(
                                              Icons.star,
                                              size: 9,
                                              color: Colors.red,
                                            ),
                                            border: nativeTheme().inputDecorationTheme.border,
                                          ),
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.only(bottom: !_showMore ? 0 : 75),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                global.appLocaleValues['lbl_decimal_places_example'],
                                                style: TextStyle(color: Colors.grey, fontSize: 15),
                                              ),
                                              Text(
                                                '$_decimalPlacesExample',
                                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        // Align(
                                        //   alignment: Alignment.centerLeft,
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.only(bottom: 5, top: 10),
                                        //     child: Text('${global.appLocaleValues['lbl_financial_month']}', style: Theme.of(context).primaryTextTheme.headline6),
                                        //   ),
                                        // ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(bottom: 0),
                                        //   child: TextFormField(
                                        //     readOnly: true,
                                        //     controller: _cFinantialMonth,
                                        //     decoration: InputDecoration(
                                        //       hintText: '',
                                        //       suffixIcon: Icon(
                                        //         Icons.star,
                                        //         size: 9,
                                        //         color: Colors.red,
                                        //       ),
                                        //       border: nativeTheme().inputDecorationTheme.border,
                                        //     ),
                                        //     onTap: () async {
                                        //       _cFinantialMonth.text = await br.chooseFinantialMonth(context, _cFinantialMonth.text);
                                        //       setState(() {});
                                        //     },
                                        //   ),
                                        // ),
                                        // (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service')
                                        //     ? ListTile(
                                        //         contentPadding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
                                        //         leading: Row(
                                        //           mainAxisSize: MainAxisSize.min,
                                        //           children: <Widget>[
                                        //             Text(
                                        //               global.appLocaleValues['lbl_unit_'],
                                        //               style: TextStyle(fontSize: 16),
                                        //             ),
                                        //             IconButton(
                                        //               icon: Icon(
                                        //                 Icons.info,
                                        //                 color: Colors.grey,
                                        //                 size: 20,
                                        //               ),
                                        //               onPressed: () {
                                        //                 showInfoMessage(
                                        //                     global.appLocaleValues['lbl_unit_'],
                                        //                     global.systemFlagNameList.enableUnitModule,
                                        //                     Icon(
                                        //                       Icons.info,
                                        //                       color: Theme.of(context).primaryColor,
                                        //                     ));
                                        //               },
                                        //             )
                                        //           ],
                                        //         ),
                                        //         trailing: Switch(
                                        //           value: _isUnitEnable,
                                        //           onChanged: (value) {
                                        //             setState(() {
                                        //               _isUnitEnable = value;
                                        //             });
                                        //           },
                                        //         ),
                                        //       )
                                        //     : SizedBox(),
                                        // (_isUnitEnable)
                                        //     ? Align(
                                        //         alignment: Alignment.centerLeft,
                                        //         child: Padding(
                                        //           padding: const EdgeInsets.only(bottom: 5),
                                        //           child: Text('${global.appLocaleValues['lbl_default_unit_combintion']}', style: Theme.of(context).primaryTextTheme.headline6),
                                        //         ),
                                        //       )
                                        //     : SizedBox(),
                                        // (_isUnitEnable)
                                        //     ? TextFormField(
                                        //         readOnly: true,
                                        //         controller: _cDefaultUnitOfMeasure,
                                        //         decoration: InputDecoration(
                                        //           hintText: '',
                                        //           // labelText: global.appLocaleValues['lbl_default_unit_combintion'],
                                        //           suffixIcon: Icon(
                                        //             Icons.star,
                                        //             size: 9,
                                        //             color: Colors.red,
                                        //           ),
                                        //           border: nativeTheme().inputDecorationTheme.border,
                                        //         ),
                                        //         onTap: () async {
                                        //           await _selectCombination();
                                        //         },
                                        //       )
                                        //     : SizedBox(),
                                        // ListTile(
                                        //   contentPadding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
                                        //   leading: Row(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     children: <Widget>[
                                        //       Text(
                                        //         global.appLocaleValues['lbl_enable_emp'],
                                        //         style: TextStyle(fontSize: 16),
                                        //       ),
                                        //       IconButton(
                                        //         icon: Icon(
                                        //           Icons.info,
                                        //           color: Colors.grey,
                                        //           size: 20,
                                        //         ),
                                        //         onPressed: () {
                                        //           showInfoMessage(
                                        //               global.appLocaleValues['lbl_enable_emp'],
                                        //               global.systemFlagNameList.enableEmployee,
                                        //               Icon(
                                        //                 Icons.info,
                                        //                 color: Theme.of(context).primaryColor,
                                        //               ));
                                        //         },
                                        //       )
                                        //     ],
                                        //   ),
                                        //   trailing: Switch(
                                        //     value: _isEmployeeEnable,
                                        //     onChanged: (value) {
                                        //       setState(() {
                                        //         _isEmployeeEnable = value;
                                        //       });
                                        //     },
                                        //   ),
                                        // ),
                                        // Align(
                                        //   alignment: Alignment.centerLeft,
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.only(bottom: 5, top: 10),
                                        //     child: Text('${global.appLocaleValues['tle_sales_config']}', style: Theme.of(context).primaryTextTheme.headline6.copyWith(fontSize: 25)),
                                        //   ),
                                        // ),
                                        // ListTile(
                                        //   contentPadding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
                                        //   leading: Row(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     children: <Widget>[
                                        //       Text(
                                        //         global.appLocaleValues['tab_customers'],
                                        //         style: TextStyle(fontSize: 16),
                                        //       ),
                                        //       IconButton(
                                        //         icon: Icon(
                                        //           Icons.info,
                                        //           color: Colors.transparent,
                                        //           size: 20,
                                        //         ),
                                        //         onPressed: () {},
                                        //       )
                                        //     ],
                                        //   ),
                                        //   trailing: Switch(
                                        //     value: true,
                                        //     onChanged: (value) {},
                                        //   ),
                                        // ),
                                        // ListTile(
                                        //   contentPadding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
                                        //   leading: Row(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     children: <Widget>[
                                        //       Text(
                                        //         global.appLocaleValues['lbl_sales_quotes'],
                                        //         style: TextStyle(fontSize: 16),
                                        //       ),
                                        //       IconButton(
                                        //         icon: Icon(
                                        //           Icons.info,
                                        //           color: Colors.grey,
                                        //           size: 20,
                                        //         ),
                                        //         onPressed: () {
                                        //           showInfoMessage(
                                        //               global.appLocaleValues['lbl_sales_quotes'],
                                        //               global.systemFlagNameList.enableSalesQuote,
                                        //               Icon(
                                        //                 Icons.info,
                                        //                 color: Theme.of(context).primaryColor,
                                        //               ));
                                        //         },
                                        //       )
                                        //     ],
                                        //   ),
                                        //   trailing: Switch(
                                        //     value: _isSaleOrderEnable,
                                        //     onChanged: (value) {
                                        //       setState(() {
                                        //         _isSaleOrderEnable = value;
                                        //       });
                                        //     },
                                        //   ),
                                        // ),
                                        // ListTile(
                                        //   contentPadding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
                                        //   leading: Row(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     children: <Widget>[
                                        //       Text(
                                        //         global.appLocaleValues['lbl_sales_order'],
                                        //         style: TextStyle(fontSize: 16),
                                        //       ),
                                        //       IconButton(
                                        //         icon: Icon(
                                        //           Icons.info,
                                        //           color: Colors.grey,
                                        //           size: 20,
                                        //         ),
                                        //         onPressed: () {
                                        //           showInfoMessage(
                                        //               global.appLocaleValues['lbl_sales_order'],
                                        //               global.systemFlagNameList.enableSaleOrder,
                                        //               Icon(
                                        //                 Icons.info,
                                        //                 color: Theme.of(context).primaryColor,
                                        //               ));
                                        //         },
                                        //       )
                                        //     ],
                                        //   ),
                                        //   trailing: Switch(
                                        //     value: _isSaleOrderEnable,
                                        //     onChanged: (value) {
                                        //       setState(() {
                                        //         _isSaleOrderEnable = value;
                                        //       });
                                        //     },
                                        //   ),
                                        // ),
                                        // (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service')
                                        //     ? ListTile(
                                        //         contentPadding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
                                        //         leading: Row(
                                        //           mainAxisSize: MainAxisSize.min,
                                        //           children: <Widget>[
                                        //             Text(
                                        //               global.appLocaleValues['lbl_sales_return'],
                                        //               style: TextStyle(fontSize: 16),
                                        //             ),
                                        //             IconButton(
                                        //               icon: Icon(
                                        //                 Icons.info,
                                        //                 color: Colors.grey,
                                        //                 size: 20,
                                        //               ),
                                        //               onPressed: () {
                                        //                 showInfoMessage(
                                        //                     global.appLocaleValues['lbl_sales_return'],
                                        //                     global.systemFlagNameList.enableSalesReturn,
                                        //                     Icon(
                                        //                       Icons.info,
                                        //                       color: Theme.of(context).primaryColor,
                                        //                     ));
                                        //               },
                                        //             )
                                        //           ],
                                        //         ),
                                        //         trailing: Switch(
                                        //           value: _isSalesReturnEnable,
                                        //           onChanged: (value) {
                                        //             setState(() {
                                        //               _isSalesReturnEnable = value;
                                        //             });
                                        //           },
                                        //         ),
                                        //       )
                                        //     : SizedBox(),
                                        // (br.getSystemFlagValue("businessInventory") != 'Service')
                                        //     ? ListTile(
                                        //         contentPadding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
                                        //         leading: Row(
                                        //           mainAxisSize: MainAxisSize.min,
                                        //           children: <Widget>[
                                        //             Text(
                                        //               global.appLocaleValues['lbl_purchase_supplier'],
                                        //               style: TextStyle(fontSize: 16),
                                        //             ),
                                        //             IconButton(
                                        //               icon: Icon(
                                        //                 Icons.info,
                                        //                 color: Colors.grey,
                                        //                 size: 20,
                                        //               ),
                                        //               onPressed: () {
                                        //                 showInfoMessage(
                                        //                     global.appLocaleValues['lbl_purchase_supplier'],
                                        //                     global.systemFlagNameList.enablePurchaseAndSupplierModule,
                                        //                     Icon(
                                        //                       Icons.info,
                                        //                       color: Theme.of(context).primaryColor,
                                        //                     ));
                                        //               },
                                        //             )
                                        //           ],
                                        //         ),
                                        //         trailing: Switch(
                                        //           value: _isEnablePurchaseSupplierModule,
                                        //           onChanged: (value) {
                                        //             setState(() {
                                        //               _isEnablePurchaseSupplierModule = value;
                                        //             });
                                        //           },
                                        //         ),
                                        //       )
                                        //     : SizedBox(),
                                        // (br.getSystemFlagValue("businessInventory") != 'Service' && _isEnablePurchaseSupplierModule)
                                        //     ? ListTile(
                                        //         contentPadding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
                                        //         leading: Row(
                                        //           mainAxisSize: MainAxisSize.min,
                                        //           children: <Widget>[
                                        //             Text(
                                        //               global.appLocaleValues['lbl_purchase_return'],
                                        //               style: TextStyle(fontSize: 16),
                                        //             ),
                                        //             IconButton(
                                        //               icon: Icon(
                                        //                 Icons.info,
                                        //                 color: Colors.grey,
                                        //                 size: 20,
                                        //               ),
                                        //               onPressed: () {
                                        //                 showInfoMessage(
                                        //                     global.appLocaleValues['lbl_purchase_return'],
                                        //                     global.systemFlagNameList.enablePurchaseReturn,
                                        //                     Icon(
                                        //                       Icons.info,
                                        //                       color: Theme.of(context).primaryColor,
                                        //                     ));
                                        //               },
                                        //             )
                                        //           ],
                                        //         ),
                                        //         trailing: Switch(
                                        //           value: _isPurchaseReturnEnable,
                                        //           onChanged: (value) {
                                        //             setState(() {
                                        //               _isPurchaseReturnEnable = value;
                                        //             });
                                        //           },
                                        //         ),
                                        //       )
                                        //     : SizedBox(),
                                        // Row(
                                        //   children: <Widget>[
                                        //     Text(
                                        //       '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_code'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_code'] : global.appLocaleValues['lbl_both_code']}',
                                        //       style: TextStyle(fontSize: 15),
                                        //     ),
                                        //   ],
                                        // ),
                                        // SizedBox(
                                        //   height: 5,
                                        // ),
                                        // Row(
                                        //   children: <Widget>[
                                        //     Expanded(
                                        //       child: Column(
                                        //         mainAxisSize: MainAxisSize.min,
                                        //         children: [
                                        //           Align(
                                        //             alignment: Alignment.centerLeft,
                                        //             child: Padding(
                                        //               padding: const EdgeInsets.only(bottom: 5),
                                        //               child: Text('${global.appLocaleValues['lbl_pre']}', style: Theme.of(context).primaryTextTheme.headline6),
                                        //             ),
                                        //           ),
                                        //           TextFormField(
                                        //             textCapitalization: TextCapitalization.characters,
                                        //             keyboardType: TextInputType.text,
                                        //             inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Z]'))],
                                        //             maxLength: 3,
                                        //             onChanged: (v) {
                                        //               if (v.length == 0) {
                                        //                 _cProductCodeMaxLen.text = '4';
                                        //               } else if (v.length == 1) {
                                        //                 _cProductCodeMaxLen.text = '5';
                                        //               } else if (v.length == 2) {
                                        //                 _cProductCodeMaxLen.text = '6';
                                        //               } else if (v.length == 3) {
                                        //                 _cProductCodeMaxLen.text = '7';
                                        //               }
                                        //               setState(() {
                                        //                 _generateProductCodeExample();
                                        //               });
                                        //             },
                                        //             controller: _cProductCodePrefix,
                                        //             decoration: InputDecoration(
                                        //                 hintText: '',
                                        //                 //  labelText: global.appLocaleValues['lbl_pre'],
                                        //                 border: nativeTheme().inputDecorationTheme.border,
                                        //                 counterText: ''),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //     SizedBox(
                                        //       width: 10,
                                        //     ),
                                        //     Expanded(
                                        //       child: Column(
                                        //         mainAxisSize: MainAxisSize.min,
                                        //         children: [
                                        //           Align(
                                        //             alignment: Alignment.centerLeft,
                                        //             child: Padding(
                                        //               padding: const EdgeInsets.only(bottom: 5),
                                        //               child: Text('${global.appLocaleValues['lbl_max_len']}', style: Theme.of(context).primaryTextTheme.headline6),
                                        //             ),
                                        //           ),
                                        //           TextFormField(
                                        //             controller: _cProductCodeMaxLen,
                                        //             focusNode: _fProductCodeMaxLen,
                                        //             validator: (v) {
                                        //               return null;
                                        //             },
                                        //             readOnly: true,
                                        //             decoration: InputDecoration(
                                        //               hintText: '',
                                        //               border: nativeTheme().inputDecorationTheme.border,
                                        //               suffixIcon: Icon(
                                        //                 Icons.star,
                                        //                 size: 9,
                                        //                 color: Colors.red,
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),
                                        // Row(
                                        //   children: <Widget>[
                                        //     Text(
                                        //       ' ${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_code_ex'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_code_ex'] : global.appLocaleValues['lbl_both_code_ex']}: ',
                                        //       style: TextStyle(color: Colors.grey, fontSize: 15),
                                        //     ),
                                        //     Text(
                                        //       '$_productCodeExample',
                                        //       style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                                        //     )
                                        //   ],
                                        // ),
                                        // SizedBox(
                                        //   height: 20,
                                        // ),
                                        // Row(
                                        //   children: <Widget>[
                                        //     Text(
                                        //       global.appLocaleValues['lbl_invoiceno'],
                                        //       style: TextStyle(fontSize: 15),
                                        //     ),
                                        //   ],
                                        // ),
                                        // SizedBox(
                                        //   height: 5,
                                        // ),
                                        // Row(
                                        //   children: <Widget>[
                                        //     Expanded(
                                        //       child: Column(
                                        //         mainAxisSize: MainAxisSize.min,
                                        //         children: [
                                        //           Align(
                                        //             alignment: Alignment.centerLeft,
                                        //             child: Padding(
                                        //               padding: const EdgeInsets.only(bottom: 5),
                                        //               child: Text('${global.appLocaleValues['lbl_pre']}', style: Theme.of(context).primaryTextTheme.headline6),
                                        //             ),
                                        //           ),
                                        //           TextFormField(
                                        //             textCapitalization: TextCapitalization.characters,
                                        //             keyboardType: TextInputType.text,
                                        //             //    inputFormatters: [WhitelistingTextInputFormatter(RegExp('[A-Z]'))],
                                        //             inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Z]'))],

                                        //             maxLength: 3,
                                        //             onChanged: (v) {
                                        //               if (v.length == 0) {
                                        //                 _cInvoiceNoMaxLen.text = '5';
                                        //               } else if (v.length == 1) {
                                        //                 _cInvoiceNoMaxLen.text = '6';
                                        //               } else if (v.length == 2) {
                                        //                 _cInvoiceNoMaxLen.text = '7';
                                        //               } else if (v.length == 3) {
                                        //                 _cInvoiceNoMaxLen.text = '8';
                                        //               }
                                        //               setState(() {
                                        //                 _generateInvoiceNoExample();
                                        //               });
                                        //             },
                                        //             controller: _cInvoiceNoPrefix,
                                        //             decoration: InputDecoration(hintText: '', border: nativeTheme().inputDecorationTheme.border, counterText: ''),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //     SizedBox(
                                        //       width: 10,
                                        //     ),
                                        //     Expanded(
                                        //       child: Column(
                                        //         children: [
                                        //           Align(
                                        //             alignment: Alignment.centerLeft,
                                        //             child: Padding(
                                        //               padding: const EdgeInsets.only(bottom: 5),
                                        //               child: Text('${global.appLocaleValues['lbl_max_len']}', style: Theme.of(context).primaryTextTheme.headline6),
                                        //             ),
                                        //           ),
                                        //           TextFormField(
                                        //             controller: _cInvoiceNoMaxLen,
                                        //             focusNode: _fInvoiceNoMaxLen,
                                        //             validator: (v) {
                                        //               if (v.isEmpty) {
                                        //                 return global.appLocaleValues['vel_invoiceno_max_len'];
                                        //               }
                                        //               return null;
                                        //             },
                                        //             readOnly: true,
                                        //             decoration: InputDecoration(
                                        //               hintText: '',
                                        //               border: nativeTheme().inputDecorationTheme.border,
                                        //               suffixIcon: Icon(
                                        //                 Icons.star,
                                        //                 size: 9,
                                        //                 color: Colors.red,
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),
                                        // Row(
                                        //   children: <Widget>[
                                        //     Text(
                                        //       global.appLocaleValues['lbl_invoiceno_example'],
                                        //       style: TextStyle(color: Colors.grey, fontSize: 15),
                                        //     ),
                                        //     Text(
                                        //       ' $_invoiceNoExample',
                                        //       style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                                        //     )
                                        //   ],
                                        // ),
                                        // Divider(),
                                        // Align(alignment: Alignment.centerLeft, child: Text(global.appLocaleValues['tle_tax'], style: Theme.of(context).primaryTextTheme.headline6)),
                                        // ListTile(
                                        //   leading: Row(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     children: <Widget>[
                                        //       Text(
                                        //         global.appLocaleValues['lbl_enable_tax'],
                                        //         style: TextStyle(fontSize: 16),
                                        //       ),
                                        //       IconButton(
                                        //         icon: Icon(
                                        //           Icons.info,
                                        //           color: Colors.grey,
                                        //           size: 20,
                                        //         ),
                                        //         onPressed: () {
                                        //           showInfoMessage(
                                        //               global.appLocaleValues['lbl_enable_tax'],
                                        //               global.systemFlagNameList.enableTax,
                                        //               Icon(
                                        //                 Icons.info,
                                        //                 color: Theme.of(context).primaryColor,
                                        //               ));
                                        //         },
                                        //       )
                                        //     ],
                                        //   ),
                                        //   trailing: Switch(
                                        //     value: _isTaxEnabled,
                                        //     onChanged: (value) {
                                        //       setState(() {
                                        //         _isTaxEnabled = value;
                                        //         _isTaxProductWiseEnabled = false;
                                        //       });
                                        //     },
                                        //   ),
                                        // ),
                                        // (_isTaxEnabled)
                                        //     ? ListTile(
                                        //         leading: Row(
                                        //           mainAxisSize: MainAxisSize.min,
                                        //           children: <Widget>[
                                        //             Text(
                                        //               '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_enable_product_wise_tax'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_enable_service_wise_tax'] : global.appLocaleValues['lbl_enable_both_wise_tax']}',
                                        //               style: TextStyle(fontSize: 16),
                                        //             ),
                                        //             IconButton(
                                        //               icon: Icon(
                                        //                 Icons.info,
                                        //                 color: Colors.grey,
                                        //                 size: 20,
                                        //               ),
                                        //               onPressed: () {
                                        //                 showInfoMessage(
                                        //                     (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product')
                                        //                         ? global.appLocaleValues['lbl_enable_product_wise_tax']
                                        //                         : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service')
                                        //                             ? global.appLocaleValues['lbl_enable_service_wise_tax']
                                        //                             : global.appLocaleValues['lbl_enable_both_wise_tax'],
                                        //                     global.systemFlagNameList.enableProductWiseTax,
                                        //                     Icon(
                                        //                       Icons.info,
                                        //                       color: Theme.of(context).primaryColor,
                                        //                     ));
                                        //               },
                                        //             )
                                        //           ],
                                        //         ),
                                        //         trailing: Switch(
                                        //           value: _isTaxProductWiseEnabled,
                                        //           onChanged: (value) {
                                        //             setState(() {
                                        //               _isTaxProductWiseEnabled = value;
                                        //             });
                                        //           },
                                        //         ),
                                        //       )
                                        //     : SizedBox(),
                                        // (_isTaxEnabled)
                                        //     ? Column(
                                        //         mainAxisSize: MainAxisSize.min,
                                        //         children: <Widget>[
                                        //           ListView.builder(
                                        //             physics: NeverScrollableScrollPhysics(),
                                        //             itemCount: _taxMasterList.length,
                                        //             shrinkWrap: true,
                                        //             itemBuilder: (context, index) {
                                        //               return Column(
                                        //                 children: <Widget>[
                                        //                   Align(
                                        //                     alignment: Alignment.centerLeft,
                                        //                     child: Padding(
                                        //                       padding: const EdgeInsets.only(top: 10),
                                        //                       child: Text('${_taxMasterList[index].taxName}', style: Theme.of(context).primaryTextTheme.headline3),
                                        //                     ),
                                        //                   ),
                                        //                   TextFormField(
                                        //                     readOnly: true,
                                        //                     textCapitalization: TextCapitalization.characters,
                                        //                     controller: _taxMasterList[index].controller,
                                        //                     inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                                        //                     textInputAction: TextInputAction.done,
                                        //                     onChanged: (v) {
                                        //                       //
                                        //                     },
                                        //                     onTap: () {
                                        //                       _editTax(index);
                                        //                     },
                                        //                     validator: (value) {
                                        //                       if (value.isEmpty) {
                                        //                         return global.appLocaleValues['lbl_percentage_err_req'];
                                        //                       } else if (value.contains(RegExp('[a-zA-Z]'))) {
                                        //                         return global.appLocaleValues['vel_enter_number_only'];
                                        //                       }
                                        //                       return null;
                                        //                     },
                                        //                     decoration: InputDecoration(border: OutlineInputBorder()),
                                        //                   ),
                                        //                 ],
                                        //               );
                                        //             },
                                        //           )
                                        //         ],
                                        //       )
                                        //     : SizedBox(),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
         color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      child: Text(
                        global.appLocaleValues['btn_back'],
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: RegistrationPersonalDetailsScreen(
                              a: widget.analytics,
                              o: widget.observer,
                            )));
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextButton(
                      child: Text(
                        global.appLocaleValues['btn_save_and_next'],
                        style: Theme.of(context).primaryTextTheme.headline2,
                      ),
                      onPressed: () async {
                        await _onSave();
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              (global.business == null || global.business.id == null)
                  ? InkWell(
                      child: Text(
                        'Skip',
                        style: Theme.of(context).primaryTextTheme.headline1,
                      ),
                      onTap: () async {
                        await _onSkip();
                      })
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      _businessInventoryValueList = br.getSystemFlag(global.systemFlagNameList.businessInventory).valueList.split(',').toList();
      if (global.business == null) {
        global.business = Business();
        _cBusinessInventory.text = _businessInventoryValueList[0];
      } else {
        _cName.text = global.business.name;
        _logoPath = global.business.logoPath;
        _cregistrationNo.text = global.business.registrationNo;
        _cGstNo.text = global.business.gstNo;
        _cAddressLine1.text = global.business.addressLine1;
        _cBusinessInventory.text = (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != null) ? br.getSystemFlagValue(global.systemFlagNameList.businessInventory) : 'Service';
      }

      _unitCombinationList = await dbHelper.unitCombinationGetList();
      _unitList = await dbHelper.unitGetList();
      _fetchUnitCode();
      _fDateFormat.addListener(_chooseDateFormate);
      _fProductCodeMaxLen.addListener(_chooseProductCodeMaxLength);
      _fInvoiceNoMaxLen.addListener(_chooseInvoiceNoMaxLength);
      _isEnablePurchaseSupplierModule = (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true') ? true : false;
      _isPurchaseReturnEnable = (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseReturn) == 'true') ? true : false;
      _isSaleOrderEnable = (br.getSystemFlagValue(global.systemFlagNameList.enableSaleOrder) == 'true') ? true : false;
      _isSalesReturnEnable = (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service')
          ? (br.getSystemFlagValue(global.systemFlagNameList.enableSalesReturn) == 'true')
              ? true
              : false
          : false;
      _isUnitEnable = (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service')
          ? (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == 'true')
              ? true
              : false
          : false;
      _isEmployeeEnable = (br.getSystemFlagValue(global.systemFlagNameList.enableEmployee) == 'true') ? true : false;
      UnitCombination _temp = _unitCombinationList.firstWhere((element) => element.id == int.parse(br.getSystemFlagValue(global.systemFlagNameList.defaultUnitCombination)));
      _cDefaultUnitOfMeasure.text = (_temp.secondaryUnitId != null) ? "${_temp.primaryUnit} - ${_temp.secondaryUnit}" : "${_temp.primaryUnit}";
      _cFinantialMonth.text = br.getSystemFlagValue(global.systemFlagNameList.financialMonth);
      if (br.getSystemFlagValue(global.systemFlagNameList.dateFormat) == null) {
        _cProductCodeMaxLen.text = br.getSystemFlag(global.systemFlagNameList.productCodeMaxLength).defaultValue;
        _cInvoiceNoMaxLen.text = br.getSystemFlag(global.systemFlagNameList.invoiceNoMaxLength).defaultValue;
        _cDateFormat.text = br.getSystemFlag(global.systemFlagNameList.dateFormat).defaultValue;
        _cDecimalPlaces.text = br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces);
        _decimalPlacesExample = '${1234.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}';
      } else {
        _cDecimalPlaces.text = br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces);
        _cProductCodePrefix.text = br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix);
        _cProductCodeMaxLen.text = br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength);
        _generateProductCodeExample();
        _cInvoiceNoPrefix.text = br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix);
        _cInvoiceNoMaxLen.text = br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength);
        _generateInvoiceNoExample();
        _cDateFormat.text = br.getSystemFlagValue(global.systemFlagNameList.dateFormat);
        _decimalPlacesExample = '${1234.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}';
      }
    } catch (e) {
      print('Exception - registrationBusinessDetailsScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future<Null> _fBusinessInventoryListerner() async {
    try {
      AlertDialog dialog = AlertDialog(
        title: Text(
          'Business Inventories',
          style: Theme.of(context).primaryTextTheme.headline3,
        ),
        content: Container(
          height: 300,
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: <Widget>[
              ListView.builder(
                itemCount: _businessInventoryValueList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('${_businessInventoryValueList[index]}'),
                      onTap: () {
                        setState(() {
                          Navigator.of(context).pop();
                          _cBusinessInventory.text = _businessInventoryValueList[index];
                        });
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
      await showDialog(context: context, builder: (_) => dialog);
      setState(() {});
    } catch (e) {
      print('Exception - registrationBusinessDetailsScreen.dart - _fBusinessInventoryListerner(): ' + e.toString());
    }
  }

  Future _onSave() async {
    try {
      if (_formKey.currentState.validate()) {
        showLoader(global.appLocaleValues['txt_wait']);
        setState(() {});
        global.business.logoPath = _logoPath;
        if (_cAddressLine1.text.length < 1) {
          global.business.addressLine1 = '';
        }
        global.business.name = _cName.text.isNotEmpty && _cName.text != '' ? _cName.text : 'My Business';
        // _businessInventory = 'Service';
        if (global.business.id == null) {
          // List<TaxMaster> _allTaxList = await dbHelper.taxMasterGetList();
          global.business.id = await dbHelper.businessInsert(global.business);
          global.user.businessId = global.business.id;
          await dbHelper.userUpdate(global.user);
          await dbHelper.sqlScriptInit(global.business.id);

          //updating businessId in taxmaster
          if (_taxMasterList != null && _taxMasterList.length > 0) {
            for (int i = 0; i < _taxMasterList.length; i++) {
              _taxMasterList[i].businessId = global.business.id;
              await dbHelper.taxMasterUpdate(_taxMasterList[i]);
              await dbHelper.taxMasterPercentageUpdate(_taxMasterList[i].id);
            }
          }

          // insert system flags
          // await _setSystemFlags();
        } else {
          await dbHelper.businessUpdate(global.business);
        }
        await _updateDateFormat(_cDateFormat.text.trim());
        await _updateDecimalPlaces(_cDecimalPlaces.text.trim());
        await _updateBusinessInventory(_cBusinessInventory.text.trim());
        // await _updateAccountCodePrefix(_cAccountCodePrefix.text.trim());
        // await _updateAccountCodeMaxLength('5');
        // await _updateProductCodeMaxLength(_cProductCodeMaxLen.text.trim());
        // await _updateInvoiceNoMaxLength(_cInvoiceNoMaxLen.text.trim());
        // await _updateProductCodePrefix(_cProductCodePrefix.text.trim());
        // await _updateInvoiceNoPrefix(_cInvoiceNoPrefix.text.trim());
        // await _updateEnablePurchaseAndSupplierModule(_isEnablePurchaseSupplierModule);
        // await _updateEnablePurchaseReturn(_isPurchaseReturnEnable);
        // await _updateEnableSalesReturn(_isSalesReturnEnable);
        // await _updateUnitMeasurement(_isUnitEnable);
        // await _updateEnableSaleOrder(_isSaleOrderEnable);
        // await _updateEnableEmployee(_isEmployeeEnable);
        // await _updateFinantialMonth(_cFinantialMonth.text.trim());
        hideLoader();
        setState(() {});
        Navigator.of(context).push(PageTransition(
            type: PageTransitionType.rightToLeft,
            child: RegistrationSetSecurityPinScreen(
              a: widget.analytics,
              o: widget.observer,
            )));
      } else {
        _autovalidate = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - registrationBusinessDetailsScreen.dart - _onSave(): ' + e.toString());
    }
  }

  Future _onSkip() async {
    try {
      showLoader(global.appLocaleValues['txt_wait']);
      setState(() {});
      global.business.addressLine1 = '';
      global.business.name = 'My Business';

      List<TaxMaster> _allTaxList = await dbHelper.taxMasterGetList();
      global.business.id = await dbHelper.businessInsert(global.business);
      global.user.businessId = global.business.id;
      await dbHelper.userUpdate(global.user);
      await dbHelper.sqlScriptInit(global.business.id);

      //updating businessId in taxmaster
      if (_allTaxList != null && _allTaxList.length > 0) {
        for (int i = 0; i < _allTaxList.length; i++) {
          _allTaxList[i].businessId = global.business.id;
          await dbHelper.taxMasterUpdate(_allTaxList[i]);
          await dbHelper.taxMasterPercentageUpdate(_allTaxList[i].id);
        }
      }

      // insert system flags
      // await _setSystemFlags();
      hideLoader();
      setState(() {});
      Navigator.of(context).push(PageTransition(
          type: PageTransitionType.rightToLeft,
          child: RegistrationSetSecurityPinScreen(
            a: widget.analytics,
            o: widget.observer,
          )));
    } catch (e) {
      print('Exception - registrationBusinessDetailsScreen.dart - _onSave(): ' + e.toString());
    }
  }

  // Future _setSystemFlags() async {
  //   try {
  //     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.dateFormat, 'yyyy-MM-dd');
  //     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.accountCodeMaxLength, '6');
  //     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.productCodeMaxLength, '6');
  //     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.invoiceNoMaxLength, '6');
  //     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableTax, 'true');
  //     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableProductWiseTax, 'false');
  //     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableProductWiseTax, 'false');
  //     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enablePurchaseAndSupplierModule, 'false');
  //     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableSalesReturn, 'false');
  //     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enablePurchaseReturn, 'false');
  //     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableGoogleBackupRestore, 'true');
  //   } catch (e) {
  //     print('Exception - registrationBusinessDetailsScreen.dart - _setSystemFlags(): ' + e.toString());
  //   }
  // }

  void _openUploadPicOptions(context) {
    try {
      //choose options for upload pic
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bcon) {
            return Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.camera_alt,
                      color: Colors.red,
                    ),
                    title: Text(global.appLocaleValues['txt_camera']),
                    onTap: () {
                      _picImageCamera();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.photo_album,
                      color: Colors.green,
                    ),
                    title: Text(global.appLocaleValues['txt_gallery']),
                    onTap: () {
                      _uploadLogo();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.cancel,
                      color: Colors.cyan,
                    ),
                    title: Text(global.appLocaleValues['txt_remove_profile']),
                    onTap: () {
                      setState(() {
                        _logoPath = null;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.cancel,
                      color: Colors.blueAccent,
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
    } catch (e) {
      print('Exception - registrationBusinessDetailsScreen.dart - _openUploadPicOptions(): ' + e.toString());
    }
  }

  _picImageCamera() async {
    // when user select camera for upload pic
    try {
      final ImagePicker _picker = ImagePicker();
      XFile img;
      img = await _picker.pickImage(source: ImageSource.camera);
      File imageFile = File(img.path);
      if (imageFile != null) {
        _getPath();

        File croppedFile = await ImageCropper.cropImage(
          sourcePath: imageFile.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          maxWidth: 512,
          maxHeight: 512,
        );
        if (croppedFile != null) {
          setState(() {
            _image = croppedFile;
          });
          String imgTime = DateTime.now().toString();
          final File newImage = await _image.copy('$_logoPath/img$imgTime.png');
          //   print('path: ${newImage.path}');
          _logoPath = newImage.path;
        }
      }
    } catch (e) {
      print('Exception - registrationBusinessDetailsScreen.dart - _picImageCamera(): ' + e.toString());
    }
  }

  void _uploadLogo() async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile img;
      img = await _picker.pickImage(source: ImageSource.gallery);
      File imageFile = File(img.path);
      if (imageFile != null) {
        _getPath();
        print(imageFile.path);
        setState(() {
          _image = imageFile;
        });
        String imgTime = DateTime.now().toString();
        final File newImage = await _image.copy('$_logoPath/img$imgTime.png');

        _logoPath = newImage.path;
      }
      setState(() {});
    } catch (e) {
      print('Exception - registrationBusinessDetailsScreen.dart - _uploadLogo(): ' + e.toString());
    }
  }

  Future _getPath() async {
    try {
      _logoPath = global.businessImagesDirectoryPath;
    } catch (e) {
      print('Exception - registrationBusinessDetailsScreen.dart - _getPath(): ' + e.toString());
    }
  }

  // Future _editTax(index) async {
  //   try {
  //     List<TaxMasterPercentage> _tempList = _taxMasterPercentageList.where((element) => element.taxId == _taxMasterList[index].id).toList();
  //     await showDialog(
  //         context: context,
  //         builder: (_) {
  //           return SelectTaxPercentageDialog(
  //             a: widget.analytics,
  //             o: widget.observer,
  //             percentageList: _tempList,
  //           );
  //         }).then((value) {
  //       if (value != null) {
  //         for (int i = 0; i < _taxMasterList.length; i++) {
  //           if (_taxMasterList[index].groupName == _taxMasterList[i].groupName) {
  //             _taxMasterList[i].percentage = value;
  //             _taxMasterList[i].controller.text = value.toString();
  //           }
  //         }
  //         setState(() {});
  //       }
  //     });
  //   } catch (e) {
  //     print('Exception - registrationTaxDetailsScreen.dart - _editTax(): ' + e.toString());
  //   }
  // }

  Future _fillData() async {
    try {
      _taxMasterList = await dbHelper.taxMasterGetList();
      _taxMasterList.forEach((e) {
        // _cList.add(TextEditingController(text: '${element.percentage}%'));
        e.controller.text = e.percentage.toString();
      });
      _taxMasterPercentageList = await dbHelper.taxMasterPercentageGetList();

      _isTaxEnabled = (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true') ? true : false;
      _isTaxProductWiseEnabled = (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') ? true : false;
      setState(() {});
    } catch (e) {
      print('Exception - registrationTaxDetailsScreen.dart - _fillData(): ' + e.toString());
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
      print('Exception - registrationConfigurationScreen.dart - _fetchUnitCode(): ' + e.toString());
    }
  }

  void _generateProductCodeExample() {
    try {
      if (_cProductCodePrefix.text.isEmpty) {
        int _maxLen = int.parse(_cProductCodeMaxLen.text.trim());
        _productCodeExample = '0' * (_maxLen - 1) + '1';
      } else {
        int _maxLen = int.parse(_cProductCodeMaxLen.text) - _cProductCodePrefix.text.length;
        _productCodeExample = '${_cProductCodePrefix.text}' + '0' * (_maxLen - 1) + '1';
      }
    } catch (e) {
      print('Exception - registrationConfigurationScreen.dart - _generateProductCodeExample(): ' + e.toString());
    }
  }

  Future _chooseDecimalPlaces() async {
    try {
      List<String> _decimalPlacesValueList = br.getSystemFlag(global.systemFlagNameList.decimalPlaces).valueList.split(',').toList();
      AlertDialog dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['dia_lbl_decimal_places'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width - 40,
          child: Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _decimalPlacesValueList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text('${_decimalPlacesValueList[index]}'),
                      onTap: () async {
                        Navigator.of(context).pop();
                        setState(() {
                          _cDecimalPlaces.text = '${_decimalPlacesValueList[index]}';
                          _decimalPlacesExample = '${1234.toStringAsFixed(int.parse(_cDecimalPlaces.text))}';
                        });
                      },
                    ),
                    Divider()
                  ],
                );
              },
            ),
          ),
        ),
      );
      await showDialog(context: context, builder: (_) => dialog);
      setState(() {});
    } catch (e) {
      print('Exception - settingsScreen.dart - _chooseDateFormate(): ' + e.toString());
      return null;
    }
  }

  void _generateInvoiceNoExample() {
    try {
      if (_cInvoiceNoPrefix.text.isEmpty) {
        int _maxLen = int.parse(_cInvoiceNoMaxLen.text.trim());
        _invoiceNoExample = '0' * (_maxLen - 1) + '1';
      } else {
        int _maxLen = int.parse(_cInvoiceNoMaxLen.text) - _cInvoiceNoPrefix.text.length;
        _invoiceNoExample = '${_cInvoiceNoPrefix.text}' + '0' * (_maxLen - 1) + '1';
      }
    } catch (e) {
      print('Exception - registrationConfigurationScreen.dart - _generateInvoiceNoExample(): ' + e.toString());
    }
  }

  Future _chooseDateFormate() async {
    try {
      _dateFormatValueList = br.getSystemFlag(global.systemFlagNameList.dateFormat).valueList.split(',').toList();
      if (_fDateFormat.hasFocus) {
        AlertDialog dialog = AlertDialog(
          shape: nativeTheme().dialogTheme.shape,
          title: Text(
            global.appLocaleValues['dia_lbl_date_format'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width - 40,
            child: Scrollbar(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _dateFormatValueList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text('${_dateFormatValueList[index]} (${DateFormat(_dateFormatValueList[index]).format(DateTime.now())})'),
                        onTap: () async {
                          Navigator.of(context).pop();
                          setState(() {
                            _cDateFormat.text = _dateFormatValueList[index];
                          });
                        },
                      ),
                      Divider()
                    ],
                  );
                },
              ),
            ),
          ),
        );
        await showDialog(context: context, builder: (_) => dialog);
        FocusScope.of(context).requestFocus(_fNode);
        setState(() {});
      }
    } catch (e) {
      print('Exception - registrationConfigurationScreen.dart - _chooseDateFormate(): ' + e.toString());
    }
  }

  Future _chooseProductCodeMaxLength() async {
    try {
      if (_fProductCodeMaxLen.hasFocus) {
        _productCodeMaxLengthValueList = br.getSystemFlag(global.systemFlagNameList.productCodeMaxLength).valueList.split(',').toList();
        if (_cProductCodePrefix.text.length == 2) {
          _productCodeMaxLengthValueList.removeAt(0);
          _productCodeMaxLengthValueList.removeAt(0);
        } else if (_cProductCodePrefix.text.length == 3) {
          _productCodeMaxLengthValueList.removeAt(0);
          _productCodeMaxLengthValueList.removeAt(0);
          _productCodeMaxLengthValueList.removeAt(0);
        } else if (_cProductCodePrefix.text.length == 1) {
          _productCodeMaxLengthValueList.removeAt(0);
        }
        AlertDialog dialog = AlertDialog(
          shape: nativeTheme().dialogTheme.shape,
          title: Text(
            global.appLocaleValues['dia_lbl_code_maxlen'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width - 40,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: _productCodeMaxLengthValueList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(_productCodeMaxLengthValueList[index]),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _cProductCodeMaxLen.text = _productCodeMaxLengthValueList[index];
                            _generateProductCodeExample();
                          });
                        },
                      ),
                      Divider()
                    ],
                  );
                },
              ),
            ),
          ),
        );
        await showDialog(context: context, builder: (_) => dialog);
        FocusScope.of(context).requestFocus(_fNode);
        setState(() {});
      }
    } catch (e) {
      print('Exception - registrationConfigurationScreen.dart - _chooseProductCodeMaxLength(): ' + e.toString());
    }
  }

  Future _chooseInvoiceNoMaxLength() async {
    try {
      if (_fInvoiceNoMaxLen.hasFocus) {
        _invoiceNoMaxLengthValueList = br.getSystemFlag(global.systemFlagNameList.invoiceNoMaxLength).valueList.split(',').toList();
        if (_cInvoiceNoPrefix.text.length == 2) {
          _invoiceNoMaxLengthValueList.removeAt(0);
          _invoiceNoMaxLengthValueList.removeAt(0);
        } else if (_cInvoiceNoPrefix.text.length == 3) {
          _invoiceNoMaxLengthValueList.removeAt(0);
          _invoiceNoMaxLengthValueList.removeAt(0);
          _invoiceNoMaxLengthValueList.removeAt(0);
        } else if (_cInvoiceNoPrefix.text.length == 1) {
          _invoiceNoMaxLengthValueList.removeAt(0);
        }
        AlertDialog dialog = AlertDialog(
          shape: nativeTheme().dialogTheme.shape,
          title: Text(
            global.appLocaleValues['dia_lbl_code_maxlen'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width - 40,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: _invoiceNoMaxLengthValueList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(_invoiceNoMaxLengthValueList[index]),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _cInvoiceNoMaxLen.text = _invoiceNoMaxLengthValueList[index];
                            _generateInvoiceNoExample();
                          });
                        },
                      ),
                      Divider()
                    ],
                  );
                },
              ),
            ),
          ),
        );
        await showDialog(context: context, builder: (_) => dialog);
        FocusScope.of(context).requestFocus(_fNode);
        setState(() {});
      }
    } catch (e) {
      print('Exception - registrationConfigurationScreen.dart - _chooseInvoiceNoMaxLength(): ' + e.toString());
    }
  }

  Future _updateDateFormat(String dateFormat) async {
    try {
      await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.dateFormat, dateFormat);
    } catch (e) {
      print('Exception - registrationConfigurationScreen.dart - _updateDateFormat(): ' + e.toString());
    }
  }

  Future _updateDecimalPlaces(String value) async {
    try {
      await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.decimalPlaces, value);
    } catch (e) {
      print('Exception - registrationConfigurationScreen.dart - _updateDecimalPlaces(): ' + e.toString());
    }
  }

  Future _updateBusinessInventory(String value) async {
    try {
      await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.businessInventory, value);
    } catch (e) {
      print('Exception - registrationConfigurationScreen.dart - _updateBusinessInventory(): ' + e.toString());
    }
  }

  
}
