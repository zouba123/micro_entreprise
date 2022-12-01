// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/dialogs/paymentAddDialog.dart';
import 'package:accounting_app/dialogs/productSelectDialog.dart';
import 'package:accounting_app/dialogs/saleQuotesSelectDialog.dart';
import 'package:accounting_app/dialogs/selectUnitDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/decimalTextInputFormatter.dart';
import 'package:accounting_app/models/paymentDetailModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceModel.dart';
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/productTaxModel.dart';
import 'package:accounting_app/models/saleInvoiceDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceDetailTaxModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleInvoiceTaxModel.dart';
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/models/unitCombinationModel.dart';
import 'package:accounting_app/models/unitModel.dart';
import 'package:accounting_app/screens/saleInvoiceScreen.dart';
import 'package:accounting_app/screens/saleOrderScreen.dart';
import 'package:accounting_app/screens/salesQuoteScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SaleInvoiceAddSreen extends BaseRoute {
  final SaleInvoice invoice;
  final int screenId;
  SaleInvoiceAddSreen({@required a, @required o, @required this.invoice, this.screenId}) : super(a: a, o: o, r: 'SaleInvoiceAddSreen');
  @override
  _SaleInvoiceAddSreenState createState() => _SaleInvoiceAddSreenState(this.invoice, this.screenId);
}

class _SaleInvoiceAddSreenState extends BaseRouteState {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  // List<SaleOrder> _saleQuoteList = [];
  TextEditingController _cAccountId = TextEditingController();
  TextEditingController _cInvoiceDate = TextEditingController();
  TextEditingController _cDeliveryTime = TextEditingController();
  TextEditingController _cDeliveryDate = TextEditingController();
  TextEditingController _cRemark = TextEditingController();
  TextEditingController _cDiscount = TextEditingController();
  TextEditingController _cInvoiceNumber = TextEditingController();
  TextEditingController _cNetAmount = TextEditingController();
  TextEditingController _cVoucherNumber = TextEditingController();
  List<TextEditingController> _cUnitPriceList = [];
  List<TextEditingController> _cQtyList = [];
  List<TextEditingController> _cUnitList = [];
  List<ProductTax> _productTaxList = [];
  List<TaxMaster> _taxList = [];
  bool _isTransactionDateSelection;
  var _fAccountId = FocusNode();
  var _fDiscount = FocusNode();
  var _fNetAmount = FocusNode();
  var _fInvoiceDate = FocusNode();
  var _fDeliveryDate = FocusNode();
  var _fVoucherNumber = FocusNode();
  var _focusNode = FocusNode();
  String _generatedInvoiceNo;
//  double _remainAmount;
  bool _isComplete = false;
  bool _generateByProductCategory = false;
  bool _showRemarkInPrint = false;
  String _invoiceDate2;
  String _deliveryDate2;
  SaleInvoice invoice;
  final int screenId;
  Account _account;
  bool _isDataLoaded = false;
  bool _isTaxApply = false;
  int _invoiceDetailTaxLen;
  double _totalDue = 0;
  int _selectedTaxGroup = 0;
  double _totalPaid = 0;
  bool _accountChanged = false;
  bool _autovalidate = false;
  List<UnitCombination> _unitCombinationList = [];
  List<Unit> _unitList = [];
  List<TaxMaster> _allTaxList = [];
  List<int> _invoiceDetailTaxIdList = []; // use for delete detail tax in edit mode
  TimeOfDay _timeOfDay = TimeOfDay(hour: 9, minute: 0);

