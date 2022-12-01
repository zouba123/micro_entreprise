// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'dart:io';

import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/dialogs/paymentAddDialog.dart';
import 'package:accounting_app/dialogs/productSelectDialog.dart';
import 'package:accounting_app/dialogs/selectUnitDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/decimalTextInputFormatter.dart';
import 'package:accounting_app/models/paymentDetailModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceModel.dart';
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/productTaxModel.dart';
import 'package:accounting_app/models/purchaseInvoiceDetailModel.dart';
import 'package:accounting_app/models/purchaseInvoiceDetailTaxModel.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceTaxModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/models/unitCombinationModel.dart';
import 'package:accounting_app/models/unitModel.dart';
import 'package:accounting_app/screens/purchaseInvoiceScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class PurchaseInvoiceAddSreen extends BaseRoute {
  final PurchaseInvoice invoice;
  PurchaseInvoiceAddSreen({@required a, @required o, @required this.invoice}) : super(a: a, o: o, r: 'PurchaseInvoiceAddSreen');
  @override
  _PurchaseInvoiceAddSreenState createState() => _PurchaseInvoiceAddSreenState(this.invoice);
}

class _PurchaseInvoiceAddSreenState extends BaseRouteState {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  TextEditingController _cAccountId = TextEditingController();
  TextEditingController _cInvoiceNumber = TextEditingController();
  TextEditingController _cInvoiceDate = TextEditingController();
  TextEditingController _cRemark = TextEditingController();
  TextEditingController _cDiscount = TextEditingController();
  TextEditingController _cDeliveryDate = TextEditingController();
  List<TextEditingController> _cUnitPriceList = [];
  List<TextEditingController> _cQtyList = [];
  List<TextEditingController> _cUnitList = [];
  List<TextEditingController> _cTaxAmount = [];
  List<ProductTax> _productTaxList = [];
  List<TaxMaster> _taxList = [];
  var _fAccountId = FocusNode();
  var _fDiscount = FocusNode();
  var _fNetAmount = FocusNode();
  bool _isTransactionDateSelection;
  var _fInvoiceDate = FocusNode();
  var _fDeliveryDate = FocusNode();
  var _focusNode = FocusNode();
  bool _autoValidate = false;
  TextEditingController _cNetAmount = TextEditingController();
//  double _remainAmount;
  bool _isComplete = false;
  String _invoiceDate2;
  String _deliveryDate2;
  PurchaseInvoice invoice;
  Account _account;
  bool _isDataLoaded = false;
  bool _isTaxApply = false;
  int _invoiceDetailTaxLen;
  String _pdfPath = '';
  double _totalDue = 0;
  double _totalPaid = 0;
  bool _accountChanged = false;
  List<UnitCombination> _unitCombinationList = [];
  List<Unit> _unitList = [];
  List<TaxMaster> _allTaxList = [];
  List<int> _invoiceDetailTaxIdList = []; // use for delete detail tax in edit mode
  int _selectedTaxGroup = 0;
//  List<Asset> images = List<Asset>();

