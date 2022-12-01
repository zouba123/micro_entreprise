// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/dialogs/unitCombinationSelectDialog.dart';
import 'package:accounting_app/screens/selectLanguageScreen.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/unitCombinationModel.dart';
import 'package:accounting_app/models/unitModel.dart';
import 'package:accounting_app/models/userModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';

class SettingsScreen extends BaseRoute {
  SettingsScreen({@required a, @required o}) : super(a: a, o: o, r: 'SettingsScreen');
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends BaseRouteState {
  var _cDateFormat = TextEditingController();
  var _cDecimalPlaces = TextEditingController();
  var _cSalesReturnDays = TextEditingController();
  var _cPurchaseReturnDays = TextEditingController();
  var _cInitialInvoiceNumber = TextEditingController();
  var _cInitialSalesQuoteNumber = TextEditingController();
  var _cInitialSalesOrderNumber = TextEditingController();
  // var _cAccountCodeMaxLen = TextEditingController();
  var _cProductCodePrefix = TextEditingController();
  var _cProductCodeMaxLen = TextEditingController();
  var _cInvoiceNoPrefix = TextEditingController();
  var _cInvoiceNoMaxLen = TextEditingController();
  var _cInvoicePdfFooter = TextEditingController();
  var _cPaymentPdfFooter = TextEditingController();
  var _cTermsAndCondition = TextEditingController();
  var _cDefaultUnitOfMeasure = TextEditingController();
  var _cFinantialMonth = TextEditingController();
  // String _accountCodeExample;
  bool _isSalesReturnEnable = false;
  bool _isEnablePurchaseSupplierModule = true;
  bool _isProductSupplierCode = false;
  String _decimalPlacesExample;
  bool _isPurchaseReturnEnable = true;
  List<User> appUserList = [];
  bool _isUnitModuleEnabled = true;
//  List<String> _accountCodeMaxLengthValueList = [];
  // List<String> _productCodeMaxLengthValueList = [];
  // List<String> _invoiceNoMaxLengthValueList = [];
  bool _isEmployeeEnable = true;
  bool _isSaleOrderEnable = true;
  // bool _isGoogleBackupRestoreEnable = false;
  bool _isAskPinAlways = false;
  bool _isFringerPrintOn = false;

  // bool _isShowSaleInvoicesSeprated = true;
//  bool _isShowPurchaseInvoicesSeprated = true;
  List<UnitCombination> _unitCombinationList;
  List<Unit> _unitList;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _cReminderTime = TextEditingController();
  var _cNotificationTime = TextEditingController();

  _SettingsScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            global.appLocaleValues['lbl_setting'],
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width - 90,
          child: DrawerWidget(a: widget.analytics, o: widget.observer, routeName: widget.routeName),
        ),
        body: WillPopScope(
          onWillPop: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DashboardScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
            return null;
          },
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    // Card(
                    //   shape: nativeTheme().cardTheme.shape,
                    //   child: Column(
                    //     children: <Widget>[
                    //       Text(
                    //         'Account Code Configuration',
                    //         style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Expanded(
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(5),
                    //               child: Padding(
                    //                 padding: EdgeInsets.only(top: 10),
                    //                 child: TextFormField(
                    //                   textCapitalization: TextCapitalization.characters,
                    //                   keyboardType: TextInputType.text,
                    //                   inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Z]'))],
                    //                   maxLength: 3,
                    //                   onChanged: (v) async {
                    //                     if (v.length == 0) {
                    //                       _cAccountCodeMaxLen.text = '4';
                    //                     } else if (v.length == 1) {
                    //                       _cAccountCodeMaxLen.text = '5';
                    //                     } else if (v.length == 2) {
                    //                       _cAccountCodeMaxLen.text = '6';
                    //                     } else if (v.length == 3) {
                    //                       _cAccountCodeMaxLen.text = '7';
                    //                     }
                    //                     await br.updateSystemFlag(global.systemFlagNameList.accountCodePrefix, (_cAccountCodePrefix.text != '') ? _cAccountCodePrefix.text.trim() : '');
                    //                     await br.updateSystemFlag(global.systemFlagNameList.accountCodeMaxLength, _cAccountCodeMaxLen.text.trim());
                    //                     setState(() {
                    //                       _generateAccountCodeExample();
                    //                     });
                    //                   },
                    //                   controller: _cAccountCodePrefix,
                    //                   decoration: InputDecoration(hintText: '', border: nativeTheme().inputDecorationTheme.border, labelText: global.appLocaleValues['lbl_pre'], counterText: ''),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Expanded(
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(5),
                    //               child: Padding(
                    //                 padding: EdgeInsets.only(top: 10),
                    //                 child: TextFormField(
                    //                   validator: (v) {
                    //                     if (v.isEmpty) {
                    //                       return 'Choose account code max length';
                    //                     }
                    //                     return null;
                    //                   },
                    //                   controller: _cAccountCodeMaxLen,
                    //                   readOnly: true,
                    //                   decoration: InputDecoration(
                    //                       hintText: '',
                    //
                    //                       border: nativeTheme().inputDecorationTheme.border,
                    //                       labelText: global.appLocaleValues['lbl_max_len']),
                    //                   onTap: () async {
                    //                     await _chooseAccountCodeMaxLength();
                    //                   },
                    //                 ),
                    //               ),
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 5,
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Text(
                    //             ' Account code example: ',
                    //             style: TextStyle(color: Colors.grey, fontSize: 15),
                    //           ),
                    //           Text(
                    //             '$_accountCodeExample',
                    //             style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    //           )
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 20,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
                    //   child: Column(
                    //     children: [
                    //       // Row(
                    //       //   children: [
                    //       //     Text(global.appLocaleValues['tle_app_language'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey)),
                    //       //   ],
                    //       // ),
                    //       Container(
                    //         height: 40,
                    //         child: ListTile(
                    //           contentPadding: EdgeInsets.all(0),
                    //           leading: Icon(Icons.translate),
                    //           title: (global.appLanguage['name'] == 'English') ? Text('${global.appLanguage['name']}') : Text('${global.appLanguage['name']}  (${global.appLanguage['title']})'),
                    //           onTap: () async {
                    //             Navigator.of(context).push(MaterialPageRoute(
                    //                 builder: (BuildContext context) =>  SelectLanguageScreen(
                    //                       a: widget.analytics,
                    //                       o: widget.observer,
                    //                       screenId: 1,
                    //                     )));
                    //           },
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 0, bottom: 5),
                    //   child: Divider(),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
                    //   child: Column(
                    //     children: <Widget>[
                    //       Row(
                    //         children: [
                    //           Text('${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product_code_config'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service_code_config'] : global.appLocaleValues['tle_both_code_config']}',
                    //               style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey)),
                    //         ],
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Expanded(
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(5),
                    //               child: Padding(
                    //                 padding: EdgeInsets.only(top: 10),
                    //                 child: TextFormField(
                    //                   textCapitalization: TextCapitalization.characters,
                    //                   keyboardType: TextInputType.text,
                    //                   //  inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Z]'))],
                    //                   inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Z]'))],

                    //                   maxLength: 3,
                    //                   onChanged: (v) async {
                    //                     if (v.length == 0) {
                    //                       _cProductCodeMaxLen.text = '4';
                    //                     } else if (v.length == 1) {
                    //                       _cProductCodeMaxLen.text = '5';
                    //                     } else if (v.length == 2) {
                    //                       _cProductCodeMaxLen.text = '6';
                    //                     } else if (v.length == 3) {
                    //                       _cProductCodeMaxLen.text = '7';
                    //                     }
                    //                     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.productCodePrefix, (_cProductCodePrefix.text != '') ? _cProductCodePrefix.text.trim() : '');
                    //                     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.productCodeMaxLength, _cProductCodeMaxLen.text.trim());
                    //                     setState(() {
                    //                       _generateProductCodeExample();
                    //                     });
                    //                   },
                    //                   controller: _cProductCodePrefix,
                    //                   decoration: InputDecoration(hintText: '', labelText: global.appLocaleValues['lbl_pre'], border: nativeTheme().inputDecorationTheme.border, counterText: ''),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Expanded(
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(5),
                    //               child: Padding(
                    //                 padding: EdgeInsets.only(top: 10),
                    //                 child: TextFormField(
                    //                   controller: _cProductCodeMaxLen,
                    //                   validator: (v) {
                    //                     if (v.isEmpty) {
                    //                       //  return 'Choose ${br.getSystemFlagValue("businessInventory")} code max length';
                    //                     }
                    //                     return null;
                    //                   },
                    //                   readOnly: true,
                    //                   decoration: InputDecoration(hintText: '', border: nativeTheme().inputDecorationTheme.border, labelText: global.appLocaleValues['lbl_max_len']),
                    //                   onTap: () async {
                    //                     await _chooseProductCodeMaxLength();
                    //                   },
                    //                 ),
                    //               ),
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 5,
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Text(
                    //             ' ${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_code_ex'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_service_code_ex'] : global.appLocaleValues['lbl_both_code_ex']}: ',
                    //             style: TextStyle(color: Colors.grey, fontSize: 15),
                    //           ),
                    //           Text(
                    //             '$_productCodeExample',
                    //             style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    //           )
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                    //   child: Divider(),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    //   child: Column(
                    //     children: <Widget>[
                    //       Row(
                    //         children: [
                    //           Text(global.appLocaleValues['tle_sale_invoice_config'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey)),
                    //         ],
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Expanded(
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(5),
                    //               child: Padding(
                    //                 padding: EdgeInsets.only(top: 10),
                    //                 child: TextFormField(
                    //                   textCapitalization: TextCapitalization.characters,
                    //                   keyboardType: TextInputType.text,
                    //                   //   inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Z]'))],
                    //                   inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Z]'))],

                    //                   maxLength: 3,
                    //                   onChanged: (v) async {
                    //                     if (v.length == 0) {
                    //                       _cInvoiceNoMaxLen.text = '5';
                    //                     } else if (v.length == 1) {
                    //                       _cInvoiceNoMaxLen.text = '6';
                    //                     } else if (v.length == 2) {
                    //                       _cInvoiceNoMaxLen.text = '7';
                    //                     } else if (v.length == 3) {
                    //                       _cInvoiceNoMaxLen.text = '8';
                    //                     }
                    //                     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.invoiceNoPrefix, (_cInvoiceNoPrefix.text != '') ? _cInvoiceNoPrefix.text.trim() : '');
                    //                     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.invoiceNoMaxLength, _cInvoiceNoMaxLen.text.trim());
                    //                     setState(() {
                    //                       _generateInvoiceNoExample();
                    //                     });
                    //                   },
                    //                   controller: _cInvoiceNoPrefix,
                    //                   decoration: InputDecoration(hintText: '', labelText: global.appLocaleValues['lbl_pre'], border: nativeTheme().inputDecorationTheme.border, counterText: ''),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Expanded(
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(5),
                    //               child: Padding(
                    //                 padding: EdgeInsets.only(top: 10),
                    //                 child: TextFormField(
                    //                   controller: _cInvoiceNoMaxLen,
                    //                   validator: (v) {
                    //                     if (v.isEmpty) {
                    //                       return global.appLocaleValues['vel_invoiceno_max_len'];
                    //                     }
                    //                     return null;
                    //                   },
                    //                   readOnly: true,
                    //                   decoration: InputDecoration(hintText: '', border: nativeTheme().inputDecorationTheme.border, labelText: global.appLocaleValues['lbl_max_len']),
                    //                   onTap: () async {
                    //                     await _chooseInvoiceNoMaxLength();
                    //                   },
                    //                 ),
                    //               ),
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 5,
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Text(
                    //             global.appLocaleValues['lbl_invoiceno_example'],
                    //             style: TextStyle(color: Colors.grey, fontSize: 15),
                    //           ),
                    //           Text(
                    //             ' $_invoiceNoExample',
                    //             style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    //           )
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                    //   child: Divider(),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    //   child: Column(
                    //     children: <Widget>[
                    //       Row(
                    //         children: [
                    //           Text(global.appLocaleValues['tle_inv_recipt_confing'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey)),
                    //         ],
                    //       ),
                    //       //
                    //       Container(
                    //         width: MediaQuery.of(context).size.width,
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
                    //           child: Stack(
                    //             alignment: Alignment.centerRight,
                    //             children: <Widget>[
                    //               TextFormField(
                    //                 maxLines: 3,
                    //                 controller: _cInvoicePdfFooter,
                    //                 decoration: InputDecoration(
                    //                   hintText: '${global.appLocaleValues['lbl_inv_footer']} ',
                    //                   labelText: '${global.appLocaleValues['lbl_inv_footer']} (${global.appLocaleValues['lbl_optional']})',
                    //                   border: nativeTheme().inputDecorationTheme.border,
                    //                 ),
                    //                 onChanged: (value) async {
                    //                   await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.invoicePdfFooter, (_cInvoicePdfFooter.text != '') ? _cInvoicePdfFooter.text.trim() : '');
                    //                 },
                    //               ),
                    //               IconButton(
                    //                 icon: Icon(
                    //                   Icons.info,
                    //                   color: Colors.grey,
                    //                   size: 20,
                    //                 ),
                    //                 onPressed: () {
                    //                   showInfoMessage(
                    //                       global.appLocaleValues['lbl_inv_footer'],
                    //                       global.systemFlagNameList.invoicePdfFooter,
                    //                       Icon(
                    //                         Icons.info,
                    //                         color: Theme.of(context).primaryColor,
                    //                       ));
                    //                 },
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       //
                    //       // Padding(
                    //       //   padding: const EdgeInsets.all(5),
                    //       //   child: Padding(
                    //       //     padding: EdgeInsets.only(top: 10),
                    //       //     child: Row(
                    //       //       mainAxisSize: MainAxisSize.min,
                    //       //       children: <Widget>[
                    //       //         Expanded(
                    //       //           child: TextFormField(
                    //       //             maxLines: 3,
                    //       //             controller: _cInvoicePdfFooter,
                    //       //             decoration: InputDecoration(
                    //       //               hintText: '${global.appLocaleValues['lbl_inv_footer']} ',
                    //       //               labelText: '${global.appLocaleValues['lbl_inv_footer']} (${global.appLocaleValues['lbl_optional']})',
                    //       //               border: nativeTheme().inputDecorationTheme.border,
                    //       //             ),
                    //       //             onChanged: (value) async {
                    //       //               await br.updateSystemFlag(global.systemFlagNameList.invoicePdfFooter, (_cInvoicePdfFooter.text != '') ? _cInvoicePdfFooter.text.trim() : '');
                    //       //             },
                    //       //           ),
                    //       //         ),
                    //       //         IconButton(
                    //       //           icon: Icon(
                    //       //             Icons.info,
                    //       //             color: Colors.grey,
                    //       //             size: 20,
                    //       //           ),
                    //       //           onPressed: () {
                    //       //             showInfoMessage(global.appLocaleValues['lbl_inv_footer'],global.systemFlagNameList.invoicePdfFooter, Icon(Icons.info,color: Colors.blue,));
                    //       //           },
                    //       //         )
                    //       //       ],
                    //       //     ),
                    //       //   ),
                    //       // ),
                    //       Container(
                    //         width: MediaQuery.of(context).size.width,
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(5),
                    //           child: Stack(
                    //             alignment: Alignment.centerRight,
                    //             children: <Widget>[
                    //               TextFormField(
                    //                 maxLines: 3,
                    //                 controller: _cPaymentPdfFooter,
                    //                 decoration: InputDecoration(
                    //                   hintText: '${global.appLocaleValues['lbl_receipt_footer']}',
                    //                   labelText: '${global.appLocaleValues['lbl_receipt_footer']} (${global.appLocaleValues['lbl_optional']})',
                    //                   border: nativeTheme().inputDecorationTheme.border,
                    //                 ),
                    //                 onChanged: (value) async {
                    //                   await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.paymentPdfFooter, (_cPaymentPdfFooter.text != '') ? _cPaymentPdfFooter.text.trim() : '');
                    //                 },
                    //               ),
                    //               IconButton(
                    //                 icon: Icon(
                    //                   Icons.info,
                    //                   color: Colors.grey,
                    //                   size: 20,
                    //                 ),
                    //                 onPressed: () {
                    //                   //     showDesc(global.systemFlagNameList.paymentPdfFooter, global.appLocaleValues['lbl_receipt_footer']);
                    //                   showInfoMessage(
                    //                       global.appLocaleValues['lbl_receipt_footer'],
                    //                       global.systemFlagNameList.paymentPdfFooter,
                    //                       Icon(
                    //                         Icons.info,
                    //                         color: Theme.of(context).primaryColor,
                    //                       ));
                    //                 },
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       //
                    //       // Padding(
                    //       //   padding: const EdgeInsets.all(5),
                    //       //   child: Row(
                    //       //     mainAxisSize: MainAxisSize.min,
                    //       //     children: <Widget>[
                    //       //       Expanded(
                    //       //         child: TextFormField(
                    //       //           maxLines: 3,
                    //       //           controller: _cPaymentPdfFooter,
                    //       //           decoration: InputDecoration(
                    //       //             hintText: '${global.appLocaleValues['lbl_receipt_footer']}',
                    //       //             labelText: '${global.appLocaleValues['lbl_receipt_footer']} (${global.appLocaleValues['lbl_optional']})',
                    //       //             border: nativeTheme().inputDecorationTheme.border,
                    //       //           ),
                    //       //           onChanged: (value) async {
                    //       //             await br.updateSystemFlag(global.systemFlagNameList.paymentPdfFooter, (_cPaymentPdfFooter.text != '') ? _cPaymentPdfFooter.text.trim() : '');
                    //       //           },
                    //       //         ),
                    //       //       ),
                    //       //       IconButton(
                    //       //         icon: Icon(
                    //       //           Icons.info,
                    //       //           color: Colors.grey,
                    //       //           size: 20,
                    //       //         ),
                    //       //         onPressed: () {
                    //       //           //     showDesc(global.systemFlagNameList.paymentPdfFooter, global.appLocaleValues['lbl_receipt_footer']);
                    //       //           showInfoMessage(
                    //       //               global.appLocaleValues['lbl_receipt_footer'],
                    //       //               global.systemFlagNameList.paymentPdfFooter,
                    //       //               Icon(
                    //       //                 Icons.info,
                    //       //                 color: Colors.blue,
                    //       //               ));
                    //       //         },
                    //       //       )
                    //       //     ],
                    //       //   ),
                    //       // ),

                    //       //
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                    //   child: Divider(),
                    // ),
                    // (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service')
                    //     ? Padding(
                    //         padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                    //         child: Column(
                    //           children: <Widget>[
                    //             Row(
                    //               children: [
                    //                 Text('${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_return_pro_confing'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_return_ser_confing'] : global.appLocaleValues['tle_return_both_confing']}',
                    //                     style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey)),
                    //               ],
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.only(left: 5, right: 5),
                    //               child: Column(
                    //                 children: <Widget>[
                    //                   Column(
                    //                     children: <Widget>[
                    //                       ListTile(
                    //                         contentPadding: EdgeInsets.only(left: 0),
                    //                         leading: Row(
                    //                           mainAxisSize: MainAxisSize.min,
                    //                           children: <Widget>[
                    //                             Text(
                    //                               global.appLocaleValues['lbl_sales_return'],
                    //                               style: TextStyle(fontSize: 16),
                    //                             ),
                    //                             IconButton(
                    //                               icon: Icon(
                    //                                 Icons.info,
                    //                                 color: Colors.grey,
                    //                                 size: 20,
                    //                               ),
                    //                               onPressed: () {
                    //                                 //     showDesc(global.systemFlagNameList.enableSalesReturn, global.appLocaleValues['lbl_sales_return']);
                    //                                 showInfoMessage(
                    //                                     global.appLocaleValues['lbl_sales_return'],
                    //                                     global.systemFlagNameList.enableSalesReturn,
                    //                                     Icon(
                    //                                       Icons.info,
                    //                                       color: Theme.of(context).primaryColor,
                    //                                     ));
                    //                               },
                    //                             )
                    //                           ],
                    //                         ),
                    //                         trailing: Switch(
                    //                           value: _isSalesReturnEnable,
                    //                           onChanged: (value) async {
                    //                             _isSalesReturnEnable = value;
                    //                             await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableSalesReturn, _isSalesReturnEnable.toString());
                    //                             setState(() {});
                    //                           },
                    //                         ),
                    //                       ),
                    //                       (_isSalesReturnEnable)
                    //                           ? Container(
                    //                               width: MediaQuery.of(context).size.width,
                    //                               child: Stack(
                    //                                 alignment: Alignment.centerRight,
                    //                                 children: <Widget>[
                    //                                   TextFormField(
                    //                                     readOnly: true,
                    //                                     onTap: () async {
                    //                                       await _chooseReturnDays(true);
                    //                                     },
                    //                                     controller: _cSalesReturnDays,
                    //                                     decoration: InputDecoration(
                    //                                       labelText: global.appLocaleValues['lbl_sales_return_days'],
                    //                                       border: nativeTheme().inputDecorationTheme.border,
                    //                                     ),
                    //                                   ),
                    //                                   IconButton(
                    //                                     icon: Icon(
                    //                                       Icons.info,
                    //                                       color: Colors.grey,
                    //                                       size: 20,
                    //                                     ),
                    //                                     onPressed: () {
                    //                                       //   showDesc(global.systemFlagNameList.salesReturnDays, global.appLocaleValues['lbl_sales_return_days']);
                    //                                       showInfoMessage(
                    //                                           global.appLocaleValues['lbl_sales_return_days'],
                    //                                           global.systemFlagNameList.salesReturnDays,
                    //                                           Icon(
                    //                                             Icons.info,
                    //                                             color: Theme.of(context).primaryColor,
                    //                                           ));
                    //                                     },
                    //                                   )
                    //                                 ],
                    //                               ),
                    //                             )
                    //                           //  Row(
                    //                           //     mainAxisSize: MainAxisSize.min,
                    //                           //     children: <Widget>[
                    //                           //       Expanded(
                    //                           //         child: ,
                    //                           //       ),

                    //                           //     ],
                    //                           //   )
                    //                           : SizedBox(),
                    //                       (_isSalesReturnEnable && _isEnablePurchaseSupplierModule) ? SizedBox(height: 7) : SizedBox()
                    //                     ],
                    //                   ),
                    //                   (_isSalesReturnEnable && _isEnablePurchaseSupplierModule) ? Divider() : SizedBox(),
                    //                   (_isEnablePurchaseSupplierModule)
                    //                       ? Column(
                    //                           children: <Widget>[
                    //                             ListTile(
                    //                               contentPadding: EdgeInsets.only(left: 0),
                    //                               leading: Row(
                    //                                 mainAxisSize: MainAxisSize.min,
                    //                                 children: <Widget>[
                    //                                   Text(
                    //                                     global.appLocaleValues['lbl_purchase_return'],
                    //                                     style: TextStyle(fontSize: 16),
                    //                                   ),
                    //                                   IconButton(
                    //                                     icon: Icon(
                    //                                       Icons.info,
                    //                                       color: Colors.grey,
                    //                                       size: 20,
                    //                                     ),
                    //                                     onPressed: () {
                    //                                       // showDesc(global.systemFlagNameList.enablePurchaseReturn, global.appLocaleValues['lbl_purchase_return']);
                    //                                       showInfoMessage(
                    //                                           global.appLocaleValues['lbl_purchase_return'],
                    //                                           global.systemFlagNameList.enablePurchaseReturn,
                    //                                           Icon(
                    //                                             Icons.info,
                    //                                             color: Theme.of(context).primaryColor,
                    //                                           ));
                    //                                     },
                    //                                   )
                    //                                 ],
                    //                               ),
                    //                               trailing: Switch(
                    //                                 value: _isPurchaseReturnEnable,
                    //                                 onChanged: (value) async {
                    //                                   _isPurchaseReturnEnable = value;
                    //                                   await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enablePurchaseReturn, _isPurchaseReturnEnable.toString());
                    //                                   setState(() {});
                    //                                 },
                    //                               ),
                    //                             ),
                    //                             (_isPurchaseReturnEnable)
                    //                                 ? Container(
                    //                                     width: MediaQuery.of(context).size.width,
                    //                                     child: Stack(
                    //                                       alignment: Alignment.centerRight,
                    //                                       children: <Widget>[
                    //                                         TextFormField(
                    //                                           readOnly: true,
                    //                                           onTap: () async {
                    //                                             await _chooseReturnDays(false);
                    //                                           },
                    //                                           controller: _cPurchaseReturnDays,
                    //                                           decoration: InputDecoration(
                    //                                             labelText: global.appLocaleValues['lbl_purchase_return_days'],
                    //                                             border: nativeTheme().inputDecorationTheme.border,
                    //                                           ),
                    //                                         ),
                    //                                         IconButton(
                    //                                           icon: Icon(
                    //                                             Icons.info,
                    //                                             color: Colors.grey,
                    //                                             size: 20,
                    //                                           ),
                    //                                           onPressed: () {
                    //                                             showInfoMessage(
                    //                                                 global.appLocaleValues['lbl_purchase_return_days'],
                    //                                                 global.systemFlagNameList.purchaseReturnDays,
                    //                                                 Icon(
                    //                                                   Icons.info,
                    //                                                   color: Theme.of(context).primaryColor,
                    //                                                 ));
                    //                                           },
                    //                                         )
                    //                                       ],
                    //                                     ),
                    //                                   )
                    //                                 : SizedBox(),
                    //                           ],
                    //                         )
                    //                       : SizedBox(),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     : SizedBox(),
                    // (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service')
                    //     ? Padding(
                    //         padding: const EdgeInsets.only(top: 5, bottom: 5),
                    //         child: Divider(),
                    //       )
                    //     : SizedBox(),
                    // (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service')
                    //     ? Padding(
                    //         padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    //         child: Column(
                    //           children: <Widget>[
                    //             Row(
                    //               children: [
                    //                 Text(global.appLocaleValues['tle_purchase_supplier_confing'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey)),
                    //               ],
                    //             ),
                    //             ListTile(
                    //               contentPadding: EdgeInsets.only(left: 5),
                    //               leading: Row(
                    //                 mainAxisSize: MainAxisSize.min,
                    //                 children: <Widget>[
                    //                   Text(
                    //                     global.appLocaleValues['lbl_purchase_supplier'],
                    //                     style: TextStyle(fontSize: 16),
                    //                   ),
                    //                   IconButton(
                    //                     icon: Icon(
                    //                       Icons.info,
                    //                       color: Colors.grey,
                    //                       size: 20,
                    //                     ),
                    //                     onPressed: () {
                    //                       //  showDesc(global.systemFlagNameList.enablePurchaseAndSupplierModule, global.appLocaleValues['lbl_purchase_supplier']);
                    //                       showInfoMessage(
                    //                           global.appLocaleValues['lbl_purchase_supplier'],
                    //                           global.systemFlagNameList.enablePurchaseAndSupplierModule,
                    //                           Icon(
                    //                             Icons.info,
                    //                             color: Theme.of(context).primaryColor,
                    //                           ));
                    //                     },
                    //                   )
                    //                 ],
                    //               ),
                    //               trailing: Switch(
                    //                 value: _isEnablePurchaseSupplierModule,
                    //                 onChanged: (value) async {
                    //                   if (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service') {
                    //                     _isEnablePurchaseSupplierModule = value;
                    //                   } else {
                    //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['txt_product_vld']}')));
                    //                   }
                    //                   await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enablePurchaseAndSupplierModule, _isEnablePurchaseSupplierModule.toString());
                    //                   setState(() {});
                    //                 },
                    //               ),
                    //             ),
                    //             (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true')
                    //                 ? ListTile(
                    //                     contentPadding: EdgeInsets.only(left: 5),
                    //                     leading: Row(
                    //                       mainAxisSize: MainAxisSize.min,
                    //                       children: <Widget>[
                    //                         Text(
                    //                           global.appLocaleValues['lbl_use_pro_supplier_code'],
                    //                           style: TextStyle(fontSize: 16),
                    //                         ),
                    //                         IconButton(
                    //                           icon: Icon(
                    //                             Icons.info,
                    //                             color: Colors.grey,
                    //                             size: 20,
                    //                           ),
                    //                           onPressed: () {
                    //                             //  showDesc(global.systemFlagNameList.useProductSupplierCode, global.appLocaleValues['lbl_use_pro_supplier_code']);
                    //                             showInfoMessage(
                    //                                 global.appLocaleValues['lbl_use_pro_supplier_code'],
                    //                                 global.systemFlagNameList.useProductSupplierCode,
                    //                                 Icon(
                    //                                   Icons.info,
                    //                                   color: Theme.of(context).primaryColor,
                    //                                 ));
                    //                           },
                    //                         )
                    //                       ],
                    //                     ),
                    //                     trailing: Switch(
                    //                       value: _isProductSupplierCode,
                    //                       onChanged: (value) async {
                    //                         _isProductSupplierCode = value;
                    //                         await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.useProductSupplierCode, _isProductSupplierCode.toString());
                    //                         setState(() {});
                    //                       },
                    //                     ),
                    //                   )
                    //                 : SizedBox(),
                    //           ],
                    //         ),
                    //       )
                    //     : SizedBox(),

                    // (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service')
                    //     ? Padding(
                    //         padding: const EdgeInsets.only(top: 5, bottom: 5),
                    //         child: Divider(),
                    //       )
                    //     : SizedBox(),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    //   child: Column(
                    //     children: <Widget>[
                    //       Row(
                    //         children: [
                    //           Text(global.appLocaleValues['lbl_tax_config'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey)),
                    //         ],
                    //       ),
                    //       ListTile(
                    //         contentPadding: EdgeInsets.only(left: 5),
                    //         leading: Row(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: <Widget>[
                    //             Text(
                    //               global.appLocaleValues['lbl_enable_tax'],
                    //               style: TextStyle(fontSize: 16),
                    //             ),
                    //             IconButton(
                    //               icon: Icon(
                    //                 Icons.info,
                    //                 color: Colors.grey,
                    //                 size: 20,
                    //               ),
                    //               onPressed: () {
                    //                 // showDesc(global.systemFlagNameList.enableTax, global.appLocaleValues['lbl_enable_tax']);
                    //                 showInfoMessage(
                    //                     global.appLocaleValues['lbl_enable_tax'],
                    //                     global.systemFlagNameList.enableTax,
                    //                     Icon(
                    //                       Icons.info,
                    //                       color: Theme.of(context).primaryColor,
                    //                     ));
                    //               },
                    //             )
                    //           ],
                    //         ),
                    //         trailing: Switch(
                    //           value: _isTaxEnable,
                    //           onChanged: (value) async {
                    //             _isTaxEnable = value;
                    //             _isProductWiseTaxEnable = false;
                    //             await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableTax, _isTaxEnable.toString());
                    //             await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableProductWiseTax, _isProductWiseTaxEnable.toString());
                    //             if (!_isTaxEnable) {
                    //               await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.showSaleOrdersSeprated, false.toString());
                    //               await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.showSaleInvoicesSeprated, false.toString());
                    //               await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.showPurchaseInvoicesSeprated, false.toString());
                    //             }
                    //             setState(() {});
                    //           },
                    //         ),
                    //       ),
                    //       ListTile(
                    //         contentPadding: EdgeInsets.only(left: 5),
                    //         enabled: false,
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
                    //                 //    showDesc(global.systemFlagNameList.enableProductWiseTax, (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_enable_product_wise_tax'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_enable_service_wise_tax'] : global.appLocaleValues['lbl_enable_both_wise_tax']);
                    //                 showInfoMessage(
                    //                     (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_enable_product_wise_tax'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_enable_service_wise_tax'] : global.appLocaleValues['lbl_enable_both_wise_tax'],
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
                    //           value: _isProductWiseTaxEnable,
                    //           onChanged: (value) async {
                    //             if (_isTaxEnable) {
                    //               _isProductWiseTaxEnable = value;
                    //               await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableProductWiseTax, _isProductWiseTaxEnable.toString());
                    //             } else {
                    //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enable tax first')));
                    //             }
                    //             setState(() {});
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                    //   child: Divider(),
                    // ),
                    // (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service')
                    //     ? Padding(
                    //         padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    //         child: Column(
                    //           children: <Widget>[
                    //             Row(
                    //               children: [
                    //                 Text(global.appLocaleValues['tle_unit_config'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey)),
                    //               ],
                    //             ),
                    //             ListTile(
                    //               contentPadding: EdgeInsets.only(left: 5),
                    //               leading: Row(
                    //                 mainAxisSize: MainAxisSize.min,
                    //                 children: <Widget>[
                    //                   Text(
                    //                     global.appLocaleValues['lbl_unit_'],
                    //                     style: TextStyle(fontSize: 16),
                    //                   ),
                    //                   IconButton(
                    //                     icon: Icon(
                    //                       Icons.info,
                    //                       color: Colors.grey,
                    //                       size: 20,
                    //                     ),
                    //                     onPressed: () {
                    //                       //  showDesc(global.systemFlagNameList.enableUnitModule, global.appLocaleValues['lbl_unit_']);
                    //                       showInfoMessage(
                    //                           global.appLocaleValues['lbl_unit_'],
                    //                           global.systemFlagNameList.enableUnitModule,
                    //                           Icon(
                    //                             Icons.info,
                    //                             color: Theme.of(context).primaryColor,
                    //                           ));
                    //                     },
                    //                   )
                    //                 ],
                    //               ),
                    //               trailing: Switch(
                    //                 value: _isUnitModuleEnabled,
                    //                 onChanged: (value) async {
                    //                   _isUnitModuleEnabled = value;
                    //                   await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableUnitModule, _isUnitModuleEnabled.toString());
                    //                   setState(() {});
                    //                 },
                    //               ),
                    //             ),
                    //             (_isUnitModuleEnabled)
                    //                 ? Padding(
                    //                     padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
                    //                     child: Container(
                    //                       width: MediaQuery.of(context).size.width,
                    //                       child: Stack(
                    //                         alignment: Alignment.centerRight,
                    //                         children: <Widget>[
                    //                           TextFormField(
                    //                             readOnly: true,
                    //                             controller: _cDefaultUnitOfMeasure,
                    //                             decoration: InputDecoration(
                    //                               hintText: '',
                    //                               labelText: global.appLocaleValues['lbl_default_unit_combintion'],
                    //                               border: nativeTheme().inputDecorationTheme.border,
                    //                             ),
                    //                             onTap: () async {
                    //                               await _selectCombination();
                    //                             },
                    //                           ),
                    //                           IconButton(
                    //                             icon: Icon(
                    //                               Icons.info,
                    //                               color: Colors.grey,
                    //                               size: 20,
                    //                             ),
                    //                             onPressed: () {
                    //                               //   showDesc(global.systemFlagNameList.defaultUnitCombination, global.appLocaleValues['lbl_default_unit_combintion']);
                    //                               showInfoMessage(
                    //                                   global.appLocaleValues['lbl_default_unit_combintion'],
                    //                                   global.systemFlagNameList.defaultUnitCombination,
                    //                                   Icon(
                    //                                     Icons.info,
                    //                                     color: Theme.of(context).primaryColor,
                    //                                   ));
                    //                             },
                    //                           )
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   )
                    //                 : SizedBox()
                    //           ],
                    //         ),
                    //       )
                    //     : SizedBox(),
                    // (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service')
                    //     ? Padding(
                    //         padding: const EdgeInsets.only(top: 5, bottom: 5),
                    //         child: Divider(),
                    //       )
                    //     : SizedBox(),
                    Column(
                      children: <Widget>[
                        Align(alignment: Alignment.centerLeft, child: Text(global.appLocaleValues['lbl_general_config'], style: Theme.of(context).primaryTextTheme.headline6)),
                        // ListTile(
                        //   contentPadding: EdgeInsets.only(left: 5),
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
                        //           //    showDesc(global.systemFlagNameList.enableEmployee, global.appLocaleValues['lbl_enable_emp']);
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
                        //     onChanged: (value) async {
                        //       setState(() {
                        //         _isEmployeeEnable = value;
                        //       });
                        //       await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableEmployee, _isEmployeeEnable.toString());
                        //     },
                        //   ),
                        // ),
                        // ListTile(
                        //   contentPadding: EdgeInsets.only(left: 5),
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
                        //           //   showDesc(global.systemFlagNameList.enableSaleOrder, global.appLocaleValues['lbl_sales_order']);
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
                        //     onChanged: (value) async {
                        //       _isSaleOrderEnable = value;
                        //       await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableSaleOrder, _isSaleOrderEnable.toString());
                        //       setState(() {});
                        //     },
                        //   ),
                        // ),
                        Container(
                          height: 40,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            leading: Icon(Icons.translate),
                            title: (global.appLanguage['name'] == 'English') ? Text('${global.appLanguage['name']}') : Text('${global.appLanguage['name']}  (${global.appLanguage['title']})'),
                            onTap: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => SelectLanguageScreen(
                                        a: widget.analytics,
                                        o: widget.observer,
                                        screenId: 1,
                                      ))).then((value) => setState((){}) );
                            },
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 0),
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                global.appLocaleValues['lbl_enable_emp'],
                                style: Theme.of(context).primaryTextTheme.headline3,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.info,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () {
                                  //    showDesc(global.systemFlagNameList.askPinAlways, global.appLocaleValues['lbl_always_ask_pin']);
                                  showInfoMessage(
                                      global.appLocaleValues['lbl_enable_emp'],
                                      global.systemFlagNameList.enableEmployee,
                                      Icon(
                                        Icons.info,
                                        color: Theme.of(context).primaryColor,
                                      ));
                                },
                              )
                            ],
                          ),
                          trailing: Switch(
                            value: _isEmployeeEnable,
                            onChanged: (value) async {
                              setState(() {
                                _isEmployeeEnable = value;
                              });
                              await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableEmployee, _isEmployeeEnable.toString());
                            },
                          ),
                        ),

                        ListTile(
                          contentPadding: EdgeInsets.only(left: 0),
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                global.appLocaleValues['lbl_sales_order'],
                                style: Theme.of(context).primaryTextTheme.headline3,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.info,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () {
                                  //    showDesc(global.systemFlagNameList.askPinAlways, global.appLocaleValues['lbl_always_ask_pin']);
                                  showInfoMessage(
                                      global.appLocaleValues['lbl_sales_order'],
                                      global.systemFlagNameList.enableSaleOrder,
                                      Icon(
                                        Icons.info,
                                        color: Theme.of(context).primaryColor,
                                      ));
                                },
                              )
                            ],
                          ),
                          trailing: Switch(
                            value: _isSaleOrderEnable,
                            onChanged: (value) async {
                              _isSaleOrderEnable = value;
                              await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableSaleOrder, _isSaleOrderEnable.toString());
                              setState(() {});
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Align(alignment: Alignment.centerLeft, child: Text(global.appLocaleValues['lbl_date_format'], style: Theme.of(context).primaryTextTheme.headline3)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 10),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                TextFormField(
                                  readOnly: true,
                                  textCapitalization: TextCapitalization.sentences,
                                  onTap: () async {
                                    await _chooseDateFormate();
                                  },
                                  controller: _cDateFormat,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    border: nativeTheme().inputDecorationTheme.border,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.info,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    //   showDesc(global.systemFlagNameList.dateFormat, global.appLocaleValues['lbl_date_format']);
                                    showInfoMessage(
                                        global.appLocaleValues['lbl_date_format'],
                                        global.systemFlagNameList.dateFormat,
                                        Icon(
                                          Icons.info,
                                          color: Theme.of(context).primaryColor,
                                        ));
                                  },
                                )
                              ],
                            ),
                          ),
                        ),

                        //
                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
                        //     child: Stack(
                        //       alignment: Alignment.centerRight,
                        //       children: <Widget>[
                        //         TextFormField(
                        //           readOnly: true,
                        //           textCapitalization: TextCapitalization.sentences,
                        //           onTap: () async {
                        //             _cFinantialMonth.text = await br.chooseFinantialMonth(context, _cFinantialMonth.text);
                        //             setState(() {});
                        //             await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.financialMonth, _cFinantialMonth.text.toString());
                        //           },
                        //           controller: _cFinantialMonth,
                        //           textInputAction: TextInputAction.next,
                        //           decoration: InputDecoration(
                        //             labelText: global.appLocaleValues['lbl_financial_month'],
                        //             border: nativeTheme().inputDecorationTheme.border,
                        //           ),
                        //         ),
                        //         IconButton(
                        //           icon: Icon(
                        //             Icons.info,
                        //             color: Colors.grey,
                        //             size: 20,
                        //           ),
                        //           onPressed: () {
                        //             //   showDesc(global.systemFlagNameList.financialMonth, global.appLocaleValues['lbl_financial_month']);
                        //             showInfoMessage(
                        //                 global.appLocaleValues['lbl_financial_month'],
                        //                 global.systemFlagNameList.financialMonth,
                        //                 Icon(
                        //                   Icons.info,
                        //                   color: Theme.of(context).primaryColor,
                        //                 ));
                        //           },
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        //

                        //

                        Padding(
                          padding: const EdgeInsets.only(),
                          child: Align(alignment: Alignment.centerLeft, child: Text(global.appLocaleValues['lbl_decimal_places'], style: Theme.of(context).primaryTextTheme.headline3)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 8),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                TextFormField(
                                  readOnly: true,
                                  onTap: () async {
                                    await _chooseDecimalPlaces();
                                  },
                                  controller: _cDecimalPlaces,
                                  decoration: InputDecoration(
                                    border: nativeTheme().inputDecorationTheme.border,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.info,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    showInfoMessage(
                                        global.appLocaleValues['lbl_decimal_places'],
                                        global.systemFlagNameList.decimalPlaces,
                                        Icon(
                                          Icons.info,
                                          color: Theme.of(context).primaryColor,
                                        ));
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        //
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: <Widget>[
                        //       Expanded(
                        //         child: TextFormField(
                        //           readOnly: true,
                        //           onTap: () async {
                        //             await _chooseDecimalPlaces();
                        //           },
                        //           controller: _cDecimalPlaces,
                        //           decoration: InputDecoration(
                        //             labelText: global.appLocaleValues['lbl_decimal_places'],
                        //             border: nativeTheme().inputDecorationTheme.border,

                        //           ),
                        //         ),
                        //       ),
                        //       IconButton(
                        //         icon: Icon(
                        //           Icons.info,
                        //           color: Colors.grey,
                        //           size: 20,
                        //         ),
                        //         onPressed: () {
                        //           showInfoMessage(global.appLocaleValues['lbl_decimal_places'],global.systemFlagNameList.decimalPlaces, Icon(Icons.info,color: Colors.blue,));
                        //         },
                        //       )
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(alignment: Alignment.centerLeft, child: Text('${global.appLocaleValues['ini_sal_quote_no']}', style: Theme.of(context).primaryTextTheme.headline3)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 10),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                TextFormField(
                                  textCapitalization: TextCapitalization.sentences,
                                  // onFieldSubmitted: (val) async {
                                  //   _changeInitial(2);
                                  //   setState(() {});
                                  // },
                                  onChanged: (value) async {
                                    await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.saleQuoteInitialNo, (value.trim().isEmpty) ? '1001' : value.trim());
                                  },
                                  controller: _cInitialSalesQuoteNumber,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    border: nativeTheme().inputDecorationTheme.border,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.info,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    //   showDesc(global.systemFlagNameList.dateFormat, global.appLocaleValues['lbl_date_format']);
                                    showInfoMessage(
                                        "${global.appLocaleValues['ini_sal_quote_no']}",
                                        global.systemFlagNameList.saleQuoteInitialNo,
                                        Icon(
                                          Icons.info,
                                          color: Theme.of(context).primaryColor,
                                        ));
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        (_isSaleOrderEnable)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Align(alignment: Alignment.centerLeft, child: Text('${global.appLocaleValues['ini_sal_odr_no']}', style: Theme.of(context).primaryTextTheme.headline3)),
                              )
                            : SizedBox(),
                        (_isSaleOrderEnable)
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: <Widget>[
                                      TextFormField(
                                        textCapitalization: TextCapitalization.sentences,
                                        // onFieldSubmitted: (val) async {
                                        //   _changeInitial(3);
                                        //   setState(() {});
                                        // },
                                        onChanged: (value) async {
                                          await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.saleOrderInitialNo, (value.trim().isEmpty) ? '1001' : value.trim());
                                        },
                                        controller: _cInitialSalesOrderNumber,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          border: nativeTheme().inputDecorationTheme.border,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.info,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          //   showDesc(global.systemFlagNameList.dateFormat, global.appLocaleValues['lbl_date_format']);
                                          showInfoMessage(
                                              '${global.appLocaleValues['ini_sal_odr_no']}',
                                              global.systemFlagNameList.saleOrderInitialNo,
                                              Icon(
                                                Icons.info,
                                                color: Theme.of(context).primaryColor,
                                              ));
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(alignment: Alignment.centerLeft, child: Text("${global.appLocaleValues['ini_sal_inv_no']}", style: Theme.of(context).primaryTextTheme.headline3)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 10),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                TextFormField(
                                  textCapitalization: TextCapitalization.sentences,
                                  // onFieldSubmitted: (val) async {
                                  //   _changeInitial(1);
                                  //   setState(() {});
                                  // },
                                  onChanged: (value) async {
                                    await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.invoiceInitialNo, (value.trim().isEmpty) ? '1001' : value.trim());
                                  },
                                  controller: _cInitialInvoiceNumber,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    border: nativeTheme().inputDecorationTheme.border,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.info,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    //   showDesc(global.systemFlagNameList.dateFormat, global.appLocaleValues['lbl_date_format']);
                                    showInfoMessage(
                                        "${global.appLocaleValues['ini_sal_inv_no']}",
                                        global.systemFlagNameList.invoiceInitialNo,
                                        Icon(
                                          Icons.info,
                                          color: Theme.of(context).primaryColor,
                                        ));
                                  },
                                )
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(alignment: Alignment.centerLeft, child: Text('${global.appLocaleValues['lbl_t_and_c']} (${global.appLocaleValues['lbl_optional']})', style: Theme.of(context).primaryTextTheme.headline3)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0, top: 5),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                TextFormField(
                                  maxLines: 3,
                                  controller: _cTermsAndCondition,
                                  decoration: InputDecoration(
                                    hintText: '${global.appLocaleValues['lbl_t_and_c']}',
                                    labelText: '',
                                    border: nativeTheme().inputDecorationTheme.border,
                                  ),
                                  onChanged: (value) async {
                                    await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.termsAndCondition, (_cTermsAndCondition.text != '') ? _cTermsAndCondition.text.trim() : '');
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.info,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    //  showDesc(global.systemFlagNameList.termsAndCondition, global.appLocaleValues['lbl_t_and_c']);
                                    showInfoMessage(
                                        global.appLocaleValues['lbl_t_and_c'],
                                        global.systemFlagNameList.termsAndCondition,
                                        Icon(
                                          Icons.info,
                                          color: Theme.of(context).primaryColor,
                                        ));
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service')
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Divider(),
                          )
                        : SizedBox(),
                    (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service')
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(global.appLocaleValues['tle_unit_config'], style: Theme.of(context).primaryTextTheme.headline6),
                                  ],
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.only(left: 0),
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        global.appLocaleValues['lbl_unit_'],
                                        style: Theme.of(context).primaryTextTheme.headline3,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.info,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          //    showDesc(global.systemFlagNameList.askPinAlways, global.appLocaleValues['lbl_always_ask_pin']);
                                          showInfoMessage(
                                              global.appLocaleValues['lbl_unit_'],
                                              global.systemFlagNameList.enableUnitModule,
                                              Icon(
                                                Icons.info,
                                                color: Theme.of(context).primaryColor,
                                              ));
                                        },
                                      )
                                    ],
                                  ),
                                  trailing: Switch(
                                    value: _isUnitModuleEnabled,
                                    onChanged: (value) async {
                                      _isUnitModuleEnabled = value;
                                      await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableUnitModule, _isUnitModuleEnabled.toString());
                                      setState(() {});
                                    },
                                  ),
                                ),
                                (_isUnitModuleEnabled)
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 10, right: 10),
                                        child: Align(alignment: Alignment.centerLeft, child: Text(global.appLocaleValues['lbl_default_unit_combintion'], style: Theme.of(context).primaryTextTheme.headline3)),
                                      )
                                    : SizedBox(),
                                (_isUnitModuleEnabled)
                                    ? Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 5, bottom: 10, left: 10, right: 10),
                                          child: Stack(
                                            alignment: Alignment.centerRight,
                                            children: <Widget>[
                                              TextFormField(
                                                readOnly: true,
                                                // textCapitalization: TextCapitalization.sentences,
                                                onTap: () async {
                                                  await _selectCombination();
                                                },
                                                controller: _cDefaultUnitOfMeasure,
                                                // textInputAction: TextInputAction.next,
                                                decoration: InputDecoration(
                                                  border: nativeTheme().inputDecorationTheme.border,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.info,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  //   showDesc(global.systemFlagNameList.dateFormat, global.appLocaleValues['lbl_date_format']);
                                                  showInfoMessage(
                                                      global.appLocaleValues['lbl_default_unit_combintion'],
                                                      global.systemFlagNameList.defaultUnitCombination,
                                                      Icon(
                                                        Icons.info,
                                                        color: Theme.of(context).primaryColor,
                                                      ));
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          )
                        : SizedBox(),

                    (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service')
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Divider(),
                          )
                        : SizedBox(),
                    (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service')
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(global.appLocaleValues['tle_purchase_supplier_confing'], style: Theme.of(context).primaryTextTheme.headline6),
                                  ],
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.only(left: 0),
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        global.appLocaleValues['lbl_purchase_supplier'],
                                        style: Theme.of(context).primaryTextTheme.headline3,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.info,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          //    showDesc(global.systemFlagNameList.askPinAlways, global.appLocaleValues['lbl_always_ask_pin']);
                                          showInfoMessage(
                                              global.appLocaleValues['lbl_purchase_supplier'],
                                              global.systemFlagNameList.enablePurchaseAndSupplierModule,
                                              Icon(
                                                Icons.info,
                                                color: Theme.of(context).primaryColor,
                                              ));
                                        },
                                      )
                                    ],
                                  ),
                                  trailing: Switch(
                                    value: _isEnablePurchaseSupplierModule,
                                    onChanged: (value) async {
                                      if (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service') {
                                        _isEnablePurchaseSupplierModule = value;
                                      } else {
                                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('${global.appLocaleValues['txt_product_vld']}')));
                                      }
                                      await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enablePurchaseAndSupplierModule, _isEnablePurchaseSupplierModule.toString());
                                      setState(() {});
                                    },
                                  ),
                                ),
                                (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true')
                                    ? ListTile(
                                        contentPadding: EdgeInsets.only(left: 0),
                                        leading: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              global.appLocaleValues['lbl_use_pro_supplier_code'],
                                              style: Theme.of(context).primaryTextTheme.headline3,
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.info,
                                                color: Colors.grey,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                //    showDesc(global.systemFlagNameList.askPinAlways, global.appLocaleValues['lbl_always_ask_pin']);
                                                showInfoMessage(
                                                    global.appLocaleValues['lbl_use_pro_supplier_code'],
                                                    global.systemFlagNameList.useProductSupplierCode,
                                                    Icon(
                                                      Icons.info,
                                                      color: Theme.of(context).primaryColor,
                                                    ));
                                              },
                                            )
                                          ],
                                        ),
                                        trailing: Switch(
                                          value: _isProductSupplierCode,
                                          onChanged: (value) async {
                                            _isProductSupplierCode = value;
                                            await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.useProductSupplierCode, _isProductSupplierCode.toString());
                                            setState(() {});
                                          },
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          )
                        : SizedBox(),

                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Text(
                                  '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_return_pro_confing'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_return_ser_confing'] : global.appLocaleValues['tle_return_both_confing']}',
                                  style: Theme.of(context).primaryTextTheme.headline6),
                            ],
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 0),
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  global.appLocaleValues['lbl_sales_return'],
                                  style: Theme.of(context).primaryTextTheme.headline3,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.info,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    //    showDesc(global.systemFlagNameList.askPinAlways, global.appLocaleValues['lbl_always_ask_pin']);
                                    showInfoMessage(
                                        global.appLocaleValues['lbl_sales_return'],
                                        global.systemFlagNameList.enableSalesReturn,
                                        Icon(
                                          Icons.info,
                                          color: Theme.of(context).primaryColor,
                                        ));
                                  },
                                )
                              ],
                            ),
                            trailing: Switch(
                              value: _isSalesReturnEnable,
                              onChanged: (value) async {
                                _isSalesReturnEnable = value;
                                await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableSalesReturn, _isSalesReturnEnable.toString());
                                setState(() {});
                              },
                            ),
                          ),
                          (_isSalesReturnEnable)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: Align(alignment: Alignment.centerLeft, child: Text(global.appLocaleValues['lbl_sales_return_days'], style: Theme.of(context).primaryTextTheme.headline3)),
                                )
                              : SizedBox(),
                          (_isSalesReturnEnable)
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5, bottom: 10, left: 10, right: 10),
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: <Widget>[
                                        TextFormField(
                                          readOnly: true,
                                          // textCapitalization: TextCapitalization.sentences,
                                          onTap: () async {
                                            await _chooseReturnDays(true);
                                          },
                                          controller: _cSalesReturnDays,
                                          // textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            border: nativeTheme().inputDecorationTheme.border,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.info,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            //   showDesc(global.systemFlagNameList.dateFormat, global.appLocaleValues['lbl_date_format']);
                                            showInfoMessage(
                                                global.appLocaleValues['lbl_sales_return_days'],
                                                global.systemFlagNameList.salesReturnDays,
                                                Icon(
                                                  Icons.info,
                                                  color: Theme.of(context).primaryColor,
                                                ));
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          (_isEnablePurchaseSupplierModule)
                              ? Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.only(left: 0),
                                      leading: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            global.appLocaleValues['lbl_purchase_return'],
                                            style: Theme.of(context).primaryTextTheme.headline3,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.info,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              //    showDesc(global.systemFlagNameList.askPinAlways, global.appLocaleValues['lbl_always_ask_pin']);
                                              showInfoMessage(
                                                  global.appLocaleValues['lbl_purchase_return'],
                                                  global.systemFlagNameList.enablePurchaseReturn,
                                                  Icon(
                                                    Icons.info,
                                                    color: Theme.of(context).primaryColor,
                                                  ));
                                            },
                                          )
                                        ],
                                      ),
                                      trailing: Switch(
                                        value: _isPurchaseReturnEnable,
                                        onChanged: (value) async {
                                          _isPurchaseReturnEnable = value;
                                          await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enablePurchaseReturn, _isPurchaseReturnEnable.toString());
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    (_isPurchaseReturnEnable)
                                        ? Padding(
                                            padding: const EdgeInsets.only(left: 10, right: 10),
                                            child: Align(alignment: Alignment.centerLeft, child: Text(global.appLocaleValues['lbl_purchase_return_days'], style: Theme.of(context).primaryTextTheme.headline3)),
                                          )
                                        : SizedBox(),
                                    (_isPurchaseReturnEnable)
                                        ? Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 5, bottom: 10, left: 10, right: 10),
                                              child: Stack(
                                                alignment: Alignment.centerRight,
                                                children: <Widget>[
                                                  TextFormField(
                                                    readOnly: true,
                                                    // textCapitalization: TextCapitalization.sentences,
                                                    onTap: () async {
                                                      await _chooseReturnDays(true);
                                                    },
                                                    controller: _cPurchaseReturnDays,
                                                    // textInputAction: TextInputAction.next,
                                                    decoration: InputDecoration(
                                                      border: nativeTheme().inputDecorationTheme.border,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.info,
                                                      color: Colors.grey,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {
                                                      //   showDesc(global.systemFlagNameList.dateFormat, global.appLocaleValues['lbl_date_format']);
                                                      showInfoMessage(
                                                          global.appLocaleValues['lbl_purchase_return_days'],
                                                          global.systemFlagNameList.purchaseReturnDays,
                                                          Icon(
                                                            Icons.info,
                                                            color: Theme.of(context).primaryColor,
                                                          ));
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox()
                                  ],
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Text(global.appLocaleValues['tle_securiry_config'], style: Theme.of(context).primaryTextTheme.headline6),
                            ],
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 0),
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  global.appLocaleValues['lbl_always_ask_pin'],
                                  style: Theme.of(context).primaryTextTheme.headline3,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.info,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    //    showDesc(global.systemFlagNameList.askPinAlways, global.appLocaleValues['lbl_always_ask_pin']);
                                    showInfoMessage(
                                        global.appLocaleValues['lbl_always_ask_pin'],
                                        global.systemFlagNameList.askPinAlways,
                                        Icon(
                                          Icons.info,
                                          color: Theme.of(context).primaryColor,
                                        ));
                                  },
                                )
                              ],
                            ),
                            trailing: Switch(
                              value: _isAskPinAlways,
                              onChanged: (value) async {
                                _isAskPinAlways = value;
                                await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.askPinAlways, _isAskPinAlways.toString());
                                setState(() {});
                              },
                            ),
                          ),
                          (global.availableBiometrics)
                              ? ListTile(
                                  contentPadding: EdgeInsets.only(left: 0),
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        global.appLocaleValues['lbl_enable_fingrprint'],
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.info,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          //    showDesc(global.systemFlagNameList.enableFingerPrint, global.appLocaleValues['lbl_enable_fingrprint']);
                                          showInfoMessage(
                                              global.appLocaleValues['lbl_enable_fingrprint'],
                                              global.systemFlagNameList.enableFingerPrint,
                                              Icon(
                                                Icons.info,
                                                color: Theme.of(context).primaryColor,
                                              ));
                                        },
                                      )
                                    ],
                                  ),
                                  trailing: Switch(
                                    value: _isFringerPrintOn,
                                    onChanged: (value) async {
                                      bool _verified = await br.authenticate();
                                      if (_verified) {
                                        _isFringerPrintOn = value;
                                      }
                                      await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableFingerPrint, _isFringerPrintOn.toString());
                                      setState(() {});
                                    },
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                    //   child: Divider(),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 0, right: 10, top: 0),
                    //   child: Column(
                    //     children: <Widget>[
                    //       Row(
                    //         children: [
                    //           Text(global.appLocaleValues['tle_backup_restore_config'], style: Theme.of(context).primaryTextTheme.headline6),
                    //         ],
                    //       ),
                    //       ListTile(
                    //         contentPadding: EdgeInsets.only(left: 5),
                    //         leading: Row(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: <Widget>[
                    //             Text(
                    //               global.appLocaleValues['lbl_backup_restore'],
                    //               style: TextStyle(fontSize: 16),
                    //             ),
                    //             IconButton(
                    //               icon: Icon(
                    //                 Icons.info,
                    //                 color: Colors.grey,
                    //                 size: 20,
                    //               ),
                    //               onPressed: () {
                    //                 //  showDesc(global.systemFlagNameList.enableGoogleBackupRestore, global.appLocaleValues['lbl_backup_restore']);
                    //                 showInfoMessage(
                    //                     global.appLocaleValues['lbl_backup_restore'],
                    //                     global.systemFlagNameList.enableGoogleBackupRestore,
                    //                     Icon(
                    //                       Icons.info,
                    //                       color: Theme.of(context).primaryColor,
                    //                     ));
                    //               },
                    //             ),
                    //           ],
                    //         ),
                    //         trailing: Switch(
                    //           value: _isGoogleBackupRestoreEnable,
                    //           onChanged: (value) async {
                    //             // if (!value) {
                    //             //   bool _action = await br.disableBackupAndRestore(context, global.appLocaleValues['txt_backup_restore_vld']);
                    //             //   _isGoogleBackupRestoreEnable = _action;
                    //             //   await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableGoogleBackupRestore, _isGoogleBackupRestoreEnable.toString());
                    //             // } else {
                    //               _isGoogleBackupRestoreEnable = value;
                    //               await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableGoogleBackupRestore, _isGoogleBackupRestoreEnable.toString());
                    //               setState(() { });
                    //               // _backUpData();
                    //               // backupStatusRefresh();
                    //               // bool retry = false;
                    //               // do {
                    //               //   int result = await backupData(true);
                    //               //   if (result == 0) {
                    //               //     int networkResult = await networkErrorDialog();
                    //               //     if (networkResult == 1) {
                    //               //       retry = true;
                    //               //     } else {
                    //               //       retry = false;
                    //               //       _isGoogleBackupRestoreEnable = false;
                    //               //     }
                    //               //   } else {
                    //               //     retry = false;
                    //               //   }
                    //               // } while (retry);
                    //             // }
                    //             setState(() {});
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                    //   child: Divider(),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    //   child: Column(
                    //     children: <Widget>[
                    //       Row(
                    //         children: [
                    //           Text(global.appLocaleValues['tle_notification_config'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey)),
                    //         ],
                    //       ),
                    //       Container(
                    //         width: MediaQuery.of(context).size.width,
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 10),
                    //           child: Stack(
                    //             alignment: Alignment.centerRight,
                    //             children: <Widget>[
                    //               TextFormField(
                    //                 readOnly: true,
                    //                 onTap: () async {
                    //                   await _chooseNotificationTime();
                    //                 },
                    //                 controller: _cNotificationTime,
                    //                 textInputAction: TextInputAction.next,
                    //                 decoration: InputDecoration(
                    //                   labelText: '${global.appLocaleValues['lbl_notification_time']}',
                    //                 ),
                    //               ),
                    //               IconButton(
                    //                 icon: Icon(
                    //                   Icons.info,
                    //                   color: Colors.grey,
                    //                   size: 20,
                    //                 ),
                    //                 onPressed: () {
                    //                   showInfoMessage(
                    //                       global.appLocaleValues['lbl_notification_time'],
                    //                       global.systemFlagNameList.notificationTime,
                    //                       Icon(
                    //                         Icons.info,
                    //                         color: Theme.of(context).primaryColor,
                    //                       ));
                    //                 },
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       Container(
                    //         width: MediaQuery.of(context).size.width,
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                    //           child: Stack(
                    //             alignment: Alignment.centerRight,
                    //             children: <Widget>[
                    //               TextField(
                    //                 readOnly: true,
                    //                 textCapitalization: TextCapitalization.sentences,
                    //                 onTap: () async {
                    //                   await _chooseReminderPeriod();
                    //                 },
                    //                 controller: _cReminderTime,
                    //                 textInputAction: TextInputAction.next,
                    //                 decoration: InputDecoration(
                    //                   labelText: '${global.appLocaleValues['lbl_reminder_period']}',
                    //                 ),
                    //               ),
                    //               IconButton(
                    //                 icon: Icon(
                    //                   Icons.info,
                    //                   color: Colors.grey,
                    //                   size: 20,
                    //                 ),
                    //                 onPressed: () {
                    //                   showInfoMessage(
                    //                       global.appLocaleValues['lbl_reminder_period'],
                    //                       global.systemFlagNameList.reminderPeriod,
                    //                       Icon(
                    //                         Icons.info,
                    //                         color: Theme.of(context).primaryColor,
                    //                       ));
                    //                 },
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
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
    // backupStatusRefresh();
  }

  // Future _chooseAccountCodeMaxLength() async {
  //   try {
  //     _accountCodeMaxLengthValueList = br.getSystemFlag(global.systemFlagNameList.accountCodeMaxLength).valueList.split(',').toList();
  //     if (_cAccountCodePrefix.text.length == 2) {
  //       _accountCodeMaxLengthValueList.removeAt(0);
  //       _accountCodeMaxLengthValueList.removeAt(0);
  //     } else if (_cAccountCodePrefix.text.length == 3) {
  //       _accountCodeMaxLengthValueList.removeAt(0);
  //       _accountCodeMaxLengthValueList.removeAt(0);
  //       _accountCodeMaxLengthValueList.removeAt(0);
  //     } else if (_cAccountCodePrefix.text.length == 1) {
  //       _accountCodeMaxLengthValueList.removeAt(0);
  //     }
  //     AlertDialog dialog = AlertDialog(
  //       shape: nativeTheme().dialogTheme.shape,
  //       title: Text(
  //         'Choose Max Length',
  //         style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  //       ),
  //       content: Container(
  //         height: MediaQuery.of(context).size.height * 0.5,
  //         width: MediaQuery.of(context).size.width - 40,
  //         child: ListView.builder(
  //           itemCount: _accountCodeMaxLengthValueList.length,
  //           shrinkWrap: true,
  //           itemBuilder: (context, index) {
  //             return Card(
  //               child: ListTile(
  //                 title: Text(_accountCodeMaxLengthValueList[index]),
  //                 onTap: () async {
  //                   Navigator.of(context).pop();
  //                   _cAccountCodeMaxLen.text = _accountCodeMaxLengthValueList[index];
  //                   await br.updateSystemFlag(global.systemFlagNameList.accountCodeMaxLength, _cAccountCodeMaxLen.text.trim());
  //                   setState(() {
  //                     _generateAccountCodeExample();
  //                   });
  //                 },
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     );
  //     await showDialog(context: context, child: dialog);
  //     setState(() {});
  //   } catch (e) {
  //     print('Exception - settingsScreen.dart - _chooseAccountCodeMaxLength(): ' + e.toString());
  //     return null;
  //   }
  // }

  Future _chooseDateFormate() async {
    try {
      List<String> _dateFormatValueList = br.getSystemFlag(global.systemFlagNameList.dateFormat).valueList.split(',').toList();
      AlertDialog dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['dia_lbl_date_format'],
          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
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
                        await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.dateFormat, '${DateFormat(_dateFormatValueList[index]).format(DateTime.now())}');

                        setState(() {
                          _cDateFormat.text = '${DateFormat(_dateFormatValueList[index]).format(DateTime.now())}';
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
      await showDialog(builder: (context) => dialog, context: context);
      setState(() {});
    } catch (e) {
      print('Exception - settingsScreen.dart - _chooseDateFormate(): ' + e.toString());
      return null;
    }
  }

  Future _chooseDecimalPlaces() async {
    try {
      List<String> _decimalPlacesValueList = br.getSystemFlag(global.systemFlagNameList.decimalPlaces).valueList.split(',').toList();
      AlertDialog dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['dia_lbl_decimal_places'],
          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
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
                        await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.decimalPlaces, '${_decimalPlacesValueList[index]}');

                        setState(() {
                          _cDecimalPlaces.text = '${_decimalPlacesValueList[index]}';
                          _generateDecimalPlacesExample();
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
      await showDialog(builder: (context) => dialog, context: context);
      setState(() {});
    } catch (e) {
      print('Exception - settingsScreen.dart - _chooseDateFormate(): ' + e.toString());
      return null;
    }
  }

  Future _chooseReturnDays(bool _isSalesReturnOperation) async {
    try {
      List<String> _returnDaysValueList = br.getSystemFlag(global.systemFlagNameList.salesReturnDays).valueList.split(',').toList();
      AlertDialog dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          (_isSalesReturnOperation) ? global.appLocaleValues['dia_select_return_days'] : global.appLocaleValues['dia_select_purchase_return_days'],
          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width - 40,
          child: Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _returnDaysValueList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text('${_returnDaysValueList[index]}'),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await dbHelper.systemFlagUpdateValue((_isSalesReturnOperation) ? global.systemFlagNameList.salesReturnDays : global.systemFlagNameList.purchaseReturnDays, '${_returnDaysValueList[index]}');

                        setState(() {
                          if (_isSalesReturnOperation) {
                            _cSalesReturnDays.text = '${_returnDaysValueList[index]}';
                          } else {
                            _cPurchaseReturnDays.text = '${_returnDaysValueList[index]}';
                          }
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
      await showDialog(builder: (context) => dialog, context: context);
      setState(() {});
    } catch (e) {
      print('Exception - settingsScreen.dart - _chooseReturnDays(): ' + e.toString());
      return null;
    }
  }

  // Future _chooseInvoiceNoMaxLength() async {
  //   try {
  //     _invoiceNoMaxLengthValueList = br.getSystemFlag(global.systemFlagNameList.invoiceNoMaxLength).valueList.split(',').toList();
  //     if (_cInvoiceNoPrefix.text.length == 2) {
  //       _invoiceNoMaxLengthValueList.removeAt(0);
  //       _invoiceNoMaxLengthValueList.removeAt(0);
  //     } else if (_cInvoiceNoPrefix.text.length == 3) {
  //       _invoiceNoMaxLengthValueList.removeAt(0);
  //       _invoiceNoMaxLengthValueList.removeAt(0);
  //       _invoiceNoMaxLengthValueList.removeAt(0);
  //     } else if (_cInvoiceNoPrefix.text.length == 1) {
  //       _invoiceNoMaxLengthValueList.removeAt(0);
  //     }
  //     AlertDialog dialog = AlertDialog(
  //       shape: nativeTheme().dialogTheme.shape,
  //       title: Text(
  //         global.appLocaleValues['dia_select_max_len'],
  //         style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
  //       ),
  //       content: Container(
  //         height: MediaQuery.of(context).size.height * 0.5,
  //         width: MediaQuery.of(context).size.width - 40,
  //         child: Scrollbar(
  //           child: ListView.builder(
  //             itemCount: _invoiceNoMaxLengthValueList.length,
  //             shrinkWrap: true,
  //             itemBuilder: (context, index) {
  //               return Column(
  //                 children: [
  //                   ListTile(
  //                     title: Text(_invoiceNoMaxLengthValueList[index]),
  //                     onTap: () async {
  //                       Navigator.of(context).pop();
  //                       _cInvoiceNoMaxLen.text = _invoiceNoMaxLengthValueList[index];
  //                       await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.invoiceNoMaxLength, _cInvoiceNoMaxLen.text.trim());
  //                       setState(() {
  //                         _generateInvoiceNoExample();
  //                       });
  //                     },
  //                   ),
  //                   Divider()
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //       ),
  //     );
  //     await showDialog(builder: (context) => dialog, context: context);
  //     setState(() {});
  //   } catch (e) {
  //     print('Exception - settingsScreen.dart - _chooseInvoiceNoMaxLength(): ' + e.toString());
  //     return null;
  //   }
  // }

  // Future _chooseProductCodeMaxLength() async {
  //   try {
  //     _productCodeMaxLengthValueList = br.getSystemFlag(global.systemFlagNameList.productCodeMaxLength).valueList.split(',').toList();
  //     if (_cProductCodePrefix.text.length == 2) {
  //       _productCodeMaxLengthValueList.removeAt(0);
  //       _productCodeMaxLengthValueList.removeAt(0);
  //     } else if (_cProductCodePrefix.text.length == 3) {
  //       _productCodeMaxLengthValueList.removeAt(0);
  //       _productCodeMaxLengthValueList.removeAt(0);
  //       _productCodeMaxLengthValueList.removeAt(0);
  //     } else if (_cProductCodePrefix.text.length == 1) {
  //       _productCodeMaxLengthValueList.removeAt(0);
  //     }
  //     AlertDialog dialog = AlertDialog(
  //       shape: nativeTheme().dialogTheme.shape,
  //       title: Text(
  //         global.appLocaleValues['dia_select_max_len'],
  //         style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
  //       ),
  //       content: Container(
  //         height: MediaQuery.of(context).size.height * 0.5,
  //         width: MediaQuery.of(context).size.width - 40,
  //         child: Scrollbar(
  //           child: ListView.builder(
  //             itemCount: _productCodeMaxLengthValueList.length,
  //             shrinkWrap: true,
  //             itemBuilder: (context, index) {
  //               return Column(
  //                 children: [
  //                   ListTile(
  //                     title: Text(_productCodeMaxLengthValueList[index]),
  //                     onTap: () async {
  //                       Navigator.of(context).pop();
  //                       _cProductCodeMaxLen.text = _productCodeMaxLengthValueList[index];
  //                       await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.productCodeMaxLength, _cProductCodeMaxLen.text.trim());
  //                       setState(() {
  //                         _generateProductCodeExample();
  //                       });
  //                     },
  //                   ),
  //                   Divider()
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //       ),
  //     );
  //     await showDialog(builder: (context) => dialog, context: context);
  //     setState(() {});
  //   } catch (e) {
  //     print('Exception - settingsScreen.dart - _chooseProductCodeMaxLength(): ' + e.toString());
  //     return null;
  //   }
  // }

  // void _generateAccountCodeExample({int methodCall}) {
  //   try {
  //     if (methodCall == 0) {
  //       int _maxLen = int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length;
  //       _accountCodeExample = '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}' + '0' * (_maxLen - 1) + '1';
  //     } else {
  //       if (_cAccountCodePrefix.text.isEmpty) {
  //         int _maxLen = int.parse(_cAccountCodeMaxLen.text.trim());
  //         _accountCodeExample = '0' * (_maxLen - 1) + '1';
  //       } else {
  //         int _maxLen = int.parse(_cAccountCodeMaxLen.text) - _cAccountCodePrefix.text.length;
  //         _accountCodeExample = '${_cAccountCodePrefix.text}' + '0' * (_maxLen - 1) + '1';
  //       }
  //     }
  //   } catch (e) {
  //     print('Exception - settingsScreen.dart - _generateAccountCodeExample(): ' + e.toString());
  //     return null;
  //   }
  // }

  void _generateInvoiceNoExample({int methodCall}) {
    try {
      if (methodCall == 0) {
        int _maxLen = int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length;
        // _invoiceNoExample = '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}' + '0' * (_maxLen - 1) + '1';
      } else {
        if (_cInvoiceNoPrefix.text.isEmpty) {
          int _maxLen = int.parse(_cInvoiceNoMaxLen.text.trim());
          // _invoiceNoExample = '0' * (_maxLen - 1) + '1';
        } else {
          int _maxLen = int.parse(_cInvoiceNoMaxLen.text) - _cInvoiceNoPrefix.text.length;
          // _invoiceNoExample = '${_cInvoiceNoPrefix.text}' + '0' * (_maxLen - 1) + '1';
        }
      }
    } catch (e) {
      print('Exception - settingsScreen.dart - _generateInvoiceNoExample(): ' + e.toString());
      return null;
    }
  }

  void _generateDecimalPlacesExample() {
    try {
      int _decimal = int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces));
      if (_decimal == 0) {
        _decimalPlacesExample = '1234';
      } else {
        _decimalPlacesExample = '1234.' + '0' * _decimal;
      }
      setState(() {});
    } catch (e) {
      print('Exception - settingsScreen.dart - _generateDecimalPlacesExample(): ' + e.toString());
      return null;
    }
  }

  void _generateProductCodeExample({int methodCall}) {
    try {
      if (methodCall == 0) {
        int _maxLen = int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length;
        // _productCodeExample = '${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}' + '0' * (_maxLen - 1) + '1';
      } else {
        if (_cProductCodePrefix.text.isEmpty) {
          int _maxLen = int.parse(_cProductCodeMaxLen.text.trim());
          // _productCodeExample = '0' * (_maxLen - 1) + '1';
        } else {
          int _maxLen = int.parse(_cProductCodeMaxLen.text) - _cProductCodePrefix.text.length;
          // _productCodeExample = '${_cProductCodePrefix.text}' + '0' * (_maxLen - 1) + '1';
        }
      }
    } catch (e) {
      print('Exception - settingsScreen.dart - _generateProductCodeExample(): ' + e.toString());
      return null;
    }
  }

  Future _getData() async {
    try {
      _cDateFormat.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.now());
      //   _cAccountCodeMaxLen.text = br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength);
      //   _cAccountCodePrefix.text = br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix);
      _cProductCodeMaxLen.text = br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength);
      _cProductCodePrefix.text = br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix);
      _cInvoiceNoMaxLen.text = br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength);
      _cInvoiceNoPrefix.text = br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix);
      _cPaymentPdfFooter.text = br.getSystemFlagValue(global.systemFlagNameList.paymentPdfFooter);
      _cDecimalPlaces.text = br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces);
      _cTermsAndCondition.text = br.getSystemFlagValue(global.systemFlagNameList.termsAndCondition);
      _cSalesReturnDays.text = br.getSystemFlagValue(global.systemFlagNameList.salesReturnDays);
      _cPurchaseReturnDays.text = br.getSystemFlagValue(global.systemFlagNameList.purchaseReturnDays);
      _isSalesReturnEnable = (br.getSystemFlagValue(global.systemFlagNameList.enableSalesReturn) == 'true') ? true : false;
      _isPurchaseReturnEnable = (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseReturn) == 'true') ? true : false;
      // _isSalesReturnEnable = (br.getSystemFlagValue(global.systemFlagNameList.enableSalesReturn) == 'true') ? true : false;
      _cInvoicePdfFooter.text = br.getSystemFlagValue(global.systemFlagNameList.invoicePdfFooter);
      // _isProductWiseTaxEnable = (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') ? true : false;
      // _isTaxEnable = (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true') ? true : false;
      // _isGoogleBackupRestoreEnable = (br.getSystemFlagValue(global.systemFlagNameList.enableGoogleBackupRestore) == 'true') ? true : false;
      _isAskPinAlways = (br.getSystemFlagValue(global.systemFlagNameList.askPinAlways) == 'true') ? true : false;
      _isFringerPrintOn = (br.getSystemFlagValue(global.systemFlagNameList.enableFingerPrint) == 'true') ? true : false;
      _isProductSupplierCode = (br.getSystemFlagValue(global.systemFlagNameList.useProductSupplierCode) == 'true') ? true : false;
      _isEnablePurchaseSupplierModule = (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true') ? true : false;
      _isUnitModuleEnabled = (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == 'true') ? true : false;
      _isSaleOrderEnable = (br.getSystemFlagValue(global.systemFlagNameList.enableSaleOrder) == 'true') ? true : false;
      _isEmployeeEnable = (br.getSystemFlagValue(global.systemFlagNameList.enableEmployee) == 'true') ? true : false;
      _cFinantialMonth.text = br.getSystemFlagValue(global.systemFlagNameList.financialMonth);
      _cNotificationTime.text = br.getSystemFlagValue(global.systemFlagNameList.notificationTime);
      _cReminderTime.text = br.getSystemFlagValue(global.systemFlagNameList.reminderPeriod);
      _cInitialInvoiceNumber.text = br.getSystemFlagValue(global.systemFlagNameList.invoiceInitialNo);
      _cInitialSalesQuoteNumber.text = br.getSystemFlagValue(global.systemFlagNameList.saleQuoteInitialNo);
      _cInitialSalesOrderNumber.text = br.getSystemFlagValue(global.systemFlagNameList.saleOrderInitialNo);
      print(br.getSystemFlagValue(global.systemFlagNameList.askPinAlways));
      // _generateAccountCodeExample(methodCall: 0);
      _generateProductCodeExample(methodCall: 0);
      _generateInvoiceNoExample(methodCall: 0);
      _generateDecimalPlacesExample();
      _unitCombinationList = await dbHelper.unitCombinationGetList();
      _unitList = await dbHelper.unitGetList();
      _fetchUnitCode();
      UnitCombination _temp = _unitCombinationList.firstWhere((element) => element.id == int.parse(br.getSystemFlagValue(global.systemFlagNameList.defaultUnitCombination)));
      _cDefaultUnitOfMeasure.text = (_temp.secondaryUnitId != null) ? "${_temp.primaryUnit} - ${_temp.secondaryUnit}" : "${_temp.primaryUnit}";
    } catch (e) {
      print('Exception - settingsScreen.dart - _getData(): ' + e.toString());
      return null;
    }
  }

  Future _selectCombination() async {
    try {
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
        UnitCombination _temp = _unitCombinationList.firstWhere((element) => element.isSelected);
        int result = await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.defaultUnitCombination, _temp.id.toString());
        if (result == 1) {
          _cDefaultUnitOfMeasure.text = (_temp.secondaryUnitId != null) ? "${_temp.primaryUnit} - ${_temp.secondaryUnit}" : "${_temp.primaryUnit}";
        }
        setState(() {});
      }
    } catch (e) {
      print('Exception - settingsScreen.dart - _selectCombination(): ' + e.toString());
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
      print('Exception - settingsScreen.dart - _fetchUnitCode(): ' + e.toString());
    }
  }

  // Future _chooseReminderPeriod() async {
  //   try {
  //     List<String> _reminderTimeValueList = br.getSystemFlag(global.systemFlagNameList.reminderPeriod).valueList.split(',').toList();
  //     AlertDialog dialog = AlertDialog(
  //       title: Text(
  //         '${global.appLocaleValues['tle_select_reminder_period']}',
  //         style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
  //       ),
  //       content: Container(
  //         height: MediaQuery.of(context).size.height * 0.5,
  //         width: MediaQuery.of(context).size.width - 40,
  //         child: ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: _reminderTimeValueList.length,
  //           itemBuilder: (context, index) {
  //             return Padding(
  //               padding: const EdgeInsets.only(bottom: 8.0),
  //               child: Column(
  //                 children: <Widget>[
  //                   ListTile(
  //                     title: Text('${_reminderTimeValueList[index]}'),
  //                     onTap: () async {
  //                       Navigator.of(context).pop();
  //                       int result = await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.reminderPeriod, '${_reminderTimeValueList[index]}');
  //                       if (result == 1) {
  //                         if (_cReminderTime.text != _reminderTimeValueList[index]) {
  //                           br.rescheduleNotification(true, dbHelper);
  //                         }
  //                       }
  //                       setState(() {
  //                         _cReminderTime.text = '${_reminderTimeValueList[index]}';
  //                       });
  //                     },
  //                   ),
  //                   Divider()
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     );
  //     await showDialog(builder: (context) => dialog, context: context);
  //     setState(() {});
  //   } catch (e) {
  //     print('Exception - settingScreen.dart - _chooseReminderPeriod(): ' + e.toString());
  //     return null;
  //   }
  // }

  // Future<Null> _chooseNotificationTime() async {
  //   try {
  //     TimeOfDay picked;
  //     TimeOfDay _timeOfDay = TimeOfDay.now();
  //     picked = await showTimePicker(context: context, initialTime: _timeOfDay);
  //     if (picked != null && picked != _timeOfDay) {
  //       _timeOfDay = picked;
  //       String time = br.formatTimeOfDay(_timeOfDay);

  //       int result = await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.notificationTime, '$time');

  //       if (result == 1) {
  //         if (_cNotificationTime.text != time) {
  //           br.rescheduleNotification(false, dbHelper);
  //           setState(() {});
  //         }
  //       }

  //       _cNotificationTime.text = time;
  //     }
  //   } catch (e) {
  //     print('Exception - settingScreen.dart - _chooseNotificationTime(): ' + e.toString());
  //   }
  // }

  // _backUpData() async {
  //   try {
  //     if (global.backupResult == null) {
  //       global.backupResult =  MethodResult();
  //       global.backupResult.statusMessage = '${global.appLocaleValues['txt_taking_backup']}';

  //       if (this.mounted) {
  //         setState(() {});
  //       }
  //       // global.backupResult = await backUp(true);
  //       if (global.backupResult.statusCode != 1) {
  //         _isGoogleBackupRestoreEnable = false;
  //         await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableGoogleBackupRestore, _isGoogleBackupRestoreEnable.toString());
  //         // await updateEnableBackUp(_isGoogleBackupRestoreEnable.toString());
  //       }
  //       if (this.mounted) {
  //         setState(() {});
  //       }

  //       global.isAppStarted = false;
  //     }
  //   } catch (e) {
  //     print("Exception - backupAndRestoreScreen.dart - _backUpData():" + e.toString());
  //   }
  // }

  
}