  _SaleInvoiceAddSreenState(this.invoice, this.screenId) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: (invoice.id != null) ? Text(global.appLocaleValues['lbl_update_invoice'], style: Theme.of(context).appBarTheme.titleTextStyle) : Text(global.appLocaleValues['lbl_add_invoice'], style: Theme.of(context).appBarTheme.titleTextStyle),
          actions: <Widget>[
            // (br.getSystemFlagValue(global.systemFlagNameList.enableSaleOrder) == 'true' && invoice.id == null && screenId == null)
            //     ? IconButton(
            //         tooltip: global.appLocaleValues['tt_import_orders'],
            //         icon: Icon(Icons.add_shopping_cart),
            //         iconSize: 25,
            //         color: Colors.white,
            //         onPressed: () async {
            //           await showAlertOfImportOrder();
            //         },
            //       )
            //     : SizedBox(),
            TextButton(
              onPressed: () async {
                await _onSubmit();
              },
              child: Text(global.appLocaleValues['btn_save'], style: Theme.of(context).primaryTextTheme.headline2),
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
                      key: _formKey,
                      autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 5),
                                              child: Text(global.appLocaleValues['tle_sale_inv_no'], style: Theme.of(context).primaryTextTheme.headline3),
                                            ),
                                            TextFormField(
                                              controller: _cInvoiceNumber,
                                              readOnly: true,
                                              style: Theme.of(context).primaryTextTheme.headline1,
                                              decoration: InputDecoration(
                                                // labelText: global.appLocaleValues['tle_sale_inv_no'],
                                                border: nativeTheme().inputDecorationTheme.border,
                                                suffixIcon: Icon(
                                                  Icons.star,
                                                  size: 9,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
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
                                                border: nativeTheme().inputDecorationTheme.border,
                                                // labelText: global.appLocaleValues['lbl_invoice_date'],
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
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(global.appLocaleValues['tab_ac'], style: Theme.of(context).primaryTextTheme.headline3),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
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
                                        }),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                                              child: Text(global.appLocaleValues['lbl_delivery_date'], style: Theme.of(context).primaryTextTheme.headline3),
                                            ),
                                            TextFormField(
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                border: nativeTheme().inputDecorationTheme.border,
                                                hintText: global.appLocaleValues['lbl_delivery_date'],
                                              ),
                                              focusNode: _fDeliveryDate,
                                              controller: _cDeliveryDate,
                                              keyboardType: null,
                                            ),
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
                                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                                              child: Text(global.appLocaleValues['lbl_delivery_time'], style: Theme.of(context).primaryTextTheme.headline3),
                                            ),
                                            TextFormField(
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                border: nativeTheme().inputDecorationTheme.border,
                                                hintText: global.appLocaleValues['lbl_delivery_time'],
                                              ),
                                              controller: _cDeliveryTime,
                                              keyboardType: null,
                                              onTap: () async {
                                                await _chooseDeliveryTime();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                                    child: Text('${global.appLocaleValues['lbl_voucher_no']} (${global.appLocaleValues['lbl_optional']})', style: Theme.of(context).primaryTextTheme.headline3),
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      border: nativeTheme().inputDecorationTheme.border,
                                      hintText: '${global.appLocaleValues['lbl_voucher_no']} (${global.appLocaleValues['lbl_optional']})',
                                    ),
                                    focusNode: _fVoucherNumber,
                                    controller: _cVoucherNumber,
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      child: Text(
                                        '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['btn_add_products'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['btn_add_services'] : global.appLocaleValues['btn_add_both']}',
                                        style: Theme.of(context).primaryTextTheme.headline2,
                                      ),
                                      onPressed: () async {
                                        await _addProducts();
                                      },
                                    ),
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
                                                        Text(
                                                          '${invoice.invoiceDetailList[index].product.name}',
                                                          style: Theme.of(context).primaryTextTheme.subtitle1,
                                                        ),
                                                        Text(
                                                            (br.getSystemFlagValue(global.systemFlagNameList.useProductSupplierCode) == 'true' && invoice.invoiceDetailList[index].product.supplierProductCode != '')
                                                                ? ' ${invoice.invoiceDetailList[index].product.supplierProductCode}'
                                                                : ' ${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + invoice.invoiceDetailList[index].product.productCode.toString().length))}${invoice.invoiceDetailList[index].product.productCode}',
                                                            style: Theme.of(context).primaryTextTheme.subtitle2),
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
                                                                            if (_isTaxApply) {
                                                                              invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                                                                            }
                                                                          }
                                                                          invoice.netAmount = (_isTaxApply && invoice.invoiceTaxList.length > 0)
                                                                              ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                              : invoice.grossAmount - invoice.discount;
                                                                        } else {
                                                                          //  if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                                          invoice.finalTax = 0.0;
                                                                          invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
                                                                          invoice.invoiceDetailTaxList.clear();
                                                                          if (_productTaxList.length < 1) {
                                                                            _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.productId).toList());
                                                                          }
                                                                          invoice.invoiceDetailList.forEach((invoiceDetail) {
                                                                            _productTaxList.forEach((productTax) {
                                                                              if (invoiceDetail.productId == productTax.productId) {
                                                                                invoice.invoiceTaxList.forEach((invoiceTax) {
                                                                                  if (invoiceTax.taxId == productTax.taxMasterId) {
                                                                                    invoiceTax.totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                                                                                    SaleInvoiceDetailTax _invoiceDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                                                                                    invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                                                                                  }
                                                                                });
                                                                              }
                                                                            });
                                                                          });
                                                                          invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply)
                                                                              ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                              : invoice.grossAmount - invoice.discount;
                                                                          invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

                                                                          setState(() {});
                                                                        }
                                                                        // else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                                                        //   invoice. netAmount = invoice.grossAmount - invoice.discount;
                                                                        // }
                                                                      } else {
                                                                        if (invoice.invoiceTaxList.length != 0 && _invoiceDetailTaxLen == 0) {
                                                                          invoice.finalTax = 0.0;
                                                                          for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                                            invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
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
                                                                                invoice.invoiceTaxList.forEach((invoiceTax) {
                                                                                  if (invoiceTax.taxId == productTax.taxMasterId) {
                                                                                    invoiceTax.totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                                                                                    SaleInvoiceDetailTax _invoiceDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                                                                                    invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                                                                                  }
                                                                                });
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
                                                                      print('Exception - saleInvoiceAddScreen.dart - Qty_onChanged: ' + e.toString());
                                                                    }
                                                                  },
                                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                  maxLength: 3,
                                                                  textAlign: TextAlign.center,
                                                                  controller: _cQtyList[index],
                                                                  //    readOnly: (order.id != null && DateTime.now().difference(order.createdAt).inDays != 0) ? true : false,
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
                                                                          // labelText: global.appLocaleValues['lbl_unit'],
                                                                        ),
                                                                        onTap: () async {
                                                                          await _selectUnit(index);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : SizedBox(),
                                                          SizedBox(
                                                            width: 0,
                                                          ),
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
                                                                  //    readOnly: (order.id != null && DateTime.now().difference(order.createdAt).inDays != 0) ? true : false,
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
                                                                            if (_isTaxApply) {
                                                                              invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                                                                            }
                                                                          }
                                                                          invoice.netAmount = (_isTaxApply && invoice.invoiceTaxList.length > 0)
                                                                              ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                              : invoice.grossAmount - invoice.discount;
                                                                        } else {
                                                                          // if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                                          invoice.finalTax = 0.0;
                                                                          invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
                                                                          invoice.invoiceDetailTaxList.clear();
                                                                          if (_productTaxList.length < 1) {
                                                                            _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.productId).toList());
                                                                          }
                                                                          invoice.invoiceDetailList.forEach((invoiceDetail) {
                                                                            _productTaxList.forEach((productTax) {
                                                                              if (invoiceDetail.productId == productTax.productId) {
                                                                                invoice.invoiceTaxList.forEach((invoiceTax) {
                                                                                  if (invoiceTax.taxId == productTax.taxMasterId) {
                                                                                    invoiceTax.totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                                                                                    SaleInvoiceDetailTax _invoiceDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                                                                                    invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                                                                                  }
                                                                                });
                                                                              }
                                                                            });
                                                                          });
                                                                          invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply)
                                                                              ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                              : invoice.grossAmount - invoice.discount;
                                                                          invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

                                                                          setState(() {});
                                                                        }
                                                                        // else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                                                        //   invoice. netAmount = invoice.grossAmount - invoice.discount;
                                                                        // }
                                                                      } else {
                                                                        if (invoice.invoiceTaxList.length != 0 && _invoiceDetailTaxLen == 0) {
                                                                          invoice.finalTax = 0.0;
                                                                          for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                                            invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
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
                                                                                invoice.invoiceTaxList.forEach((invoiceTax) {
                                                                                  if (invoiceTax.taxId == productTax.taxMasterId) {
                                                                                    invoiceTax.totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                                                                                    SaleInvoiceDetailTax _invoiceDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                                                                                    invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                                                                                  }
                                                                                });
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
                                                                      print('Exception - saleInvoiceAddScreen.dart - UP_onChanged: ' + e.toString());
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
                                                    trailing: IconButton(
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                      ),
                                                      onPressed: () async {
                                                        await _removeProduct(index);
                                                      },
                                                    ),
                                                  )
                                                      //    ListTile(
                                                      //   leading: Column(
                                                      //     children: [
                                                      //       SizedBox(
                                                      //         width: 80,
                                                      //         child: Column(
                                                      //           crossAxisAlignment: CrossAxisAlignment.start,
                                                      //           children: [
                                                      //             Text(
                                                      //               '${invoice.invoiceDetailList[index].product.name}',
                                                      //               overflow: TextOverflow.ellipsis,
                                                      //               style: Theme.of(context).primaryTextTheme.subtitle1,
                                                      //             ),
                                                      //             Text((br.getSystemFlagValue(global.systemFlagNameList.useProductSupplierCode) == 'true' && invoice.invoiceDetailList[index].product.supplierProductCode != '') ? ' ${invoice.invoiceDetailList[index].product.supplierProductCode}' : ' ${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + invoice.invoiceDetailList[index].product.productCode.toString().length))}${invoice.invoiceDetailList[index].product.productCode}', style: Theme.of(context).primaryTextTheme.subtitle2),
                                                      //           ],
                                                      //         ),
                                                      //       ),
                                                      //     ],
                                                      //   ),
                                                      //   subtitle: Padding(
                                                      //       padding: EdgeInsets.only(top: 10),
                                                      //       child: Text(
                                                      //         'Total:  ${global.currency.symbol} ${invoice.invoiceDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                      //         style: Theme.of(context).primaryTextTheme.subtitle1,
                                                      //       )),
                                                      //   title: Padding(
                                                      //     padding: const EdgeInsets.only(top: 5),
                                                      //     child: Row(
                                                      //       mainAxisSize: MainAxisSize.min,
                                                      //       children: [
                                                      //         Container(
                                                      //           width: 40,
                                                      //           child: Column(
                                                      //             children: [
                                                      //               Text(global.appLocaleValues['lbl_qty'], style: Theme.of(context).primaryTextTheme.subtitle2),
                                                      //               TextFormField(
                                                      //                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                      //                 onChanged: (value) async {

                                                      //                 },

                                                      //                 keyboardType:  TextInputType.numberWithOptions(decimal: true),
                                                      //                 maxLength: 3,
                                                      //                 textAlign: TextAlign.center,
                                                      //                 controller: _cQtyList[index],
                                                      //                 //    readOnly: (quote.id != null && DateTime.now().difference(quote.createdAt).inDays != 0) ? true : false,
                                                      //                 decoration: InputDecoration(
                                                      //                   focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4e2eb5))),
                                                      //                   enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                                                      //                   errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                      //                   disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[700])),
                                                      //                   border: UnderlineInputBorder(borderSide: BorderSide(width: 0.2)),
                                                      //                   counterText: '',
                                                      //                 ),
                                                      //                 validator: (v) {
                                                      //                   if (v.isEmpty) {
                                                      //                     return '';
                                                      //                   } else if (v.contains(RegExp('[a-zA-Z]'))) {
                                                      //                     return global.appLocaleValues['vel_enter_number_only'];
                                                      //                   } else if (invoice.saleQuoteList.length > 1) {
                                                      //                     int _count = invoice.saleQuoteList[0].quoteDetailList.where((element) => element.productId == invoice.invoiceDetailList[index].productId).toList().length;
                                                      //                     if (_count > 0) {
                                                      //                       double _saleOrderDetailQty = invoice.saleQuoteList[0].quoteDetailList.firstWhere((element) => element.productId == invoice.invoiceDetailList[index].productId).quantity;
                                                      //                       double _saleOrderDetailInvQty = invoice.saleQuoteList[0].quoteDetailList.firstWhere((element) => element.productId == invoice.invoiceDetailList[index].productId).invoicedQuantity;
                                                      //                       if ((_saleOrderDetailQty - _saleOrderDetailInvQty) < int.parse(v)) {
                                                      //                         return global.appLocaleValues['lbl_rQty_err_vld'];
                                                      //                       }
                                                      //                     }
                                                      //                   }
                                                      //                   return null;
                                                      //                 },
                                                      //               ),
                                                      //             ],
                                                      //           ),
                                                      //         ),
                                                      //         (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                                      //             ? SizedBox(
                                                      //                 width: 5,
                                                      //               )
                                                      //             : SizedBox(),
                                                      //         (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                                      //             ? Container(
                                                      //                 width: 45,
                                                      //                 child: TextFormField(
                                                      //                   readOnly: true,
                                                      //                   controller: _cUnitList[index],
                                                      //                   decoration: InputDecoration(
                                                      //                     focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4e2eb5))),
                                                      //                     enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                                                      //                     errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                      //                     disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[700])),
                                                      //                     border: UnderlineInputBorder(borderSide: BorderSide(width: 0.2)),
                                                      //                      labelText: global.appLocaleValues['lbl_unit'],
                                                      //                   ),
                                                      //                   onTap: () async {
                                                      //                     await _selectUnit(index);
                                                      //                   },
                                                      //                 ),
                                                      //               )
                                                      //             : SizedBox(),
                                                      //         SizedBox(
                                                      //           width: 0,
                                                      //         ),
                                                      //         Padding(
                                                      //           padding: const EdgeInsets.only(top: 15),
                                                      //           child: Text(
                                                      //             ' X ',
                                                      //             style: Theme.of(context).primaryTextTheme.overline,
                                                      //             textAlign: TextAlign.justify,
                                                      //           ),
                                                      //         ),
                                                      //         SizedBox(width: 5),
                                                      //         Container(
                                                      //           width: 60,
                                                      //           //  height: MediaQuery.of(context).size.height / 0.9,
                                                      //           child: Column(
                                                      //             children: [
                                                      //               Text(global.appLocaleValues['lbl_price'], style: Theme.of(context).primaryTextTheme.subtitle2),
                                                      //               TextFormField(
                                                      //                 //    readOnly: (quote.id != null && DateTime.now().difference(quote.createdAt).inDays != 0) ? true : false,
                                                      //                 controller: _cUnitPriceList[index],
                                                      //                 textAlign: TextAlign.justify,
                                                      //                 //   style: TextStyle(height: 1),
                                                      //                 decoration: InputDecoration(
                                                      //                   focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4e2eb5))),
                                                      //                   enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                                                      //                   errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                      //                   disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[700])),
                                                      //                   border: UnderlineInputBorder(borderSide: BorderSide(width: 0.2)),
                                                      //                   counterText: '',
                                                      //                 ),
                                                      //                 onChanged: (value) async {

                                                      //                 },
                                                      //                 validator: (v) {
                                                      //                   if (v.isEmpty) {
                                                      //                     return '';
                                                      //                   } else if (v == '0') {
                                                      //                     return '';
                                                      //                   } else if (v.contains(RegExp('[a-zA-Z]'))) {
                                                      //                     return global.appLocaleValues['vel_enter_number_only'];
                                                      //                   }
                                                      //                   return null;
                                                      //                 },

                                                      //                 inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                                                      //                 keyboardType:  TextInputType.numberWithOptions(decimal: true),
                                                      //               ),
                                                      //             ],
                                                      //           ),
                                                      //         ),
                                                      //       ],
                                                      //     ),
                                                      //   ),
                                                      //   trailing: IconButton(
                                                      //     icon: Icon(
                                                      //       Icons.cancel,
                                                      //       color: Colors.red,
                                                      //     ),
                                                      //     onPressed: () async {
                                                      //       await _removeProduct(index);
                                                      //     },
                                                      //   ),
                                                      // ),
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
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                      title: Text('${global.appLocaleValues['lbl_sub_total']}', style: Theme.of(context).primaryTextTheme.headline6),
                                      trailing: (invoice.invoiceDetailList.length > 0)
                                          ? Text('${global.currency.symbol} ${invoice.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: Theme.of(context).primaryTextTheme.headline3)
                                          : Container(
                                              width: MediaQuery.of(context).size.width / 2,
                                              child: TextFormField(
                                                inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                                                // maxLength: 5,
                                                onChanged: (value) {
                                                  invoice.grossAmount = (value.length > 0) ? double.parse(value) : 0;
                                                  if (invoice.id == null) {
                                                    if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false' || invoice.invoiceDetailList.length < 1)) {
                                                      invoice.finalTax = 0.0;
                                                      for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                        invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                                                        if (_isTaxApply) {
                                                          invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                                                        }
                                                      }
                                                      invoice.netAmount =
                                                          (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                                                    } else {
                                                      // if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                      invoice.netAmount =
                                                          (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                                                    }
                                                    // else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                                    //   invoice. netAmount = invoice.grossAmount - invoice.discount;
                                                    // }
                                                  } else {
                                                    if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length == 0) {
                                                      invoice.finalTax = 0.0;
                                                      for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                        invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
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
                                    padding: const EdgeInsets.only(left: 8, right: 8),
                                    child: Divider(),
                                  ),
                                  ListTile(
                                      title: Text('${global.appLocaleValues['lbl_discount']}', textAlign: TextAlign.start, style: Theme.of(context).primaryTextTheme.headline6),
                                      trailing: Container(
                                        width: MediaQuery.of(context).size.width / 2,
                                        child: TextFormField(
                                          inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                                          maxLength: 5,
                                          onChanged: (value) {
                                            invoice.discount = (value.length > 0) ? double.parse(value) : 0;

                                            if (invoice.id == null) {
                                              if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false' || invoice.invoiceDetailList.length < 1)) {
                                                invoice.finalTax = 0.0;
                                                for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                  invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                                                  if (_isTaxApply) {
                                                    invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                                                  }
                                                }
                                                invoice.netAmount =
                                                    (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                                              } else {
                                                //  if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                invoice.netAmount =
                                                    (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                                              }
                                              //  else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                              //   invoice. netAmount = invoice.grossAmount - invoice.discount;
                                              // }
                                            } else {
                                              if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length == 0) {
                                                invoice.finalTax = 0.0;
                                                for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                                                  invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
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

                                          //  readOnly: (invoice.id != null && DateTime.now().difference(invoice.createdAt).inDays != 0) ? true : false,
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
                                          padding: const EdgeInsets.only(left: 8, right: 8),
                                          child: Divider(),
                                        )
                                      : SizedBox(),
                                  (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true')
                                      ? SizedBox(
                                          height: 40,
                                          child: ListTile(
                                            title: Text(
                                              global.appLocaleValues['lbl_apply_tax'],
                                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                                                    onChanged: (int v) async {
                                                      // _selectedTaxGroup = v;
                                                      await _onTaxGroupChanged(v);
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                                Flexible(
                                                  child: RadioListTile(
                                                    dense: false,
                                                    value: 1,
                                                    groupValue: _selectedTaxGroup,
                                                    title: Text('IGST'),
                                                    onChanged: (int v) async {
                                                      // _selectedTaxGroup = v;
                                                      await _onTaxGroupChanged(v);
                                                      setState(() {});
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
                                                return SizedBox(
                                                  height: 40,
                                                  child: ListTile(
                                                      title: (invoice.id == null)
                                                          ? (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false')
                                                              ? Text(
                                                                  '${invoice.invoiceTaxList[index].taxName} (${invoice.invoiceTaxList[index].percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%)',
                                                                  style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                )
                                                              : Text(
                                                                  '${invoice.invoiceTaxList[index].taxName}',
                                                                  style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                )
                                                          : (_isTaxApply == true && invoice.invoiceTaxList.length == 0)
                                                              ? Text(
                                                                  '${invoice.invoiceTaxList[index].taxName} (${invoice.invoiceTaxList[index].percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%)',
                                                                  style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                )
                                                              : Text(
                                                                  '${invoice.invoiceTaxList[index].taxName}',
                                                                  style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                ),
                                                      trailing: Text(
                                                        '${global.currency.symbol} ${invoice.invoiceTaxList[index].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                        style: TextStyle(fontSize: 20),
                                                      )),
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 8),
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
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      child: Text('${global.appLocaleValues['btn_add_payment']}', style: Theme.of(context).primaryTextTheme.headline2),
                                      onPressed: () async {
                                        await _addPaymentMethod();
                                      },
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Container(
                                        // width: 500,
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
                                                        child: (((invoice.saleQuoteList.length > 1 || invoice.saleOrderList.length > 1) && invoice.id == null) && invoice.payment.paymentDetailList[index].id != null)
                                                            ? SizedBox()
                                                            : IconButton(
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
                                                                    print('Exception - saleInvoiceAddScreen.dart - _onDeletePayment(): ' + e.toString());
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
                                                                  if ((invoice.id == null && invoice.payment.paymentDetailList[index].id == null) || invoice.id != null) {
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
                                                                  }
                                                                } catch (e) {
                                                                  print('Exception - saleInvoiceAddScreen.dart - _onEditPayment(): ' + e.toString());
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
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: TextFormField(
                                maxLines: 8,
                                controller: _cRemark,
                                decoration: InputDecoration(
                                  border: nativeTheme().inputDecorationTheme.border,
                                  hintText: '${global.appLocaleValues['lbl_note_remark']}',
                                  labelText: '${global.appLocaleValues['lbl_note_remark']} (${global.appLocaleValues['lbl_optional']})',
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),

                            (invoice.invoiceDetailList.length > 0)
                                ? Column(
                                    children: <Widget>[
                                      Divider(),
                                      ListTile(
                                        leading: Text(
                                            '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_genrate_invoice_by_pro_cat'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_genrate_invoice_by_ser_cat'] : global.appLocaleValues['lbl_genrate_invoice_by_both_cat']}'),
                                        trailing: Switch(
                                          value: _generateByProductCategory,
                                          onChanged: (value) {
                                            setState(() {
                                              _generateByProductCategory = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),

                            ListTile(
                              leading: Text('${global.appLocaleValues['show_rema_prn']}'),
                              trailing: Switch(
                                value: _showRemarkInPrint,
                                onChanged: (value) {
                                  setState(() {
                                    _showRemarkInPrint = value;
                                  });
                                },
                              ),
                            ),

                            // Card(
                            //   shape: nativeTheme().cardTheme.shape,
                            //   child: ListTile(
                            //     leading: Text('Completed'),
                            //     trailing: Switch(
                            //       value: _isComplete,
                            //       onChanged: (value) {
                            //         setState(() {
                            //           _isComplete = value;
                            //         });
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
      _fDeliveryDate.addListener(_focusListener);
      _fDiscount.addListener(_discountListener);
      _fNetAmount.addListener(_netAmountListener);
      _unitList = await dbHelper.unitGetList();
      _unitCombinationList = await dbHelper.unitCombinationGetList();
      if (screenId == 1) {
        await _generateInvoice();
      } else if (screenId == 2) {
        await _generateInvoiceFromOrder();
      } else if (invoice.id != null) {
        await _getDetailForUpdateInvoice();
      } else {
        invoice = SaleInvoice();
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
        invoice.netAmount = 0.0;
        //     _cNetAmount.text = '0.0';
        invoice.grossAmount = 0.0;
        _cNetAmount.text = invoice.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        _generateInvoiceNumber();
        _cInvoiceDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _invoiceDate2 = DateTime.now().toString().substring(0, 10);
        _deliveryDate2 = DateTime.now().toString().substring(0, 10);
        _isDataLoaded = true;
        _cDeliveryTime.text = '9:00 AM';
        setState(() {});
      }
    } catch (e) {
      print('Exception - saleInvoiceAddScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _accountListener() async {
    try {
      await Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => AccountSelectDialog(
                    a: widget.analytics,
                    o: widget.observer,
                    returnScreenId: 0,
                    selectedAccount: (selectedAccount) {
                      _account = selectedAccount;
                      //  String _code = '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _account.accountCode.toString().length))}${_account.accountCode}';
                      _cAccountId.text = '${_account.firstName} ${_account.lastName}';
                    },
                  )))
          .then((selectedAccount) {
        if (_account == null) {
          if (selectedAccount != null) {
            _account = selectedAccount;
            //    String _code = '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _account.accountCode.toString().length))}${_account.accountCode}';
            _cAccountId.text = '${_account.firstName} ${_account.lastName}';
          }
        }
      });
      setState(() {});
    } catch (e) {
      print('Exception - saleInvoiceAddScreen.dart - _accountListener(): ' + e.toString());
    }
  }

  Future _addPaymentMethod() async {
    try {
      if (invoice.netAmount != null) {
        //   _remainAmount = (invoice.payment.paymentDetailList.length != 0) ? invoice. netAmount - invoice.payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount) : invoice. netAmount;
        if (invoice.grossAmount != 0) {
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
      print('Exception - saleInvoiceAddScreen.dart - _addPaymentMethod(): ' + e.toString());
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
                //     invoice.invoiceDetailList.clear();
                if (invoice.id == null) {
                  invoice.invoiceDetailTaxList.clear();
                }
                //   _cUnitPriceList.clear();
                //    _cQtyList.clear();
                ////    _cUnitList.clear();
                //    invoice.grossAmount = 0;
                //  _remainAmount = 0;
                product.forEach((item) {
                  SaleInvoiceDetail invoiceDetail = SaleInvoiceDetail(null, null, item.id, item.productPriceList[0].unitId, item.productPriceList[0].unitId, _unitList.firstWhere((element) => element.id == item.productPriceList[0].unitId).code, 1, item.productPriceList[0].price,
                      item.productPriceList[0].price, item.name, item.productCode, item.productTypeName, item.productPriceList[0].price, false, null, null, item.description);
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
                      if (_isTaxApply) {
                        invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                      }
                    }
                    invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                  } else {
                    // if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                    //  invoice.finalTax = 0.0;
                    invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
                    _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.productId).toList());

                    invoice.invoiceDetailList.forEach((invoiceDetail) {
                      _productTaxList.forEach((productTax) {
                        if (invoiceDetail.productId == productTax.productId) {
                          invoice.invoiceTaxList.forEach((invoiceTax) {
                            if (invoiceTax.taxId == productTax.taxMasterId) {
                              invoiceTax.totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                              SaleInvoiceDetailTax _invoiceDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.amount * productTax.percentage) / 100);
                              invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                            }
                          });
                        }
                      });
                    });
                    invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceDetailTax) => invoiceDetailTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                    invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
                    setState(() {});
                  }
                  //  else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                  //   invoice. netAmount = invoice.grossAmount - invoice.discount;
                  // }
                } else {
                  if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length == 0) {
                    // invoice.finalTax = 0.0;
                    for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                      invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
                      if (_isTaxApply) {
                        invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
                      }
                    }
                    invoice.netAmount = (_isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
                  } else if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length != 0) {
                    //   invoice.finalTax = 0.0;
                    invoice.invoiceDetailTaxList.clear();
                    invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
                    _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.productId).toList());

                    invoice.invoiceDetailList.forEach((invoiceDetail) {
                      _productTaxList.forEach((productTax) {
                        if (invoiceDetail.productId == productTax.productId) {
                          invoice.invoiceTaxList.forEach((invoiceTax) {
                            if (invoiceTax.taxId == productTax.taxMasterId) {
                              invoiceTax.totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                              SaleInvoiceDetailTax _invoiceDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.amount * productTax.percentage) / 100);
                              invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                            }
                          });
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
      print('Exception - saleInvoiceAddScreen.dart - _addProducts(): ' + e.toString());
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
      print('Exception - saleInvoiceAddScreen.dart - _focusListener(): ' + e.toString());
    }
  }

  Future _generateInvoiceNumber() async {
    try {
      invoice.invoiceNumber = await dbHelper.saleInvoiceGetNewInvoiceNumber();
      _generatedInvoiceNo = '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${invoice.invoiceNumber}';
      _generatedInvoiceNo = '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}' + '${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - _generatedInvoiceNo.length)}' + '${invoice.invoiceNumber}';
      _cInvoiceNumber.text = _generatedInvoiceNo;
      setState(() {});
    } catch (e) {
      print('Exception - saleInvoiceAddScreen.dart - _generateInvoiceNumber(): ' + e.toString());
    }
  }

  Future _generateInvoice() async {
    try {
      await _generateInvoiceNumber();
      invoice.finalTax = 0;
      _isTaxApply = (invoice.saleQuoteList[0].quoteTaxList != null && invoice.saleQuoteList[0].quoteTaxList.length != 0) ? true : false;
      invoice.grossAmount = invoice.invoiceDetailList.map((e) => e.amount).reduce((value, element) => element + value);
      if (invoice.saleQuoteList[0].quoteTaxList != null && invoice.saleQuoteList[0].quoteTaxList.length > 0 && invoice.saleQuoteList[0].quoteDetailTaxList.length < 1) {
        for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
          invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
          if (_isTaxApply) {
            invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
          }
        }
        invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
      } else if (invoice.saleQuoteList[0].quoteTaxList != null && invoice.saleQuoteList[0].quoteTaxList.length > 0 && invoice.saleQuoteList[0].quoteDetailTaxList.length > 0) {
        invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
        _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.productId).toList());
        invoice.invoiceDetailList.forEach((invoiceDetail) {
          _productTaxList.forEach((productTax) {
            if (invoiceDetail.productId == productTax.productId) {
              invoice.invoiceTaxList.forEach((invoiceTax) {
                if (invoiceTax.taxId == productTax.taxMasterId) {
                  invoiceTax.totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                  SaleInvoiceDetailTax _invoiceDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.amount * productTax.percentage) / 100);
                  invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                }
              });
            }
          });
        });
        invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceDetailTax) => invoiceDetailTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
        invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
        setState(() {});
      } else if (invoice.saleQuoteList[0].quoteTaxList == null || invoice.saleQuoteList[0].quoteTaxList.length == 0) {
        invoice.netAmount = invoice.grossAmount - invoice.discount;
      }
      _selectedTaxGroup = (invoice.taxGroup == "GST") ? 0 : 1;
      if (invoice.invoiceDate != null) {
        _cInvoiceDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.invoiceDate);
        _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.deliveryDate);
        _invoiceDate2 = invoice.invoiceDate.toString();
        _deliveryDate2 = invoice.deliveryDate.toString();
      } else {
        _cInvoiceDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _invoiceDate2 = DateTime.now().toString().substring(0, 10);
        _deliveryDate2 = DateTime.now().toString().substring(0, 10);
      }

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
      _isTaxApply = (invoice.invoiceTaxList != null && invoice.invoiceTaxList.length != 0) ? true : false;
      _invoiceDetailTaxIdList = invoice.invoiceDetailTaxList.map((e) => e.id).toList();
      _invoiceDetailTaxLen = invoice.invoiceDetailTaxList.length;
      _cAccountId.text = '${invoice.account.firstName} ${invoice.account.lastName}';
      //     '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + invoice.account.accountCode.toString().length))}${invoice.account.accountCode} - ${invoice.account.firstName} ${invoice.account.lastName}';
      _cDiscount.text = invoice.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _cNetAmount.text = invoice.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _isComplete = invoice.isComplete;
      _generateByProductCategory = false;
      _showRemarkInPrint = invoice.showRemarkInPrint;
      _cVoucherNumber.text = invoice.voucherNumber;

      _calculate();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - saleInvoiceAddScreen.dart - _generateInvoice(): ' + e.toString());
    }
  }

  Future _generateInvoiceFromOrder() async {
    try {
      await _generateInvoiceNumber();
      invoice.finalTax = 0;
      _isTaxApply = true;
      invoice.grossAmount = invoice.invoiceDetailList.map((e) => e.amount).reduce((value, element) => element + value);
      if (invoice.saleOrderList[0].orderTaxList != null && invoice.saleOrderList[0].orderTaxList.length > 0 && invoice.saleOrderList[0].orderDetailTaxList.length < 1) {
        for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
          invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
          if (_isTaxApply) {
            invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
          }
        }
        invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
      } else if (invoice.saleOrderList[0].orderTaxList != null && invoice.saleOrderList[0].orderTaxList.length > 0 && invoice.saleOrderList[0].orderDetailTaxList.length > 0) {
        invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
        _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.productId).toList());
        invoice.invoiceDetailList.forEach((invoiceDetail) {
          _productTaxList.forEach((productTax) {
            if (invoiceDetail.productId == productTax.productId) {
              invoice.invoiceTaxList.forEach((invoiceTax) {
                if (invoiceTax.taxId == productTax.taxMasterId) {
                  invoiceTax.totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                  SaleInvoiceDetailTax _invoiceDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.amount * productTax.percentage) / 100);
                  invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                }
              });
            }
          });
        });
        invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceDetailTax) => invoiceDetailTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
        invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
        setState(() {});
      } else if (invoice.saleOrderList[0].orderTaxList == null || invoice.saleOrderList[0].orderTaxList.length == 0) {
        invoice.netAmount = invoice.grossAmount - invoice.discount;
      }
      _selectedTaxGroup = (invoice.taxGroup == "GST") ? 0 : 1;
      if (invoice.invoiceDate != null) {
        _cInvoiceDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.invoiceDate);
        _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.deliveryDate);
        _invoiceDate2 = invoice.invoiceDate.toString();
        _deliveryDate2 = invoice.deliveryDate.toString();
      } else {
        _cInvoiceDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _invoiceDate2 = DateTime.now().toString().substring(0, 10);
        _deliveryDate2 = DateTime.now().toString().substring(0, 10);
      }

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
      _isTaxApply = (invoice.invoiceTaxList != null && invoice.invoiceTaxList.length != 0) ? true : false;
      _invoiceDetailTaxIdList = invoice.invoiceDetailTaxList.map((e) => e.id).toList();
      _invoiceDetailTaxLen = invoice.invoiceDetailTaxList.length;
      _cAccountId.text = '${invoice.account.firstName} ${invoice.account.lastName}';
      //     '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + invoice.account.accountCode.toString().length))}${invoice.account.accountCode} - ${invoice.account.firstName} ${invoice.account.lastName}';
      _cDiscount.text = invoice.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _cNetAmount.text = invoice.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _isComplete = invoice.isComplete;
      _generateByProductCategory = false;
      _showRemarkInPrint = invoice.showRemarkInPrint;
      _cVoucherNumber.text = invoice.voucherNumber;
      _deliveryDate2 = DateTime.now().toString();
      _cDeliveryTime.text = '9:00 AM';
      _calculate();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - saleInvoiceAddScreen.dart - _generateInvoiceFromOrder(): ' + e.toString());
    }
  }

  Future _getDetailForUpdateInvoice() async {
    try {
      invoice.invoiceDetailList = await dbHelper.saleInvoiceDetailGetList(
        invoiceIdList: [invoice.id],
      );
      _selectedTaxGroup = (invoice.taxGroup == "GST") ? 0 : 1;
      _generatedInvoiceNo =
          '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + invoice.invoiceNumber.toString().length))}${invoice.invoiceNumber}';
      _cInvoiceNumber.text = _generatedInvoiceNo;
      _cInvoiceDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.invoiceDate);
      _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.deliveryDate);
      _invoiceDate2 = invoice.invoiceDate.toString();
      _deliveryDate2 = invoice.deliveryDate.toString();
      _timeOfDay = TimeOfDay(hour: invoice.deliveryDate.hour, minute: invoice.deliveryDate.minute);
      String time = br.formatTimeOfDay(_timeOfDay);
      _showRemarkInPrint = invoice.showRemarkInPrint;
      _cDeliveryTime.text = time;
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
      List<PaymentSaleInvoice> _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(invoiceId: invoice.id, isCancel: false);
      List<PaymentDetail> _paymentDetailList = (_paymentInvoiceList.length != 0) ? await dbHelper.paymentDetailGetList(paymentIdList: _paymentInvoiceList.map((paymentDetail) => paymentDetail.paymentId).toList()) : null;
      invoice.payment.paymentDetailList = (_paymentDetailList != null)
          ? (_paymentDetailList.length != 0)
              ? _paymentDetailList
              : []
          : [];

      invoice.invoiceTaxList = await dbHelper.saleInvoiceTaxGetList(invoiceId: invoice.id);
      _isTaxApply = (invoice.invoiceTaxList.length != 0) ? true : false;
      invoice.invoiceDetailTaxList = await dbHelper.saleInvoiceDetailTaxGetList(invoiceDetailIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.id).toList());
      _invoiceDetailTaxIdList = invoice.invoiceDetailTaxList.map((e) => e.id).toList();
      _invoiceDetailTaxLen = invoice.invoiceDetailTaxList.length;
      invoice.invoiceDetailTaxList.map((idt) => print('${idt.invoiceDetailId} ${idt.taxId}:${idt.percentage}')).toList();
      _cAccountId.text = '${invoice.account.firstName} ${invoice.account.lastName}';
      //     '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + invoice.account.accountCode.toString().length))}${invoice.account.accountCode} - ${invoice.account.firstName} ${invoice.account.lastName}';
      _cDiscount.text = invoice.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _cNetAmount.text = invoice.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _isComplete = invoice.isComplete;
      _generateByProductCategory = invoice.generateByProductCategory;
      _showRemarkInPrint = invoice.showRemarkInPrint;
      _cVoucherNumber.text = invoice.voucherNumber;
      _calculate();

      // invoice.saleQuoteInvoiceList = await dbHelper.saleQuoteInvoiceGetList(saleInvoiceId: invoice.id);
      if (invoice.salesQuoteId != null) {
        invoice.saleQuoteList = await dbHelper.saleQuoteGetList(orderIdList: [invoice.salesQuoteId]);
        invoice.saleQuoteList[0].quoteDetailList = await dbHelper.saleQuoteDetailGetList(orderIdList: [invoice.saleQuoteList[0].id]);
      }

      if (invoice.salesOrderId != null) {
        invoice.saleOrderList = await dbHelper.saleOrderGetList(orderIdList: [invoice.salesOrderId]);
        invoice.saleOrderList[0].orderDetailList = await dbHelper.saleOrderDetailGetList(orderIdList: [invoice.saleOrderList[0].id]);
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - saleInvoiceAddScreen.dart - _getDetailForUpdateInvoice(): ' + e.toString());
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

  Future showAlertd() async {
    try {
      AlertDialog dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        content: Text(global.appLocaleValues['txt_inv_changes_discard']),
        actions: <Widget>[
          TextButton(
            child: Text(global.appLocaleValues['btn_cancel'], style: Theme.of(context).primaryTextTheme.headline3),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_yes'], style: Theme.of(context).primaryTextTheme.headline2),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();

              (screenId == 1)
                  ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => SalesQuoteScreen(
                            a: widget.analytics,
                            o: widget.observer,
                          )))
                  : (screenId == 2)
                      ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => SaleOrderScreen(
                                a: widget.analytics,
                                o: widget.observer,
                              )))
                      : Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => SaleInvoiceScreen(
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

  Future showAlertOfImportOrder() async {
    try {
      AlertDialog dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        content: Text(global.appLocaleValues['txt_import_order']),
        actions: <Widget>[
          TextButton(
            child: Text(global.appLocaleValues['btn_no'], style: Theme.of(context).primaryTextTheme.headline3),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_yes'], style: Theme.of(context).primaryTextTheme.headline2),
            onPressed: () async {
              Navigator.of(context).pop();
              await _importOrders();
            },
          ),
        ],
      );
      await showDialog(builder: (context) => dialog, context: context);
    } catch (e) {
      print('Exception - invoiceaddscreen.dart - showAlertOfImportOrder(): ' + e.toString());
    }
  }

  Future _onSubmit() async {
    try {
      List<SaleInvoiceDetail> _tempSaleInvoiceDetailList = [];
      if (invoice.saleQuoteList.length > 0 || invoice.saleOrderList.length > 0) {
        _tempSaleInvoiceDetailList = await dbHelper.saleInvoiceDetailGetList(invoiceIdList: [invoice.id]);
      }
      if (_formKey.currentState.validate()) {
        if (invoice.netAmount > 0) {
          showLoader(global.appLocaleValues['txt_wait']);
          setState(() {});
          invoice.accountId = (_account != null) ? _account.id : invoice.accountId;
          invoice.invoiceDate = DateTime.parse(_invoiceDate2);
          invoice.deliveryDate = DateTime.parse(_deliveryDate2);
          invoice.deliveryDate = DateTime(invoice.deliveryDate.year, invoice.deliveryDate.month, invoice.deliveryDate.day, _timeOfDay.hour, _timeOfDay.minute);
          invoice.isComplete = _isComplete;
          if (invoice.finalTax > 0) {
            invoice.taxGroup = (_selectedTaxGroup == 0) ? "GST" : "IGST";
          }
          invoice.generateByProductCategory = _generateByProductCategory;
          invoice.showRemarkInPrint = _showRemarkInPrint;
          invoice.voucherNumber = _cVoucherNumber.text.trim();
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
            List<SaleQuote> _saleQuoteList = invoice.saleQuoteList.toList();
            List<SaleOrder> _saleOrderList = invoice.saleOrderList.toList();
            // invoice.salesQuoteId = invoice.saleOrderList[0].salesQuoteId;
            invoice = await dbHelper.saleInvoiceInsert(invoice, _isTaxApply);
            if (invoice.id != null && _saleQuoteList.length > 0) {
              invoice.invoiceDetailList.forEach((invoiceDetail) {
                _saleQuoteList[0].quoteDetailList.forEach((orderDetail) async {
                  if (invoiceDetail.productId == orderDetail.productId) {
                    orderDetail.invoicedQuantity += invoiceDetail.quantity;
                  }
                  await dbHelper.saleQuoteDetailUpdate(orderDetail);
                });
              });

              await _updateSaleQuote(_saleQuoteList);
            }
            if (invoice.id != null && _saleOrderList.length > 0) {
              invoice.invoiceDetailList.forEach((invoiceDetail) {
                _saleOrderList[0].orderDetailList.forEach((orderDetail) async {
                  if (invoiceDetail.productId == orderDetail.productId) {
                    orderDetail.invoicedQuantity += invoiceDetail.quantity;
                  }
                  await dbHelper.saleOrderDetailUpdate(orderDetail);
                });
              });

              await _updateSaleOrder(_saleOrderList);
            }
          } else {
            await dbHelper.saleInvoiceDetailTaxDelete(invoiceDetailTaxIdList: _invoiceDetailTaxIdList);
            await dbHelper.saleInvoiceTaxDelete(invoice.id);
            List<SaleQuote> _saleQuoteList = invoice.saleQuoteList.toList();
            List<SaleOrder> _saleOrderList = invoice.saleOrderList.toList();
            invoice = await dbHelper.saleInvoiceUpdate(invoice: invoice, updateFrom: 1, isTaxApplied: _isTaxApply, isAccountChanged: _accountChanged);
            if (invoice.saleQuoteList.length > 0) // if any sale invoice attached with this invoice
            {
              for (int i = 0; i < _tempSaleInvoiceDetailList.length; i++) {
                bool _exist = _saleQuoteList[0].quoteDetailList.map((e) => e.productId).contains(_tempSaleInvoiceDetailList[i].productId);
                if (_exist) // if product exist in saleOrderDetail
                {
                  bool _isExist = invoice.invoiceDetailList.map((e) => e.productId).contains(_tempSaleInvoiceDetailList[i].productId);
                  if (_isExist) {
                    // if product is not deleted during update
                    double _latestQty = invoice.invoiceDetailList.firstWhere((element) => element.productId == _tempSaleInvoiceDetailList[i].productId).quantity;
                    if (_latestQty != _tempSaleInvoiceDetailList[i].quantity) // if qty is not same
                    {
                      _saleQuoteList[0].quoteDetailList.forEach((element) async {
                        if (element.productId == _tempSaleInvoiceDetailList[i].productId) {
                          if (_latestQty < _tempSaleInvoiceDetailList[i].quantity) // if qty is lesser than previous
                          {
                            double _a = _tempSaleInvoiceDetailList[i].quantity - _latestQty;
                            element.invoicedQuantity = element.invoicedQuantity - _a;
                          } else {
                            double _a = _latestQty - _tempSaleInvoiceDetailList[i].quantity;
                            element.invoicedQuantity = element.invoicedQuantity + _a;
                          }
                          await dbHelper.saleQuoteDetailUpdate(element);
                        }
                      });
                    }
                  } else {
                    // if product is deleted during update
                    _saleQuoteList[0].quoteDetailList.forEach((element) async {
                      if (element.productId == _tempSaleInvoiceDetailList[i].productId) {
                        element.invoicedQuantity = element.invoicedQuantity - _tempSaleInvoiceDetailList[i].quantity;
                        await dbHelper.saleQuoteDetailUpdate(element);
                      }
                    });
                  }
                }
              }
              await _updateSaleQuote(_saleQuoteList);
            }

            if (invoice.saleOrderList.length > 0) // if any sale invoice attached with this invoice
            {
              for (int i = 0; i < _tempSaleInvoiceDetailList.length; i++) {
                bool _exist = _saleOrderList[0].orderDetailList.map((e) => e.productId).contains(_tempSaleInvoiceDetailList[i].productId);
                if (_exist) // if product exist in saleOrderDetail
                {
                  bool _isExist = invoice.invoiceDetailList.map((e) => e.productId).contains(_tempSaleInvoiceDetailList[i].productId);
                  if (_isExist) {
                    // if product is not deleted during update
                    double _latestQty = invoice.invoiceDetailList.firstWhere((element) => element.productId == _tempSaleInvoiceDetailList[i].productId).quantity;
                    if (_latestQty != _tempSaleInvoiceDetailList[i].quantity) // if qty is not same
                    {
                      _saleOrderList[0].orderDetailList.forEach((element) async {
                        if (element.productId == _tempSaleInvoiceDetailList[i].productId) {
                          if (_latestQty < _tempSaleInvoiceDetailList[i].quantity) // if qty is lesser than previous
                          {
                            double _a = _tempSaleInvoiceDetailList[i].quantity - _latestQty;
                            element.invoicedQuantity = element.invoicedQuantity - _a;
                          } else {
                            double _a = _latestQty - _tempSaleInvoiceDetailList[i].quantity;
                            element.invoicedQuantity = element.invoicedQuantity + _a;
                          }
                          await dbHelper.saleOrderDetailUpdate(element);
                        }
                      });
                    }
                  } else {
                    // if product is deleted during update
                    _saleOrderList[0].orderDetailList.forEach((element) async {
                      if (element.productId == _tempSaleInvoiceDetailList[i].productId) {
                        element.invoicedQuantity = element.invoicedQuantity - _tempSaleInvoiceDetailList[i].quantity;
                        await dbHelper.saleOrderDetailUpdate(element);
                      }
                    });
                  }
                }
              }
              await _updateSaleOrder(_saleOrderList);
            }
          }
          hideLoader();
          setState(() {});
          (screenId == 1)
              ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => SalesQuoteScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      )))
              : (screenId == 2)
                  ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => SaleOrderScreen(
                            a: widget.analytics,
                            o: widget.observer,
                          )))
                  : Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => SaleInvoiceScreen(
                            a: widget.analytics,
                            o: widget.observer,
                          )));
          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //     builder: (BuildContext context) =>  SaleInvoiceScreen(
          //           a: widget.analytics,
          //           o: widget.observer,
          //         )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(global.appLocaleValues['txt_total_vld'])));
        }
      } else {
        _autovalidate = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - saleInvoiceAddScreen.dart - _onSubmit(): ' + e.toString());
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
      print('Exception - saleInvoiceAddScreen.dart - _selectDate(): ' + e.toString());
    }
  }

  Future _getTaxes() async {
    try {
      _taxList.clear();
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
        SaleInvoiceTax _orderTax = SaleInvoiceTax(null, null, _taxList[i].id, _taxList[i].percentage, 0.0);
        _orderTax.taxName = _taxList[i].taxName;
        invoice.invoiceTaxList.add(_orderTax);
      }
      setState(() {});
    } catch (e) {
      print('Exception - saleOrderAddScreen.dart - _getTaxes(): ' + e.toString());
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
            if (_isTaxApply) {
              invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
            }
          }
          invoice.netAmount = (_isTaxApply && invoice.invoiceTaxList.length > 0) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
        } else {
          // if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
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
                invoice.invoiceTaxList.forEach((invoiceTax) {
                  if (invoiceTax.taxId == productTax.taxMasterId) {
                    invoiceTax.totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                    SaleInvoiceDetailTax _invoiceDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                    invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                  }
                });
              }
            });
          });
          invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
          invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        }
        // else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
        //   invoice. netAmount = invoice.grossAmount - invoice.discount;
        // }
      } else {
        if (invoice.invoiceTaxList.length != 0 && (invoice.invoiceDetailTaxList.length == 0 || invoice.invoiceDetailList.length < 1)) {
          invoice.finalTax = 0.0;
          for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
            invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
            if (_isTaxApply) {
              invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
            }
          }
          invoice.netAmount = (_isTaxApply && invoice.invoiceTaxList.length > 0) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
          setState(() {});
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
                invoice.invoiceTaxList.forEach((invoiceTax) {
                  if (invoiceTax.taxId == productTax.taxMasterId) {
                    invoiceTax.totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                    SaleInvoiceDetailTax _invoiceDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                    invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                  }
                });
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
        _cNetAmount.text = invoice.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        invoice.discount = 0;
        invoice.netAmount = 0;
        _cDiscount.text = invoice.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        invoice.invoiceTaxList.map((e) => e.totalAmount = 0).toList();
      }
      FocusScope.of(context).requestFocus(_focusNode);
      _calculate();
      setState(() {});
    } catch (e) {
      print('Exception - saleInvoiceAddScreen.dart - _removeProduct(): ' + e.toString());
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
      print('Exception - saleInvoiceAddScreen.dart - _discountListener(): ' + e.toString());
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
      print('Exception - saleInvoiceAddScreen.dart - _netAmountListener(): ' + e.toString());
    }
  }

  Future _selectUnit(int index) async {
    try {
      int _count = 0;
      if (invoice.saleQuoteList.length > 0) {
        _count = invoice.saleQuoteList[0].quoteDetailList.where((element) => element.productId == invoice.invoiceDetailList[index].productId).toList().length;
      }
      if (invoice.saleOrderList.length > 0) {
        _count = invoice.saleOrderList[0].orderDetailList.where((element) => element.productId == invoice.invoiceDetailList[index].productId).toList().length;
      }
      if (_count == 0) {
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
                      invoice.invoiceTaxList.forEach((invoiceTax) {
                        if (invoiceTax.taxId == productTax.taxMasterId) {
                          invoiceTax.totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                          SaleInvoiceDetailTax _invoiceDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                          invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                        }
                      });
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
                      invoice.invoiceTaxList.forEach((invoiceTax) {
                        if (invoiceTax.taxId == productTax.taxMasterId) {
                          invoiceTax.totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                          SaleInvoiceDetailTax _invoiceDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.unitPrice * productTax.percentage) / 100);
                          invoice.invoiceDetailTaxList.add(_invoiceDetailTax);
                        }
                      });
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(global.appLocaleValues['lbl_unit_err_vld'])));
      }
      setState(() {});
    } catch (e) {
      print('Exception - saleInvoiceAddScreen.dart - _selectUnit(): ' + e.toString());
    }
  }

  Future _onTaxGroupChanged(value) async {
    try {
      _isDataLoaded = false;
      setState(() {});
      _selectedTaxGroup = value;
      invoice.finalTax = 0;
      invoice.invoiceTaxList.clear();
      await _getTaxes();
      if (invoice.id == null) {
        invoice.invoiceDetailTaxList.clear();
        if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
          for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
            invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
            if (_isTaxApply) {
              invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
            }
          }
          invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
        } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
          invoice.invoiceTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
          _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((orderDetail) => orderDetail.productId).toList());

          invoice.invoiceDetailList.forEach((orderDetail) {
            _productTaxList.forEach((productTax) {
              if (orderDetail.productId == productTax.productId) {
                invoice.invoiceTaxList.forEach((orderTax) {
                  if (orderTax.taxId == productTax.taxMasterId) {
                    orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                    SaleInvoiceDetailTax _orderDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.amount * productTax.percentage) / 100);
                    invoice.invoiceDetailTaxList.add(_orderDetailTax);
                  }
                });
              }
            });
          });
          invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((orderDetailTax) => orderDetailTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
          invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        }
      } else {
        if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length == 0) {
          for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
            invoice.invoiceTaxList[i].totalAmount = ((invoice.grossAmount - invoice.discount) * invoice.invoiceTaxList[i].percentage) / 100;
            if (_isTaxApply) {
              invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
            }
          }
          invoice.netAmount = (_isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
        } else if (invoice.invoiceTaxList.length != 0 && invoice.invoiceDetailTaxList.length != 0) {
          invoice.invoiceDetailTaxList.clear();
          invoice.invoiceTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
          _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((orderDetail) => orderDetail.productId).toList());

          invoice.invoiceDetailList.forEach((orderDetail) {
            _productTaxList.forEach((productTax) {
              if (orderDetail.productId == productTax.productId) {
                invoice.invoiceTaxList.forEach((orderTax) {
                  if (orderTax.taxId == productTax.taxMasterId) {
                    orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                    SaleInvoiceDetailTax _orderDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.amount * productTax.percentage) / 100);
                    invoice.invoiceDetailTaxList.add(_orderDetailTax);
                  }
                });
              }
            });
          });
          invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
          invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        }
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - saleOrderAddScreen.dart - _onTaxGroupChanged(): ' + e.toString());
    }
  }

  Future _importOrders() async {
    try {
      setState(() {
        _isDataLoaded = false;
      });
      await Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => SaleQuoteSelectDialog(
                    a: widget.analytics,
                    o: widget.observer,
                    account: _account,
                  )))
          .then((_saleInvoice) async {
        if (_saleInvoice != null) {
          invoice = _saleInvoice;
          await _generateInvoice();
          setState(() {
            _isDataLoaded = true;
          });
        } else {
          setState(() {
            _isDataLoaded = true;
          });
        }
      });
      setState(() {});
    } catch (e) {
      print('Exception - saleInvoiceAddScreen.dart - _importOrders(): ' + e.toString());
    }
  }

  Future _updateSaleQuote(List<SaleQuote> _saleQuoteList) async {
    try {
      for (int i = 0; i < _saleQuoteList.length; i++) {
        int _isInvoicedOrder = 0;
        _saleQuoteList[i].quoteDetailList.forEach((orderDetail) {
          if (orderDetail.quantity != orderDetail.invoicedQuantity) {
            _isInvoicedOrder++;
          }
        });
        _saleQuoteList[i].status = (_isInvoicedOrder == 0) ? 'INVOICED' : 'OPEN';
        await dbHelper.saleQuoteUpdate(quote: _saleQuoteList[i], updateFrom: 2);
      }
    } catch (e) {
      print('Exception - saleInvoiceAddScreen.dart - _updateSaleQuote(): ' + e.toString());
    }
  }

  Future _updateSaleOrder(List<SaleOrder> _saleOrderList) async {
    try {
      for (int i = 0; i < _saleOrderList.length; i++) {
        int _isInvoicedOrder = 0;
        _saleOrderList[i].orderDetailList.forEach((orderDetail) {
          if (orderDetail.quantity != orderDetail.invoicedQuantity) {
            _isInvoicedOrder++;
          }
        });
        _saleOrderList[i].status = (_isInvoicedOrder == 0) ? 'INVOICED' : 'OPEN';
        await dbHelper.saleOrderUpdate(order: _saleOrderList[i], updateFrom: 2);
      }
    } catch (e) {
      print('Exception - saleInvoiceAddScreen.dart - _updateSaleOrder(): ' + e.toString());
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
              if (_isTaxApply) {
                invoice.finalTax += invoice.invoiceTaxList[i].totalAmount;
              }
            }
            invoice.netAmount = (_isTaxApply && invoice.invoiceTaxList.length > 0) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
          } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
            invoice.finalTax = 0.0;
            invoice.invoiceTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
            _productTaxList = await dbHelper.productTaxGetList(productIdList: invoice.invoiceDetailList.map((e) => e.productId).toList());
            invoice.invoiceDetailTaxList.clear();
            invoice.invoiceDetailList.forEach((orderDetail) {
              _productTaxList.forEach((productTax) {
                if (orderDetail.productId == productTax.productId) {
                  invoice.invoiceTaxList.forEach((orderTax) {
                    if (orderTax.taxId == productTax.taxMasterId) {
                      orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                      SaleInvoiceDetailTax _orderDetailTax = SaleInvoiceDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                      invoice.invoiceDetailTaxList.add(_orderDetailTax);
                    }
                  });
                }
              });
            });
            invoice.netAmount = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.grossAmount - invoice.discount + invoice.invoiceTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : invoice.grossAmount - invoice.discount;
            invoice.finalTax = (invoice.invoiceTaxList.length > 0 && _isTaxApply) ? invoice.invoiceTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

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
      print('Exception - saleOrderAddScreen.dart - _netAmountListener(): ' + e.toString());
    }
  }

  Future<Null> _chooseDeliveryTime() async {
    try {
      TimeOfDay picked;
      picked = await showTimePicker(context: context, initialTime: _timeOfDay);
      if (picked != null && picked != _timeOfDay) {
        _timeOfDay = picked;
        print('time: ${_timeOfDay.hour}');
        String time = br.formatTimeOfDay(_timeOfDay);
        _cDeliveryTime.text = time;
      }
      setState(() {});
    } catch (e) {
      print('Exception - saleOrderAddScreen.dart - _chooseDeliveryTime(): ' + e.toString());
    }
  }
}