  _PurchaseInvoiceAddSreenState(this.invoice) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: (invoice.id != null) ? Text(global.appLocaleValues['lbl_update_invoice']) : Text(global.appLocaleValues['lbl_add_invoice']),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await _onSubmit();
              },
              child: Text(global.appLocaleValues['btn_save'], style: TextStyle(color: Colors.white, fontSize: 18)),
            )
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            await showAlertd();
            return null;
          },
          child: (_isDataLoaded)
              ? Scrollbar(
                  child: SingleChildScrollView(
                    child: Form(
                      autovalidateMode: (_autoValidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
                      key: _formKey,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 5),
                                                child: Text(global.appLocaleValues['lbl_purchase_invoice_no'], style: Theme.of(context).primaryTextTheme.headline3),
                                              ),
                                              TextFormField(
                                                style: Theme.of(context).primaryTextTheme.headline1,
                                                decoration: InputDecoration(
                                                  border: nativeTheme().inputDecorationTheme.border,
                                                  suffixIcon: Icon(
                                                    Icons.star,
                                                    size: 9,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                controller: _cInvoiceNumber,
                                                validator: (v) {
                                                  if (v.isEmpty) {
                                                    return global.appLocaleValues['lbl_invoice_no_err_req'];
                                                  }
                                                  return null;
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 5),
                                                child: Text(global.appLocaleValues['lbl_invoice_date'], style: Theme.of(context).primaryTextTheme.headline3),
                                              ),
                                              TextFormField(
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  // labelText: global.appLocaleValues['lbl_invoice_date'],
                                                  border: nativeTheme().inputDecorationTheme.border,
                                                  suffixIcon: Icon(
                                                    Icons.star,
                                                    size: 9,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                focusNode: _fInvoiceDate,
                                                controller: _cInvoiceDate,
                                                keyboardType: null,
                                                validator: (v) {
                                                  if (v.isEmpty) {
                                                    return global.appLocaleValues['lbl_date_err_req'];
                                                  }
                                                  return null;
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                                    child: Text(global.appLocaleValues['tab_ac'], style: Theme.of(context).primaryTextTheme.headline3),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: TextFormField(
                                      controller: _cAccountId,
                                      readOnly: true,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        hintText: global.appLocaleValues['tab_ac'],
                                        // labelText: global.appLocaleValues['tab_ac'],
                                        border: nativeTheme().inputDecorationTheme.border,
                                        suffixIcon: Icon(
                                          Icons.star,
                                          size: 9,
                                          color: Colors.red,
                                        ),
                                      ),
                                      focusNode: _fAccountId,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return global.appLocaleValues['lbl_ac_err_req'];
                                        }
                                        return null;
                                      },
                                      onTap: () async {
                                        await _accountListener();
                                        _accountChanged = true;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                                    child: Text(global.appLocaleValues['lbl_delivery_date'], style: Theme.of(context).primaryTextTheme.headline3),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: TextFormField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        border: nativeTheme().inputDecorationTheme.border,
                                        // labelText: global.appLocaleValues['lbl_delivery_date'],
                                      ),
                                      focusNode: _fDeliveryDate,
                                      controller: _cDeliveryDate,
                                      keyboardType: null,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(),

                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: <Widget>[
                                  MaterialButton(
                                    child: Text(
                                      '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['btn_add_products'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['btn_add_services'] : global.appLocaleValues['btn_add_both']}',
                                    ),
                                    onPressed: () async {
                                      await _addProducts();
                                    },
                                    color: Theme.of(context).primaryColor,
                                    minWidth: MediaQuery.of(context).size.width,
                                  ),
                                  SingleChildScrollView(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: invoice.invoiceDetailList.length,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  Card(
                                                    child: ListTile(
                                                      leading: Column(
                                                        children: [
                                                          SizedBox(
                                                            width: 80,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  '${invoice.invoiceDetailList[index].product.name}',
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: Theme.of(context).primaryTextTheme.subtitle1,
                                                                ),
                                                                Text(
                                                                    (br.getSystemFlagValue(global.systemFlagNameList.useProductSupplierCode) == 'true' && invoice.invoiceDetailList[index].product.supplierProductCode != '')
                                                                        ? ' ${invoice.invoiceDetailList[index].product.supplierProductCode}'
                                                                        : ' ${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + invoice.invoiceDetailList[index].product.productCode.toString().length))}${invoice.invoiceDetailList[index].product.productCode}',
                                                                    style: Theme.of(context).primaryTextTheme.subtitle2),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      subtitle: Padding(
                                                          padding: EdgeInsets.only(top: 10),
                                                          child: Text(
                                                            'Total:  ${global.currency.symbol} ${invoice.invoiceDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                            style: Theme.of(context).primaryTextTheme.subtitle1,
                                                          )),
                                                      title: Padding(
                                                        padding: const EdgeInsets.only(top: 5),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              width: 40,
                                                              child: Column(
                                                                children: [
                                                                  Text(global.appLocaleValues['lbl_qty'], style: Theme.of(context).primaryTextTheme.subtitle2),
                                                                  TextFormField(
                                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                                    onChanged: (value) async {
                                                                      try {
                                                                        invoice.invoiceDetailList[index].quantity = (value.length > 0) ? double.parse(value) : 0;
                                                                        invoice.invoiceDetailList[index].amount = (invoice.invoiceDetailList[index].quantity * double.parse(_cUnitPriceList[index].text));
                                                                        invoice.grossAmount = invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.amount).reduce((sum, amount) => sum + amount);

                                                                        if (invoice.id == null) {
                                                                          if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
                                                                            invoice.finalTax = 0.0;
                                                                            for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                                              invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                                                                              _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                                                                              if (_isTaxApply) {
                                                                                invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                                                                              }
                                                                            }
                                                                            invoice.netAmount = (_isTaxApply && invoice.invoiceTaxList.length > 0)
                                                                                ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                : invoice.grossAmount - invoice.discount;
                                                                          } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                                            invoice.finalTax = 0.0;
                                                                            invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
                                                                            invoice.invoiceDetailTaxList.clear();
                                                                            invoice.invoiceDetailList.forEach((invoiceDetail) {
                                                                              _productTaxList.forEach((productTax) {
                                                                                if (invoiceDetail.productId == productTax.productId) {
                                                                                  for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                                                    if (invoice.invoiceTaxList[i].taxId == productTax.taxMasterId) {
                                                                                      invoice.invoiceTaxList[i].totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                                                                                      _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                                                                                      PurchaseInvoiceDetailTax _invoiceDetailTax = PurchaseInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                                                                                      invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                                                                                    }
                                                                                  }
                                                                                }
                                                                              });
                                                                            });
                                                                            invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply)
                                                                                ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                : invoice.grossAmount - invoice.discount;
                                                                            invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

                                                                            setState(() {});
                                                                          } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                                                            invoice.netAmount = invoice.grossAmount - invoice.discount;
                                                                          }
                                                                        } else {
                                                                          if (invoice.invoiceTaxList.length != 0 && _invoiceDetailTaxLen == 0) {
                                                                            invoice.finalTax = 0.0;
                                                                            for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                                              invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                                                                              _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                                                                              if (_isTaxApply) {
                                                                                invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                                                                              }
                                                                            }
                                                                            invoice.netAmount = (_isTaxApply && invoice.invoiceTaxList.length > 0)
                                                                                ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                : invoice.grossAmount - invoice.discount;
                                                                          } else if (invoice.invoiceTaxList.length != 0 && _invoiceDetailTaxLen != 0) {
                                                                            invoice.finalTax = 0.0;
                                                                            invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
                                                                            invoice.invoiceDetailTaxList.clear();
                                                                            if (_productTaxList.length == 0) {
                                                                              _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.productId).toList());
                                                                            }
                                                                            invoice.invoiceDetailList.forEach((invoiceDetail) {
                                                                              _productTaxList.forEach((productTax) {
                                                                                if (invoiceDetail.productId == productTax.productId) {
                                                                                  for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                                                    if (invoice.invoiceTaxList[i].taxId == productTax.taxMasterId) {
                                                                                      invoice.invoiceTaxList[i].totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                                                                                      _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                                                                                      PurchaseInvoiceDetailTax _invoiceDetailTax = PurchaseInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                                                                                      invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                                                                                    }
                                                                                  }
                                                                                }
                                                                              });
                                                                            });
                                                                            invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply)
                                                                                ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                : invoice.grossAmount - invoice.discount;
                                                                            invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

                                                                            setState(() {});
                                                                          } else if (_isTaxApply == false) {
                                                                            invoice.netAmount = invoice.grossAmount - invoice.discount;
                                                                          }
                                                                        }
                                                                        _calculate();
                                                                        setState(() {});
                                                                      } catch (e) {
                                                                        print('Exception - purchaseInvoiceAddScreen.dart - Qty_onChanged: ' + e.toString());
                                                                      }
                                                                    },

                                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                    maxLength: 3,
                                                                    textAlign: TextAlign.center,
                                                                    controller: _cQtyList[index],
                                                                    //    readOnly: (quote.id != null && DateTime.now().difference(quote.createdAt).inDays != 0) ? true : false,
                                                                    decoration: InputDecoration(
                                                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4e2eb5))),
                                                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                                                                      errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[700])),
                                                                      border: UnderlineInputBorder(borderSide: BorderSide(width: 0.2)),
                                                                      counterText: '',
                                                                    ),
                                                                    validator: (v) {
                                                                      if (v.isEmpty) {
                                                                        return '';
                                                                      } else if (v.contains(RegExp('[a-zA-Z]'))) {
                                                                        return global.appLocaleValues['vel_enter_number_only'];
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                                                ? SizedBox(
                                                                    width: 5,
                                                                  )
                                                                : SizedBox(),
                                                            (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                                                ? Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Text(global.appLocaleValues['lbl_unit'], style: Theme.of(context).primaryTextTheme.subtitle2),
                                                                      Container(
                                                                        width: 45,
                                                                        child: TextFormField(
                                                                          readOnly: true,
                                                                          controller: _cUnitList[index],
                                                                          decoration: InputDecoration(
                                                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4e2eb5))),
                                                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                                                                            errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                                            disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[700])),
                                                                            border: UnderlineInputBorder(borderSide: BorderSide(width: 0.2)),
                                                                            //  labelText: global.appLocaleValues['lbl_unit'],
                                                                          ),
                                                                          onTap: () async {
                                                                            await _selectUnit(index);
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : SizedBox(),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 15),
                                                              child: Text(
                                                                ' X ',
                                                                style: Theme.of(context).primaryTextTheme.overline,
                                                                textAlign: TextAlign.justify,
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Container(
                                                              width: 60,
                                                              //  height: MediaQuery.of(context).size.height / 0.9,
                                                              child: Column(
                                                                children: [
                                                                  Text(global.appLocaleValues['lbl_price'], style: Theme.of(context).primaryTextTheme.subtitle2),
                                                                  TextFormField(
                                                                    //    readOnly: (quote.id != null && DateTime.now().difference(quote.createdAt).inDays != 0) ? true : false,
                                                                    controller: _cUnitPriceList[index],
                                                                    textAlign: TextAlign.justify,
                                                                    //   style: TextStyle(height: 1),
                                                                    decoration: InputDecoration(
                                                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4e2eb5))),
                                                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                                                                      errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[700])),
                                                                      border: UnderlineInputBorder(borderSide: BorderSide(width: 0.2)),
                                                                      counterText: '',
                                                                    ),
                                                                    onChanged: (value) async {
                                                                      try {
                                                                        invoice.invoiceDetailList[index].unitPrice = (value.length > 0) ? double.parse(value) : 0;
                                                                        if (invoice.invoiceDetailList[index].product.productPriceList[0].unitId == invoice.invoiceDetailList[index].unitId) {
                                                                          // if product unit and sold unit is same
                                                                          invoice.invoiceDetailList[index].amount = invoice.invoiceDetailList[index].unitPrice * invoice.invoiceDetailList[index].quantity;
                                                                        } else {
                                                                          UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == invoice.invoiceDetailList[index].product.unitCombinationId);
                                                                          if (invoice.invoiceDetailList[index].unitId == _unitCombination.primaryUnitId) // if parent unit is selected
                                                                          {
                                                                            if (_unitCombination.primaryUnitId == invoice.invoiceDetailList[index].product.productPriceList[0].unitId) {
                                                                              invoice.invoiceDetailList[index].amount = invoice.invoiceDetailList[index].unitPrice * invoice.invoiceDetailList[index].quantity;
                                                                            } else {
                                                                              invoice.invoiceDetailList[index].amount = (invoice.invoiceDetailList[index].unitPrice * _unitCombination.measurement) * invoice.invoiceDetailList[index].quantity;
                                                                            }
                                                                            invoice.invoiceDetailList[index].amount = invoice.invoiceDetailList[index].quantity * invoice.invoiceDetailList[index].unitPrice;
                                                                          } else // if child unit is selected
                                                                          {
                                                                            if (_unitCombination.secondaryUnitId == invoice.invoiceDetailList[index].product.productPriceList[0].unitId) {
                                                                              invoice.invoiceDetailList[index].amount = invoice.invoiceDetailList[index].unitPrice * invoice.invoiceDetailList[index].quantity;
                                                                            } else {
                                                                              invoice.invoiceDetailList[index].amount = invoice.invoiceDetailList[index].unitPrice;
                                                                            }
                                                                          }
                                                                        }
                                                                        invoice.grossAmount = invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.amount).reduce((sum, amount) => sum + amount);
                                                                        if (invoice.id == null) {
                                                                          if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
                                                                            invoice.finalTax = 0.0;
                                                                            for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                                              invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                                                                              _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                                                                              if (_isTaxApply) {
                                                                                invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                                                                              }
                                                                            }
                                                                            invoice.netAmount = (_isTaxApply && invoice.invoiceTaxList.length > 0)
                                                                                ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                : invoice.grossAmount - invoice.discount;
                                                                          } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                                            invoice.finalTax = 0.0;
                                                                            invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
                                                                            invoice.invoiceDetailTaxList.clear();
                                                                            invoice.invoiceDetailList.forEach((invoiceDetail) {
                                                                              _productTaxList.forEach((productTax) {
                                                                                if (invoiceDetail.productId == productTax.productId) {
                                                                                  for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                                                    if (invoice.invoiceTaxList[i].taxId == productTax.taxMasterId) {
                                                                                      invoice.invoiceTaxList[i].totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                                                                                      _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                                                                                      PurchaseInvoiceDetailTax _invoiceDetailTax = PurchaseInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                                                                                      invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                                                                                    }
                                                                                  }
                                                                                }
                                                                              });
                                                                            });
                                                                            invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply)
                                                                                ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                : invoice.grossAmount - invoice.discount;
                                                                            invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

                                                                            setState(() {});
                                                                          } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                                                            invoice.netAmount = invoice.grossAmount - invoice.discount;
                                                                          }
                                                                        } else {
                                                                          if (invoice.invoiceTaxList.length != 0 && _invoiceDetailTaxLen == 0) {
                                                                            invoice.finalTax = 0.0;
                                                                            for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                                              invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                                                                              _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                                                                              if (_isTaxApply) {
                                                                                invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                                                                              }
                                                                            }
                                                                            invoice.netAmount = (_isTaxApply && invoice.invoiceTaxList.length > 0)
                                                                                ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                : invoice.grossAmount - invoice.discount;
                                                                          } else if (invoice.invoiceTaxList.length != 0 && _invoiceDetailTaxLen != 0) {
                                                                            invoice.finalTax = 0.0;
                                                                            invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
                                                                            invoice.invoiceDetailTaxList.clear();
                                                                            if (_productTaxList.length == 0) {
                                                                              _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.productId).toList());
                                                                            }
                                                                            invoice.invoiceDetailList.forEach((invoiceDetail) {
                                                                              _productTaxList.forEach((productTax) {
                                                                                if (invoiceDetail.productId == productTax.productId) {
                                                                                  for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                                                    if (invoice.invoiceTaxList[i].taxId == productTax.taxMasterId) {
                                                                                      invoice.invoiceTaxList[i].totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                                                                                      _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                                                                                      PurchaseInvoiceDetailTax _invoiceDetailTax = PurchaseInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                                                                                      invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                                                                                    }
                                                                                  }
                                                                                }
                                                                              });
                                                                            });
                                                                            invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply)
                                                                                ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                : invoice.grossAmount - invoice.discount;
                                                                            invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
                                                                            setState(() {});
                                                                          } else if (_isTaxApply == false) {
                                                                            invoice.netAmount = invoice.grossAmount - invoice.discount;
                                                                          }
                                                                        }
                                                                        _calculate();
                                                                        setState(() {});
                                                                      } catch (e) {
                                                                        print('Exception - purchaseInvoiceAddScreen.dart - UP_onChanged: ' + e.toString());
                                                                      }
                                                                    },
                                                                    validator: (v) {
                                                                      if (v.isEmpty) {
                                                                        return '';
                                                                      } else if (v == '0') {
                                                                        return '';
                                                                      } else if (v.contains(RegExp('[a-zA-Z]'))) {
                                                                        return global.appLocaleValues['vel_enter_number_only'];
                                                                      }
                                                                      return null;
                                                                    },

                                                                    inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0')
                                                                        ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))]
                                                                        : [FilteringTextInputFormatter.digitsOnly],
                                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      trailing: SizedBox(
                                                        width: 20,
                                                        child: IconButton(
                                                          // padding: EdgeInsets.zero,
                                                          icon: Icon(
                                                            Icons.cancel,
                                                            color: Colors.red,
                                                          ),
                                                          onPressed: () async {
                                                            await _removeProduct(index);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                      title: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          '${global.appLocaleValues['lbl_sub_total']}',
                                          style: TextStyle(color: Colors.grey, fontSize: 17),
                                        ),
                                      ),
                                      trailing: (invoice.invoiceDetailList.length > 0)
                                          ? Text(
                                              '${global.currency.symbol} ${invoice.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                              style: TextStyle(fontSize: 20),
                                            )
                                          : Container(
                                              width: MediaQuery.of(context).size.width / 2,
                                              child: TextFormField(
                                                inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                                                //  maxLength: 5,
                                                onChanged: (value) {
                                                  invoice.grossAmount = (value.length > 0) ? double.parse(value) : 0;
                                                  if (invoice.id == null) {
                                                    if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false' || invoice.invoiceDetailList.length < 1)) {
                                                      invoice.finalTax = 0.0;
                                                      for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                        invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                                                        _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                                                        if (_isTaxApply) {
                                                          invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                                                        }
                                                      }
                                                      invoice.netAmount =
                                                          (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                                                    } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                      invoice.netAmount =
                                                          (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                                                    } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                                      invoice.netAmount = invoice.grossAmount - invoice.discount;
                                                    }
                                                  } else {
                                                    if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length == 0) {
                                                      invoice.finalTax = 0.0;
                                                      for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                        invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                                                        _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                                                        if (_isTaxApply) {
                                                          invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                                                        }
                                                      }
                                                      invoice.netAmount =
                                                          (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                                                    } else if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length != 0) {
                                                      invoice.netAmount =
                                                          (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                                                    } else if (_isTaxApply == false) {
                                                      invoice.netAmount = invoice.grossAmount - invoice.discount;
                                                    }
                                                  }
                                                  _calculate();
                                                  setState(() {});
                                                },
                                                textInputAction: TextInputAction.next,
                                                controller: _cNetAmount,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(fontSize: 20),
                                                //   readOnly: (invoice.id != null && DateTime.now().difference(invoice.createdAt).inDays != 0) ? true : false,
                                                decoration: InputDecoration(
                                                  border: nativeTheme().inputDecorationTheme.border,
                                                  counterText: '',
                                                ),
                                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                focusNode: _fNetAmount,
                                                validator: (value) {
                                                  if (invoice.invoiceDetailList.length < 1 && value.isEmpty) {
                                                    return global.appLocaleValues['lbl_sub_total_err_req'];
                                                  } else if (value.contains(RegExp('[a-zA-Z]'))) {
                                                    return global.appLocaleValues['vel_enter_number_only'];
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child: Divider(),
                                  ),
                                  ListTile(
                                      title: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          '${global.appLocaleValues['lbl_discount']}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(color: Colors.grey, fontSize: 17),
                                        ),
                                      ),
                                      trailing: Container(
                                        width: MediaQuery.of(context).size.width / 2,
                                        child: TextFormField(
                                          inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                                          maxLength: 5,
                                          onChanged: (value) {
                                            invoice.discount = (value.length > 0) ? double.parse(value) : 0;
                                            if (invoice.id == null) {
                                              if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
                                                invoice.finalTax = 0.0;
                                                for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                  invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                                                  _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                                                  if (_isTaxApply) {
                                                    invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                                                  }
                                                }
                                                invoice.netAmount =
                                                    (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                                              } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                invoice.netAmount =
                                                    (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                                              } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                                invoice.netAmount = invoice.grossAmount - invoice.discount;
                                              }
                                            } else {
                                              if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length == 0) {
                                                invoice.finalTax = 0.0;
                                                for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                  invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                                                  _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                                                  if (_isTaxApply) {
                                                    invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                                                  }
                                                }
                                                invoice.netAmount =
                                                    (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                                              } else if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length != 0) {
                                                invoice.netAmount =
                                                    (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                                              } else if (_isTaxApply == false) {
                                                invoice.netAmount = invoice.grossAmount - invoice.discount;
                                              }
                                            }
                                            _calculate();
                                            setState(() {});
                                          },
                                          textInputAction: TextInputAction.next,
                                          controller: _cDiscount,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(fontSize: 20),
                                          //   readOnly: (invoice.id != null && DateTime.now().difference(invoice.createdAt).inDays != 0) ? true : false,
                                          decoration: InputDecoration(
                                            border: nativeTheme().inputDecorationTheme.border,
                                            counterText: '',
                                          ),
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          focusNode: _fDiscount,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return global.appLocaleValues['lbl_discount_err_req'];
                                            } else if (value.contains(RegExp('[a-zA-Z]'))) {
                                              return global.appLocaleValues['vel_enter_number_only'];
                                            }
                                            return null;
                                          },
                                        ),
                                      )),
                                  (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' || invoice.invoiceTaxList.length > 0)
                                      ? Padding(
                                          padding: const EdgeInsets.only(left: 10, right: 10),
                                          child: Divider(),
                                        )
                                      : SizedBox(),
                                  (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true')
                                      ? SizedBox(
                                          height: 40,
                                          child: ListTile(
                                            title: Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                global.appLocaleValues['lbl_apply_tax'],
                                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            trailing: Switch(
                                              value: _isTaxApply,
                                              onChanged: (value) async {
                                                await _onApplyTaxChanged(value);
                                              },
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  (_isTaxApply)
                                      ? Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Flexible(
                                                  child: RadioListTile(
                                                    dense: false,
                                                    value: 0,
                                                    groupValue: _selectedTaxGroup,
                                                    title: Text('GST'),
                                                    onChanged: (int value) async {
                                                      await _onTaxGroupChanged(value);
                                                    },
                                                  ),
                                                ),
                                                Flexible(
                                                  child: RadioListTile(
                                                    dense: false,
                                                    value: 1,
                                                    groupValue: _selectedTaxGroup,
                                                    title: Text('IGST'),
                                                    onChanged: (int value) async {
                                                      await _onTaxGroupChanged(value);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ListView.builder(
                                              itemCount: invoice.invoiceTaxList.length,
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(bottom: 7),
                                                  child: SizedBox(
                                                      //height: 40,
                                                      child: ListTile(
                                                          title: Padding(
                                                            padding: EdgeInsets.only(left: 10),
                                                            child: (invoice.id == null)
                                                                ? (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false')
                                                                    ? Text(
                                                                        '${invoice.invoiceTaxList[index].taxName} (${invoice.invoiceTaxList[index].percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%)',
                                                                        style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                      )
                                                                    : Text(
                                                                        '${invoice.invoiceTaxList[index].taxName}',
                                                                        style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                      )
                                                                : (_isTaxApply == true && invoice.invoiceDetailTaxList.length == 0)
                                                                    ? Text(
                                                                        '${invoice.invoiceTaxList[index].taxName} (${invoice.invoiceTaxList[index].percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%)',
                                                                        style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                      )
                                                                    : Text(
                                                                        '${invoice.invoiceTaxList[index].taxName}',
                                                                        style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                      ),
                                                          ),
                                                          trailing: Container(
                                                            width: MediaQuery.of(context).size.width / 2,
                                                            child: TextFormField(
                                                              inputFormatters:
                                                                  (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                                                              onChanged: (value) {
                                                                if (value.length > 0) {
                                                                  invoice.invoiceTaxList.map((e) => e.totalAmount = double.parse(value)).toList();
                                                                }
                                                                for (int i = 0; i < _cTaxAmount.length; i++) {
                                                                  if (i != index) {
                                                                    _cTaxAmount[i].text = value;
                                                                  }
                                                                }

                                                                invoice.finalTax = invoice.invoiceTaxList.map((e) => e.totalAmount).reduce((value, element) => value + element);
                                                                invoice.netAmount = (invoice.grossAmount - invoice.discount) + invoice.finalTax;
                                                                setState(() {});
                                                              },
                                                              controller: _cTaxAmount[index],
                                                              textAlign: TextAlign.end,
                                                              style: TextStyle(fontSize: 20),
                                                              decoration: InputDecoration(
                                                                border: nativeTheme().inputDecorationTheme.border,
                                                              ),
                                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                                      // trailing: Text(
                                                      //   '${global.currency.symbol} ${invoice.invoiceTaxList[index].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                      //   style: TextStyle(fontSize: 20),
                                                      // )),
                                                      ),
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child: Divider(),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: ListTile(
                                        title: Text('${global.appLocaleValues['lbl_total']}', style: Theme.of(context).primaryTextTheme.headline1),
                                        trailing: Text('${global.currency.symbol} ${invoice.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: Theme.of(context).primaryTextTheme.headline5)),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: <Widget>[
                                  MaterialButton(
                                    color: Theme.of(context).primaryColor,
                                    minWidth: MediaQuery.of(context).size.width,
                                    child: Text(
                                      '${global.appLocaleValues['btn_add_payment']}',
                                    ),
                                    onPressed: () async {
                                      await _addPaymentMethod();
                                    },
                                  ),
                                  SingleChildScrollView(
                                    child: Container(
                                        //   width: 500,
                                        child: Column(
                                      children: <Widget>[
                                        ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: invoice.payment.paymentDetailList.length,
                                          itemBuilder: (context, index) {
                                            return (!invoice.payment.paymentDetailList[index].deletedFromScreen)
                                                ? Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 20,
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons.cancel,
                                                            color: Colors.red,
                                                          ),
                                                          onPressed: () async {
                                                            try {
                                                              if (invoice.id == null) {
                                                                invoice.payment.paymentDetailList.removeAt(index);
                                                              } else {
                                                                invoice.payment.paymentDetailList[index].deletedFromScreen = true;
                                                              }
                                                              _calculate();
                                                              setState(() {});
                                                            } catch (e) {
                                                              print('Exception - purchaseInvoiceAddScreen.dart - _onDeletePayment(): ' + e.toString());
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 55,
                                                          child: ListTile(
                                                              onTap: () async {
                                                                try {
                                                                  invoice.payment.paymentDetailList[index].isEdited = true;
                                                                  await showDialog(
                                                                      context: context,
                                                                      builder: (_) {
                                                                        return PaymentAddDialog(
                                                                          remainAmountToPay: double.parse((_totalDue + invoice.payment.paymentDetailList[index].amount).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))),
                                                                          paymentDetailEdit: invoice.payment.paymentDetailList[index],
                                                                        );
                                                                      }).then((value) {
                                                                    if (value != null) {
                                                                      invoice.payment.paymentDetailList.insert(index, value);
                                                                      invoice.payment.paymentDetailList.removeAt(index + 1);
                                                                      _calculate();
                                                                      setState(() {});
                                                                    }
                                                                  });
                                                                } catch (e) {
                                                                  print('Exception - purchaseInvoiceAddScreen.dart - _onEditPayment(): ' + e.toString());
                                                                }
                                                              },
                                                              title: Text(
                                                                '${invoice.payment.paymentDetailList[index].paymentMode}',
                                                                style: TextStyle(color: Colors.grey, fontSize: 17),
                                                              ),
                                                              subtitle: (invoice.payment.paymentDetailList[index].remark.isNotEmpty) ? Text('${invoice.payment.paymentDetailList[index].remark}') : null,
                                                              trailing: Text(
                                                                '${global.currency.symbol} ${invoice.payment.paymentDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                                style: TextStyle(fontSize: 17),
                                                              )),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : SizedBox();
                                          },
                                        ),
                                        (invoice.payment.paymentDetailList.length > 0)
                                            ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                                    child: Divider(),
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                    child: ListTile(
                                                        title: Padding(
                                                          padding: EdgeInsets.only(left: 10),
                                                          child: Text(
                                                            '${global.appLocaleValues['lbl_totoal_paid']}',
                                                            style: TextStyle(color: Colors.green, fontSize: 17),
                                                          ),
                                                        ),
                                                        trailing: Text(
                                                          '${global.currency.symbol} ${_totalPaid.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                          style: TextStyle(fontSize: 17),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                    child: ListTile(
                                                        title: Padding(
                                                          padding: EdgeInsets.only(left: 10),
                                                          child: Text(
                                                            (_totalDue >= 0) ? '${global.appLocaleValues['lbl_net_payable_due']}' : '${global.appLocaleValues['lbl_total_credit']}',
                                                            style: TextStyle(color: Colors.grey, fontSize: 17),
                                                          ),
                                                        ),
                                                        trailing: Text(
                                                            (_totalDue >= 0)
                                                                ? ' ${global.currency.symbol} ${_totalDue.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'
                                                                : ' ${global.currency.symbol} ${(_totalDue * -1).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                            style: TextStyle(fontSize: 17))),
                                                  ),
                                                ],
                                              )
                                            : SizedBox()
                                      ],
                                    )),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                maxLines: 8,
                                controller: _cRemark,
                                decoration: InputDecoration(
                                  hintText: '${global.appLocaleValues['lbl_note_remark']}',
                                  labelText: '${global.appLocaleValues['lbl_note_remark']} (${global.appLocaleValues['lbl_optional']})',
                                  border: nativeTheme().inputDecorationTheme.border,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: <Widget>[
                                      MaterialButton(
                                        color: Theme.of(context).primaryColor,
                                        minWidth: MediaQuery.of(context).size.width,
                                        child: Text(
                                          global.appLocaleValues['btn_upload_invoice_copy'],
                                        ),
                                        onPressed: () async {
                                          await _uploadOptions(context);
                                        },
                                      ),

                                      ListTile(
                                        contentPadding: EdgeInsets.only(left: 0),
                                        title: (_pdfPath != '')
                                            ? Text(global.appLocaleValues['lbl_doc'])
                                            : Text(
                                                global.appLocaleValues['lbl_no_doc'],
                                                style: TextStyle(color: Colors.grey),
                                              ),
                                        trailing: (_pdfPath != '')
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  IconButton(
                                                    icon: Icon(Icons.visibility, color: Theme.of(context).primaryColor),
                                                    onPressed: () async {
                                                      global.isAppOperation = true;
                                                      await OpenFile.open(_pdfPath);
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.cancel, color: Colors.red),
                                                    onPressed: () {
                                                      _deletePdf();
                                                    },
                                                  ),
                                                ],
                                              )
                                            : null,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          '${global.appLocaleValues['lbl_note']}: ${global.appLocaleValues['note_upload_inv']}',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      )

                                      // SizedBox(
                                      //   height: 600,
                                      //   child: GridView.count(
                                      //     shrinkWrap: true,
                                      //     physics: NeverScrollableScrollPhysics(),
                                      //     crossAxisCount: 3,
                                      //     children: List.generate(images.length, (index) {
                                      //       Asset asset = images[index];
                                      //       return Padding(
                                      //         padding: const EdgeInsets.all(3.0),
                                      //         child: AssetThumb(
                                      //           asset: asset,
                                      //           width: 300,
                                      //           height: 300,
                                      //         ),
                                      //       );
                                      //     }),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Card(
                            //   shape: nativeTheme().cardTheme.shape,
                            //   child: ListTile(
                            //     leading: Text('Completed'),
                            //     trailing: Switch(
                            //       value: _isComplete,
                            //       onChanged: (value) {
                            //         setState(() {});
                            //       },
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
        ));
  }

  Future _uploadOptions(context) async {
    try {
      //choose options for upload pic
      await showModalBottomSheet(
          context: context,
          builder: (BuildContext bcon) {
            return Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                    title: Text(global.appLocaleValues['lt_select_img']),
                    onTap: () async {
                      Navigator.pop(context);
                      global.isAppOperation = true;
                      showLoader(global.appLocaleValues['txt_wait']);
                      setState(() {});
                      // _pdfPath = await br.generatePdf(global.purchaseBillsDirectoryPath);
                      hideLoader();
                      setState(() {});
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.picture_as_pdf,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(global.appLocaleValues['lt_upload_pdf']),
                    onTap: () async {
                      showLoader(global.appLocaleValues['txt_wait']);
                      global.isAppOperation = true;
                      setState(() {});
                      // _pdfPath = await br.openFileExplorer(global.purchaseBillsDirectoryPath);
                      hideLoader();
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
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
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _uploadOptions(): ' + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fInvoiceDate.removeListener(_focusListener);
    _fDeliveryDate.removeListener(_focusListener);
    _fDiscount.removeListener(_discountListener);
    _fNetAmount.removeListener(_netAmountListener);
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      _fInvoiceDate.addListener(_focusListener);
      _fDiscount.addListener(_discountListener);
      _fNetAmount.addListener(_netAmountListener);
      _fDeliveryDate.addListener(_focusListener);
      _unitList = await dbHelper.unitGetList();
      _unitCombinationList = await dbHelper.unitCombinationGetList();
      if (invoice.id != null) {
        await _getDetailForUpdateInvoice();
      } else {
        invoice = PurchaseInvoice();
        invoice.payment = Payment();
        if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true') {
          _isTaxApply = true;
          await _getTaxes();
        } else {
          _isTaxApply = false;
        }
        //   _cTax.text = '0.0';
        invoice.finalTax = 0.0;
        invoice.discount = 0.0;
        _cDiscount.text = invoice.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        //    _cGrossAmount.text = '0.0';
        invoice.grossAmount = 0.0;
        //     _cNetAmount.text = '0.0';
        invoice.netAmount = 0.0;
        _cNetAmount.text = invoice.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        _cInvoiceDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _invoiceDate2 = DateTime.now().toString().substring(0, 10);
        _deliveryDate2 = DateTime.now().toString().substring(0, 10);
        _isDataLoaded = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _accountListener() async {
    try {
      await Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => AccountSelectDialog(
                    a: widget.analytics,
                    o: widget.observer,
                    returnScreenId: 2,
                    selectedAccount: (selectedAccount) {
                      _account = selectedAccount;
                      //  String _code = '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _account.accountCode.toString().length))}${_account.accountCode}';
                      _cAccountId.text = '${_account.firstName} ${_account.lastName}';
                    },
                  )))
          .then((v) {
        if (_account == null) {
          if (v != null) {
            _account = v;
            // String _code = '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _account.accountCode.toString().length))}${_account.accountCode}';
            _cAccountId.text = '${_account.firstName} ${_account.lastName}';
          }
        }
      });
      setState(() {});
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _accountListener(): ' + e.toString());
    }
  }

  Future _addPaymentMethod() async {
    try {
      if (invoice.grossAmount != null) {
        //   _totalDue = (invoice.payment.paymentDetailList.length != 0) ? invoice.grossAmount - invoice.payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount) : invoice.grossAmount;
        if (invoice.netAmount != 0) {
          if (_totalDue > 0) {
            await showDialog(
                context: context,
                builder: (_) {
                  return PaymentAddDialog(
                    remainAmountToPay: double.parse(_totalDue.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))),
                    paymentDetail: (object) {
                      invoice.payment.paymentDetailList.add(object);
                      invoice.payment.paymentDetailList[invoice.payment.paymentDetailList.length - 1].isRecentlyAdded = (invoice.id != null) ? true : false;
                      _calculate();
                    },
                  );
                });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['lbl_err_vld_payment']}')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text((br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product'
                  ? global.appLocaleValues['lbl_err_vld_payment_pro']
                  : br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service'
                      ? global.appLocaleValues['lbl_err_vld_payment_ser']
                      : global.appLocaleValues['lbl_err_vld_payment_both']))));
        }
        setState(() {
          FocusScope.of(context).requestFocus(_focusNode);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${global.appLocaleValues['txt_payment_err_vld']}'),
        ));
      }
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _addPaymentMethod(): ' + e.toString());
    }
  }

  Future _addProducts() async {
    try {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductSelectDialog(
              a: widget.analytics,
              o: widget.observer,
              selectedProducts: invoice.invoiceDetailList.map((invoice) => invoice.product).toList(),
              returnScreenId: 0,
              onValueSelected: (product) async {
                //  invoice.invoiceDetailList.clear();
                if (invoice.id == null) {
                  invoice.invoiceDetailTaxList.clear();
                }
                //   _cUnitPriceList.clear();
                //    _cQtyList.clear();
                //   _cUnitList.clear();
                // invoice.netAmount = 0;
                //   _remainAmount = 0;
                product.forEach((item) {
                  PurchaseInvoiceDetail invoiceDetail = PurchaseInvoiceDetail(null, null, item.id, item.productPriceList[0].unitId, item.productPriceList[0].unitId, _unitList.firstWhere((element) => element.id == item.productPriceList[0].unitId).code, 1, item.productPriceList[0].price,
                      item.productPriceList[0].price, item.name, item.productCode, item.productTypeName, item.productPriceList[0].price, false, null, null);
                  invoiceDetail.product = item;
                  invoice.invoiceDetailList.add(invoiceDetail);
                  _cUnitPriceList.add(TextEditingController(text: '${invoiceDetail.unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'));
                  _cQtyList.add(TextEditingController(text: '${invoiceDetail.quantity}'));
                  if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
                    _cUnitList.add(TextEditingController(text: '${_unitList.firstWhere((element) => element.id == invoiceDetail.product.productPriceList[0].unitId).code}'));
                  }
                  invoice.grossAmount += item.productPriceList[0].price;
                });
                if (invoice.id == null) {
                  if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
                    //  invoice.finalTax = 0.0;
                    for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                      invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                      _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                      if (_isTaxApply) {
                        invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                      }
                    }
                    invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                  } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                    //   invoice.finalTax = 0.0;
                    invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
                    _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.productId).toList());

                    invoice.invoiceDetailList.forEach((invoiceDetail) {
                      _productTaxList.forEach((productTax) {
                        if (invoiceDetail.productId == productTax.productId) {
                          for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                            if (invoice.invoiceTaxList[i].taxId == productTax.taxMasterId) {
                              invoice.invoiceTaxList[i].totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                              _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                              PurchaseInvoiceDetailTax _invoiceDetailTax = PurchaseInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.amount * productTax.percentage) / 100);
                              invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                            }
                          }
                        }
                      });
                    });
                    invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceDetailTax) => invoiceDetailTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                    invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
                    setState(() {});
                  } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                    invoice.netAmount = invoice.grossAmount - invoice.discount;
                  }
                } else {
                  if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length == 0) {
                    //    invoice.finalTax = 0.0;
                    for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                      invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                      _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                      if (_isTaxApply) {
                        invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                      }
                    }
                    invoice.netAmount = (_isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                  } else if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length != 0) {
                    //  invoice.finalTax = 0.0;
                    invoice.invoiceDetailTaxList.clear();
                    invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
                    _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.productId).toList());

                    invoice.invoiceDetailList.forEach((invoiceDetail) {
                      _productTaxList.forEach((productTax) {
                        if (invoiceDetail.productId == productTax.productId) {
                          for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                            if (invoice.invoiceTaxList[i].taxId == productTax.taxMasterId) {
                              invoice.invoiceTaxList[i].totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                              _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                              PurchaseInvoiceDetailTax _invoiceDetailTax = PurchaseInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.amount * productTax.percentage) / 100);
                              invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                            }
                          }
                        }
                      });
                    });
                    invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                    invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
                    setState(() {});
                  } else if (_isTaxApply == false) {
                    invoice.netAmount = invoice.grossAmount - invoice.discount;
                  }
                }
                _calculate();
              })));

      setState(() {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _addProducts(): ' + e.toString());
    }
  }

  Future<Null> _focusListener() async {
    try {
      if (_fInvoiceDate.hasFocus || _fDeliveryDate.hasFocus) {
        if (_fInvoiceDate.hasFocus) {
          _isTransactionDateSelection = true;
        } else {
          _isTransactionDateSelection = false;
        }
        _selectDate(context); //open date picker
      }
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _focusListener(): ' + e.toString());
    }
  }

  Future _getDetailForUpdateInvoice() async {
    try {
      invoice.invoiceDetailList = await dbHelper.purchaseInvoiceDetailGetList(
        invoiceId: invoice.id,
      );
      _selectedTaxGroup = (invoice.taxGroup == "GST") ? 0 : 1;
      _cInvoiceDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.invoiceDate);
      _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.deliveryDate);
      _cInvoiceNumber.text = invoice.invoiceNumber;
      _invoiceDate2 = invoice.invoiceDate.toString();
      _deliveryDate2 = invoice.deliveryDate.toString();
      _pdfPath = invoice.pdfPath;
      _cRemark.text = invoice.remark;
      List<Product> _productList = await dbHelper.productGetList(productId: invoice.invoiceDetailList.map((item) => item.productId).toList());

      for (int i = 0; i < invoice.invoiceDetailList.length; i++) {
        _cQtyList.add(TextEditingController(text: invoice.invoiceDetailList[i].quantity.toString()));
        _cUnitPriceList.add(TextEditingController(text: invoice.invoiceDetailList[i].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString()));
        for (int j = 0; j < _productList.length; j++) {
          if (_productList[j].id == invoice.invoiceDetailList[i].productId) {
            _productList[j].productPriceList = await dbHelper.productPriceGetList(_productList[j].id);
            invoice.invoiceDetailList[i].product = _productList[j];
            if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
              UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == _productList[j].unitCombinationId);
              invoice.invoiceDetailList[i].product.unitList.add(_unitList.firstWhere((element) => element.id == _unitCombination.primaryUnitId));
              if (_unitCombination.secondaryUnitId != null) {
                invoice.invoiceDetailList[i].product.unitList.add(_unitList.firstWhere((element) => element.id == _unitCombination.secondaryUnitId));
              }
            }
          }
        }
        if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
          _cUnitList.add(TextEditingController(text: '${invoice.invoiceDetailList[i].product.unitList.firstWhere((element) => element.id == invoice.invoiceDetailList[i].unitId).code}'));
        }
      }
      List<PaymentPurchaseInvoice> _paymentInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(invoiceId: invoice.id, isCancel: false);
      List<PaymentDetail> _paymentDetailList = (_paymentInvoiceList.length != 0) ? await dbHelper.paymentDetailGetList(paymentIdList: _paymentInvoiceList.map((paymentDetail) => paymentDetail.paymentId).toList()) : null;
      invoice.payment.paymentDetailList = (_paymentDetailList != null)
          ? (_paymentDetailList.length != 0)
              ? _paymentDetailList
              : []
          : [];

      invoice.invoiceTaxList = await dbHelper.purchaseInvoiceTaxGetList(invoiceId: invoice.id);
      invoice.invoiceTaxList.forEach((element) {
        _cTaxAmount.add(TextEditingController(text: element.totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))));
      });
      _isTaxApply = (invoice.invoiceTaxList.length != 0) ? true : false;
      invoice.invoiceDetailTaxList = await dbHelper.purchaseInvoiceDetailTaxGetList(invoiceDetailIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.id).toList());
      _invoiceDetailTaxIdList = invoice.invoiceDetailTaxList.map((e) => e.id).toList();
      _invoiceDetailTaxLen = invoice.invoiceDetailTaxList.length;
      //  invoice.invoiceDetailTaxList.map((idt) => print('${idt.invoiceDetailId} ${idt.taxId}:${idt.percentage}')).toList();
      _cAccountId.text = '${invoice.account.firstName} ${invoice.account.lastName}';
      //   '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + invoice.account.accountCode.toString().length))}${invoice.account.accountCode} - ${invoice.account.firstName} ${invoice.account.lastName}';
      _cDiscount.text = invoice.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _cNetAmount.text = invoice.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _isComplete = invoice.isComplete;
      _calculate();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _getDetailForUpdateInvoice(): ' + e.toString());
    }
  }

  Future showAlertd() async {
    try {
      AlertDialog dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        content: Text(global.appLocaleValues['txt_inv_changes_discard']),
        actions: <Widget>[
          TextButton(
            child: Text(global.appLocaleValues['btn_cancel']),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_yes']),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => PurchaseInvoiceScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      )));
            },
          ),
        ],
      );
      await showDialog(builder: (context) => dialog, context: context);
    } catch (e) {
      print('Exception - invoiceaddscreen.dart - showAlertd(): ' + e.toString());
    }
  }

  Future _onSubmit() async {
    try {
      if (_formKey.currentState.validate()) {
        if (invoice.netAmount > 0) {
          showLoader(global.appLocaleValues['txt_wait']);
          setState(() {});
          invoice.accountId = (_account != null) ? _account.id : invoice.accountId;
          invoice.invoiceDate = DateTime.parse(_invoiceDate2);
          invoice.deliveryDate = DateTime.parse(_deliveryDate2);
          invoice.invoiceNumber = _cInvoiceNumber.text;
          invoice.pdfPath = _pdfPath;
          invoice.isComplete = _isComplete;
          if (invoice.finalTax > 0) {
            invoice.taxGroup = (_selectedTaxGroup == 0) ? "GST" : "IGST";
          }
          if (invoice.payment.paymentDetailList.length == 0) {
            invoice.status = 'DUE';
          } else {
            double _amount = 0;
            invoice.payment.paymentDetailList.forEach((element) {
              if (!element.deletedFromScreen) {
                _amount += element.amount;
              }
            });
            if ((invoice.netAmount - _amount) <= 0) {
              invoice.status = 'PAID';
            } else {
              invoice.status = 'DUE';
            }
          }
          invoice.remark = _cRemark.text.trim();
          if (invoice.id == null) {
            invoice = await dbHelper.purchaseInvoiceInsert(invoice, _isTaxApply);
          } else {
            int a = await dbHelper.purchaseInvoiceDetailTaxDelete(invoiceDetailTaxIdList: _invoiceDetailTaxIdList);
            print("detailtax: $a");
            int b = await dbHelper.purchaseInvoiceTaxDelete(invoice.id);
            print("tax: $b");
            invoice = await dbHelper.purchaseInvoiceUpdate(invoice: invoice, updateFrom: 1, isTaxApplied: _isTaxApply, isAccountChanged: _accountChanged);
          }
          hideLoader();
          setState(() {});
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => PurchaseInvoiceScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(global.appLocaleValues['txt_total_vld'])));
        }
      } else {
        _autoValidate = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _onSubmit(): ' + e.toString());
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    try {
      // choose dob
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != DateTime(2000)) {
        setState(() {
          if (_isTransactionDateSelection) {
            _cInvoiceDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
            _invoiceDate2 = picked.toString().substring(0, 10);
            _cDeliveryDate.text = _cInvoiceDate.text;
            _deliveryDate2 = _invoiceDate2;
          } else {
            String _tempDate = picked.toString().substring(0, 10);
            if (DateTime.parse(_tempDate).isAfter(DateTime.parse(_invoiceDate2)) || _tempDate == _invoiceDate2) {
              _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
              _deliveryDate2 = picked.toString().substring(0, 10);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  global.appLocaleValues['lbl_delivery_date_err_vld'],
                ),
                duration: Duration(seconds: 2),
              ));
            }
          }
        });
      }
      FocusScope.of(context).requestFocus(_focusNode);
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _selectDate(): ' + e.toString());
    }
  }

  Future _getTaxes() async {
    try {
      _taxList.clear();
      _cTaxAmount.clear();
      if (_allTaxList.length < 1) {
        _allTaxList = await dbHelper.taxMasterGetList();
      }
      _allTaxList.forEach((element) {
        if (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
          if (_selectedTaxGroup == 0) {
            if (element.isActive && element.groupName == "GST") {
              _taxList.add(element);
            }
          } else {
            if (element.isActive && element.groupName == "IGST") {
              _taxList.add(element);
            }
          }
        } else {
          if (_selectedTaxGroup == 0) {
            if (element.isActive && element.isApplyOnProduct && element.groupName == "GST") {
              _taxList.add(element);
            }
          } else {
            if (element.isActive && element.isApplyOnProduct && element.groupName == "IGST") {
              _taxList.add(element);
            }
          }
        }
      });

      for (int i = 0; i < _taxList.length; i++) {
        PurchaseInvoiceTax _invoiceTax = PurchaseInvoiceTax(null, null, _taxList[i].id, _taxList[i].percentage, 0.0);
        _invoiceTax.taxName = _taxList[i].taxName;
        invoice.invoiceTaxList.add(_invoiceTax);
        _cTaxAmount.add(TextEditingController(text: _invoiceTax.totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))));
      }
      setState(() {});
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _getTaxes(): ' + e.toString());
    }
  }

  Future _removeProduct(index) async {
    try {
      invoice.grossAmount -= invoice.invoiceDetailList[index].amount;
      if (invoice.id == null) {
        if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false' || invoice.invoiceDetailList.length < 1)) {
          invoice.finalTax = 0.0;
          for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
            invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
            _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
            if (_isTaxApply) {
              invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
            }
          }
          invoice.netAmount = (_isTaxApply && invoice.invoiceTaxList.length > 0) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
        } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
          invoice.finalTax = 0.0;
          invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();

          List<int> _tempProductIdList = [];
          invoice.invoiceDetailList.forEach((invoiceDetail) {
            if (invoiceDetail.productId != invoice.invoiceDetailList[index].productId) {
              _tempProductIdList.add(invoiceDetail.productId);
            }
          });

          _productTaxList = await dbHelper.productTaxGetList(productIdList: _tempProductIdList);
          invoice.invoiceDetailTaxList.clear();
          invoice.invoiceDetailList.forEach((invoiceDetail) {
            _productTaxList.forEach((productTax) {
              if (invoiceDetail.productId == productTax.productId) {
                for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                  if (invoice.invoiceTaxList[i].taxId == productTax.taxMasterId) {
                    invoice.invoiceTaxList[i].totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                    _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                    PurchaseInvoiceDetailTax _invoiceDetailTax = PurchaseInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                    invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                  }
                }
              }
            });
          });
          invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
          invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
          invoice.netAmount = invoice.grossAmount - invoice.discount;
        }
      } else {
        if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length == 0) {
          invoice.finalTax = 0.0;
          for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
            invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
            _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
            if (_isTaxApply) {
              invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
            }
          }
          invoice.netAmount = (_isTaxApply && invoice.invoiceTaxList.length > 0) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
        } else if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length != 0) {
          invoice.finalTax = 0.0;
          invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();

          List<int> _tempProductIdList = [];
          invoice.invoiceDetailList.forEach((invoiceDetail) {
            if (invoiceDetail.productId != invoice.invoiceDetailList[index].productId) {
              _tempProductIdList.add(invoiceDetail.productId);
            }
          });

          _productTaxList = await dbHelper.productTaxGetList(productIdList: _tempProductIdList);
          invoice.invoiceDetailTaxList.clear();
          invoice.invoiceDetailList.forEach((invoiceDetail) {
            _productTaxList.forEach((productTax) {
              if (invoiceDetail.productId == productTax.productId) {
                for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                  if (invoice.invoiceTaxList[i].taxId == productTax.taxMasterId) {
                    invoice.invoiceTaxList[i].totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                    _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                    PurchaseInvoiceDetailTax _invoiceDetailTax = PurchaseInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                    invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                  }
                }
              }
            });
          });
          invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
          invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        } else if (_isTaxApply == false) {
          invoice.netAmount = invoice.grossAmount - invoice.discount;
        }
      }
      invoice.invoiceDetailList.removeAt(index);
      _cUnitPriceList.removeAt(index);
      _cQtyList.removeAt(index);
      if (_cUnitList.length > 0) {
        _cUnitList.removeAt(index);
      }
      if (invoice.invoiceDetailList.length < 1) {
        _cNetAmount.text = invoice.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        invoice.discount = 0;
        invoice.grossAmount = 0;
        _cDiscount.text = invoice.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        invoice.invoiceTaxList.map((e) => e.totalAmount = 0).toList();
      }
      FocusScope.of(context).requestFocus(_focusNode);
      _calculate();
      setState(() {});
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _removeProduct(): ' + e.toString());
    }
  }

  void _discountListener() {
    try {
      if (_fDiscount.hasFocus) {
        if (_cDiscount.text == '${0.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}') {
          _cDiscount.clear();
        }
      } else {
        if (_cDiscount.text == '') {
          _cDiscount.text = '${0.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}';
        }
      }
      setState(() {});
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _discountListener(): ' + e.toString());
    }
  }

  void _netAmountListener() {
    try {
      if (_fNetAmount.hasFocus) {
        if (_cNetAmount.text == '${0.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}') {
          _cNetAmount.clear();
        }
      } else {
        if (_cNetAmount.text == '') {
          _cNetAmount.text = '${0.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}';
        }
      }
      setState(() {});
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _netAmountListener(): ' + e.toString());
    }
  }

  void _calculate() {
    double _paid = 0;
    invoice.payment.paymentDetailList.forEach((element) {
      if (!element.deletedFromScreen) {
        _paid += element.amount;
      }
    });
    _totalPaid = _paid;
    _totalDue = invoice.netAmount - _totalPaid;
  }

  void _deletePdf() {
    try {
      final dir = Directory(_pdfPath);
      dir.delete(recursive: true);
      _pdfPath = '';
      setState(() {});
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _deletePdf(): ' + e.toString());
    }
  }

  Future _onApplyTaxChanged(bool value) async {
    try {
      if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true') {
        _isTaxApply = value;
        if (_isTaxApply != true) {
          invoice.netAmount = invoice.grossAmount - invoice.discount;
          invoice.finalTax = 0.0;
        } else {
          if (invoice.invoiceTaxList.length < 1) {
            await _getTaxes();
          }
          if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false' || invoice.invoiceDetailList.length < 1)) {
            invoice.finalTax = 0.0;
            for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
              invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
              _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
              if (_isTaxApply) {
                invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
              }
            }
            invoice.netAmount = (_isTaxApply && invoice.invoiceTaxList.length > 0) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
          } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
            invoice.finalTax = 0.0;
            _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((e) => e.productId).toList());
            invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
            invoice.invoiceDetailTaxList.clear();
            invoice.invoiceDetailList.forEach((invoiceDetail) {
              _productTaxList.forEach((productTax) {
                if (invoiceDetail.productId == productTax.productId) {
                  for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                    if (invoice.invoiceTaxList[i].taxId == productTax.taxMasterId) {
                      invoice.invoiceTaxList[i].totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                      _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                      PurchaseInvoiceDetailTax _invoiceDetailTax = PurchaseInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                      invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                    }
                  }
                }
              });
            });
            invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
            invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

            setState(() {});
          } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
            invoice.netAmount = invoice.grossAmount - invoice.discount;
          }
        }
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${global.appLocaleValues['txt_tax_disable']}'),
        ));
      }
      _calculate();
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _netAmountListener(): ' + e.toString());
    }
  }

  Future _selectUnit(int index) async {
    try {
      await showDialog(
          context: context,
          builder: (_) {
            return SelectUnitDialog(a: widget.analytics, o: widget.observer, unitList: invoice.invoiceDetailList[index].product.unitList);
          }).then((value) async {
        if (value != null) {
          List<Unit> _temp = value.toList();
          _cUnitList[index].text = _temp.firstWhere((element) => element.isSelected).code;
          invoice.invoiceDetailList[index].unitId = _temp.firstWhere((element) => element.isSelected).id;
          invoice.invoiceDetailList[index].unitCode = _temp.firstWhere((element) => element.isSelected).code;
          if (invoice.invoiceDetailList[index].unitId == invoice.invoiceDetailList[index].product.productPriceList[0].unitId) {
            // if product unit and selected unit is same
            invoice.invoiceDetailList[index].unitPrice = invoice.invoiceDetailList[index].actualUnitPrice;
            _cUnitPriceList[index].text = invoice.invoiceDetailList[index].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
            invoice.invoiceDetailList[index].amount = invoice.invoiceDetailList[index].quantity * invoice.invoiceDetailList[index].unitPrice;
          } else {
            // if product unit and selected unit is not same
            UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == invoice.invoiceDetailList[index].product.unitCombinationId);
            if (invoice.invoiceDetailList[index].unitId == _unitCombination.primaryUnitId) // if parent unit is selected
            {
              invoice.invoiceDetailList[index].unitPrice = invoice.invoiceDetailList[index].actualUnitPrice * _unitCombination.measurement;
              _cUnitPriceList[index].text = invoice.invoiceDetailList[index].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
              invoice.invoiceDetailList[index].amount = invoice.invoiceDetailList[index].quantity * invoice.invoiceDetailList[index].unitPrice;
            } else if (invoice.invoiceDetailList[index].unitId == _unitCombination.secondaryUnitId) // if child unit is selected
            {
              invoice.invoiceDetailList[index].unitPrice = invoice.invoiceDetailList[index].quantity * (invoice.invoiceDetailList[index].actualUnitPrice / _unitCombination.measurement);
              _cUnitPriceList[index].text = invoice.invoiceDetailList[index].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
              invoice.invoiceDetailList[index].amount = invoice.invoiceDetailList[index].unitPrice;
            }
          }
          // invoice.invoiceDetailList[index].amount = invoice.invoiceDetailList[index].quantity * invoice.invoiceDetailList[index].unitPrice;
          invoice.grossAmount = invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.amount).reduce((sum, amount) => sum + amount);
          if (invoice.id == null) {
            if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
              invoice.finalTax = 0.0;
              for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                if (_isTaxApply) {
                  invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                }
              }
              invoice.netAmount = (_isTaxApply && invoice.invoiceTaxList.length > 0) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
            } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
              invoice.finalTax = 0.0;
              invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
              invoice.invoiceDetailTaxList.clear();
              invoice.invoiceDetailList.forEach((invoiceDetail) {
                _productTaxList.forEach((productTax) {
                  if (invoiceDetail.productId == productTax.productId) {
                    for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                      if (invoice.invoiceTaxList[i].taxId == productTax.taxMasterId) {
                        invoice.invoiceTaxList[i].totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                        _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                        PurchaseInvoiceDetailTax _invoiceDetailTax = PurchaseInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                        invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                      }
                    }
                  }
                });
              });
              invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
              invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

              setState(() {});
            } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
              invoice.netAmount = invoice.grossAmount - invoice.discount;
            }
          } else {
            if (invoice.invoiceTaxList.length != 0 && _invoiceDetailTaxLen == 0) {
              invoice.finalTax = 0.0;
              for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                if (_isTaxApply) {
                  invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                }
              }
              invoice.netAmount = (_isTaxApply && invoice.invoiceTaxList.length > 0) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
            } else if (invoice.invoiceTaxList.length != 0 && _invoiceDetailTaxLen != 0) {
              invoice.finalTax = 0.0;
              invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
              invoice.invoiceDetailTaxList.clear();
              if (_productTaxList.length == 0) {
                _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.productId).toList());
              }
              invoice.invoiceDetailList.forEach((invoiceDetail) {
                _productTaxList.forEach((productTax) {
                  if (invoiceDetail.productId == productTax.productId) {
                    for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                      if (invoice.invoiceTaxList[i].taxId == productTax.taxMasterId) {
                        invoice.invoiceTaxList[i].totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                        _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                        PurchaseInvoiceDetailTax _invoiceDetailTax = PurchaseInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                        invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                      }
                    }
                  }
                });
              });
              invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
              invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
              setState(() {});
            } else if (_isTaxApply == false) {
              invoice.netAmount = invoice.grossAmount - invoice.discount;
            }
          }
          _calculate();
          setState(() {});
          // invoice.invoiceDetailList[index].unitPrice =
        }
      });
      setState(() {});
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _selectUnit(): ' + e.toString());
    }
  }

  Future _onTaxGroupChanged(value) async {
    try {
      _isDataLoaded = false;
      setState(() {});
      _selectedTaxGroup = value;
      invoice.finalTax = 0;
      invoice.invoiceTaxList.clear();
      _cTaxAmount.clear();
      await _getTaxes();
      if (invoice.id == null) {
        invoice.invoiceDetailTaxList.clear();
        if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
          for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
            invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
            _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
            if (_isTaxApply) {
              invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
            }
          }
          invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
        } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
          invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
          _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.productId).toList());

          invoice.invoiceDetailList.forEach((invoiceDetail) {
            _productTaxList.forEach((productTax) {
              if (invoiceDetail.productId == productTax.productId) {
                for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                  if (invoice.invoiceTaxList[i].taxId == productTax.taxMasterId) {
                    invoice.invoiceTaxList[i].totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                    _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                    PurchaseInvoiceDetailTax _invoiceDetailTax = PurchaseInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                    invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                  }
                }
              }
            });
          });
          invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceDetailTax) => invoiceDetailTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
          invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        }
      } else {
        if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length == 0) {
          for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
            invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
            _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
            if (_isTaxApply) {
              invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
            }
          }
          invoice.netAmount = (_isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
        } else if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length != 0) {
          invoice.invoiceDetailTaxList.clear();
          invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
          _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.productId).toList());

          invoice.invoiceDetailList.forEach((invoiceDetail) {
            _productTaxList.forEach((productTax) {
              if (invoiceDetail.productId == productTax.productId) {
                for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                  if (invoice.invoiceTaxList[i].taxId == productTax.taxMasterId) {
                    invoice.invoiceTaxList[i].totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                    _cTaxAmount[i].text = invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
                    PurchaseInvoiceDetailTax _invoiceDetailTax = PurchaseInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                    invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                  }
                }
              }
            });
          });
          invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
          invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        }
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _onTaxGroupChanged(): ' + e.toString());
    }
  }
}
