// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/dialogs/selectUnitDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/dialogs/productSelectDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/decimalTextInputFormatter.dart';
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/productTaxModel.dart';
import 'package:accounting_app/models/saleQuoteDetailModel.dart';
import 'package:accounting_app/models/saleQuoteDetailTaxModel.dart';
import 'package:accounting_app/models/saleQuoteTaxModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/models/unitCombinationModel.dart';
import 'package:accounting_app/models/unitModel.dart';
import 'package:accounting_app/screens/saleOrderScreen.dart';
import 'package:accounting_app/screens/salesQuoteScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';

class SaleQuoteAddSreen extends BaseRoute {
  final SaleQuote quote;
  final bool isMakeNewVersion;
  final int returnScreenId;
  SaleQuoteAddSreen({@required a, @required o, @required this.quote, this.isMakeNewVersion, this.returnScreenId}) : super(a: a, o: o, r: 'SaleQuoteAddSreen');
  @override
  _SaleQuoteAddSreenState createState() => _SaleQuoteAddSreenState(this.quote, this.isMakeNewVersion, this.returnScreenId);
}

class _SaleQuoteAddSreenState extends BaseRouteState {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  int returnScreenId;
  TextEditingController _cAccountId = TextEditingController();
  TextEditingController _cOrderDate = TextEditingController();
  TextEditingController _cVersionNumber = TextEditingController();
  TextEditingController _cDeliveryDate = TextEditingController();
  TextEditingController _cDeliveryTime = TextEditingController();
  TextEditingController _cRemark = TextEditingController();
  TextEditingController _cDiscount = TextEditingController();
  TextEditingController _cOrderNumber = TextEditingController();
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
  var _fOrderDate = FocusNode();
  var _fDeliveryDate = FocusNode();
  // var _fVoucherNumber =  FocusNode();
  var _focusNode = FocusNode();
  String _generatedOrderNo;
  String _generatedVersionNo;
//  double _remainAmount;
  bool _isComplete = false;
  String _orderDate2;
  String _deliveryDate2;
  SaleQuote quote;
  Account _account;
  bool _isDataLoaded = false;
  bool _isTaxApply = false;
  int _orderDetailTaxLen;
  int _selectedTaxGroup = 0;
  bool _accountChanged = false;
  bool _autovalidate = false;
  List<UnitCombination> _unitCombinationList = [];
  List<Unit> _unitList = [];
  List<TaxMaster> _allTaxList = [];
  SaleQuote _tempSaleOrder = SaleQuote();
  TimeOfDay _timeOfDay = TimeOfDay(hour: 9, minute: 0);
  final bool isMakeNewVersion;
  List<int> _quoteDetailTaxIdList = []; // use for delete detail tax in edit mode
  bool _showRemarkInPrint = false;

  _SaleQuoteAddSreenState(this.quote, this.isMakeNewVersion, this.returnScreenId) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: (quote.id != null) ? Text('${global.appLocaleValues['update_quote']}', style: Theme.of(context).appBarTheme.titleTextStyle) : Text('${global.appLocaleValues['add_quote']}', style: Theme.of(context).appBarTheme.titleTextStyle),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  await _onSubmit();
                },
                child: Text(
                  global.appLocaleValues['btn_save'],
                  style: Theme.of(context).primaryTextTheme.headline2,
                ))
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            // await showAlertd();
            return null;
          },
          child: SafeArea(
            child: (_isDataLoaded)
                ? Scrollbar(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8),
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
                                                child: Text('${global.appLocaleValues['tle_quote_no']}', style: Theme.of(context).primaryTextTheme.headline3),
                                              ),
                                              TextFormField(
                                                controller: _cOrderNumber,
                                                readOnly: true,
                                                style: Theme.of(context).primaryTextTheme.headline1,
                                                decoration: InputDecoration(
                                                  hintText: global.appLocaleValues['tle_sale_order_no'],
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
                                                child: Text('${global.appLocaleValues['ver_no']}', style: Theme.of(context).primaryTextTheme.headline3),
                                              ),
                                              TextFormField(
                                                controller: _cVersionNumber,
                                                readOnly: true,
                                                style: Theme.of(context).primaryTextTheme.headline1,
                                                decoration: InputDecoration(
                                                  hintText: '${global.appLocaleValues['ver_no']}',
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
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8, bottom: 5),
                                      child: Text('${global.appLocaleValues['quote_dt']}', style: Theme.of(context).primaryTextTheme.headline3),
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        border: nativeTheme().inputDecorationTheme.border,
                                        hintText: '${global.appLocaleValues['quote_dt']}',
                                        suffixIcon: Icon(
                                          Icons.star,
                                          size: 9,
                                          color: Colors.red,
                                        ),
                                      ),
                                      focusNode: _fOrderDate,
                                      controller: _cOrderDate,
                                      keyboardType: null,
                                      validator: (v) {
                                        if (v.isEmpty) {
                                          return global.appLocaleValues['lbl_date_err_req'];
                                        }
                                        return null;
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8, bottom: 5),
                                      child: Text(global.appLocaleValues['tab_ac'], style: Theme.of(context).primaryTextTheme.headline3),
                                    ),
                                    TextFormField(
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
                                            style: Theme.of(context).primaryTextTheme.headline2),
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
                                              itemCount: quote.quoteDetailList.length,
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
                                                                    '${quote.quoteDetailList[index].product.name}',
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: Theme.of(context).primaryTextTheme.subtitle1,
                                                                  ),
                                                                  Text(
                                                                      (br.getSystemFlagValue(global.systemFlagNameList.useProductSupplierCode) == 'true' && quote.quoteDetailList[index].product.supplierProductCode != '')
                                                                          ? ' ${quote.quoteDetailList[index].product.supplierProductCode}'
                                                                          : ' ${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + quote.quoteDetailList[index].product.productCode.toString().length))}${quote.quoteDetailList[index].product.productCode}',
                                                                      style: Theme.of(context).primaryTextTheme.subtitle2),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        subtitle: Padding(
                                                            padding: EdgeInsets.only(top: 10),
                                                            child: Text(
                                                              '${global.appLocaleValues['lbl_total']}:  ${global.currency.symbol} ${quote.quoteDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                                                                          quote.quoteDetailList[index].quantity = (value.length > 0) ? double.parse(value) : 0;
                                                                          quote.quoteDetailList[index].amount = (quote.quoteDetailList[index].quantity * double.parse(_cUnitPriceList[index].text));
                                                                          quote.grossAmount = quote.quoteDetailList.map((orderDetail) => orderDetail.amount).reduce((sum, amount) => sum + amount);

                                                                          if (quote.id == null) {
                                                                            if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
                                                                              quote.finalTax = 0.0;
                                                                              for (int i = 0; i < quote.quoteTaxList.length; i++) {
                                                                                quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
                                                                                if (_isTaxApply) {
                                                                                  quote.finalTax += quote.quoteTaxList[i].totalAmount;
                                                                                }
                                                                              }
                                                                              quote.netAmount = (_isTaxApply && quote.quoteTaxList.length > 0)
                                                                                  ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : quote.grossAmount - quote.discount;
                                                                            } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                                              quote.finalTax = 0.0;
                                                                              quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                                                                              quote.quoteDetailTaxList.clear();
                                                                              quote.quoteDetailList.forEach((orderDetail) {
                                                                                _productTaxList.forEach((productTax) {
                                                                                  if (orderDetail.productId == productTax.productId) {
                                                                                    quote.quoteTaxList.forEach((orderTax) {
                                                                                      if (orderTax.taxId == productTax.taxMasterId) {
                                                                                        orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                                                                                        SaleQuoteDetailTax _orderDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                                                                                        quote.quoteDetailTaxList.add(_orderDetailTax);
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                });
                                                                              });
                                                                              quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply)
                                                                                  ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : quote.grossAmount - quote.discount;
                                                                              quote.finalTax = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

                                                                              setState(() {});
                                                                            } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                                                              quote.netAmount = quote.grossAmount - quote.discount;
                                                                            }
                                                                          } else {
                                                                            if (quote.quoteTaxList.length != 0 && _orderDetailTaxLen == 0) {
                                                                              quote.finalTax = 0.0;
                                                                              for (int i = 0; i < quote.quoteTaxList.length; i++) {
                                                                                quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
                                                                                if (_isTaxApply) {
                                                                                  quote.finalTax += quote.quoteTaxList[i].totalAmount;
                                                                                }
                                                                              }
                                                                              quote.netAmount = (_isTaxApply && quote.quoteTaxList.length > 0)
                                                                                  ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : quote.grossAmount - quote.discount;
                                                                            } else if (quote.quoteTaxList.length != 0 && _orderDetailTaxLen != 0) {
                                                                              quote.finalTax = 0.0;
                                                                              quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                                                                              quote.quoteDetailTaxList.clear();
                                                                              if (_productTaxList.length == 0) {
                                                                                _productTaxList = await dbHelper.productTaxGetList(productIdList: quote.quoteDetailList.map((orderDetail) => orderDetail.productId).toList());
                                                                              }
                                                                              quote.quoteDetailList.forEach((orderDetail) {
                                                                                _productTaxList.forEach((productTax) {
                                                                                  if (orderDetail.productId == productTax.productId) {
                                                                                    quote.quoteTaxList.forEach((orderTax) {
                                                                                      if (orderTax.taxId == productTax.taxMasterId) {
                                                                                        orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                                                                                        SaleQuoteDetailTax _orderDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                                                                                        quote.quoteDetailTaxList.add(_orderDetailTax);
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                });
                                                                              });
                                                                              quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply)
                                                                                  ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : quote.grossAmount - quote.discount;
                                                                              quote.finalTax = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

                                                                              setState(() {});
                                                                            } else if (_isTaxApply == false) {
                                                                              quote.netAmount = quote.grossAmount - quote.discount;
                                                                            }
                                                                          }

                                                                          _calculate();
                                                                          setState(() {});
                                                                        } catch (e) {
                                                                          print('Exception - saleQuoteAddScreen.dart - Qty_onChanged: ' + e.toString());
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
                                                                          quote.quoteDetailList[index].unitPrice = (value.length > 0) ? double.parse(value) : 0;
                                                                          if (quote.quoteDetailList[index].product.productPriceList[0].unitId == quote.quoteDetailList[index].unitId) {
                                                                            // if product unit and sold unit is same
                                                                            quote.quoteDetailList[index].amount = quote.quoteDetailList[index].unitPrice * quote.quoteDetailList[index].quantity;
                                                                          } else {
                                                                            UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == quote.quoteDetailList[index].product.unitCombinationId);
                                                                            if (quote.quoteDetailList[index].unitId == _unitCombination.primaryUnitId) // if parent unit is selected
                                                                            {
                                                                              if (_unitCombination.primaryUnitId == quote.quoteDetailList[index].product.productPriceList[0].unitId) {
                                                                                quote.quoteDetailList[index].amount = quote.quoteDetailList[index].unitPrice * quote.quoteDetailList[index].quantity;
                                                                              } else {
                                                                                quote.quoteDetailList[index].amount = (quote.quoteDetailList[index].unitPrice * _unitCombination.measurement) * quote.quoteDetailList[index].quantity;
                                                                              }
                                                                              quote.quoteDetailList[index].amount = quote.quoteDetailList[index].quantity * quote.quoteDetailList[index].unitPrice;
                                                                            } else // if child unit is selected
                                                                            {
                                                                              if (_unitCombination.secondaryUnitId == quote.quoteDetailList[index].product.productPriceList[0].unitId) {
                                                                                quote.quoteDetailList[index].amount = quote.quoteDetailList[index].unitPrice * quote.quoteDetailList[index].quantity;
                                                                              } else {
                                                                                quote.quoteDetailList[index].amount = quote.quoteDetailList[index].unitPrice;
                                                                              }
                                                                            }
                                                                          }

                                                                          quote.grossAmount = quote.quoteDetailList.map((orderDetail) => orderDetail.amount).reduce((sum, amount) => sum + amount);
                                                                          if (quote.id == null) {
                                                                            if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
                                                                              quote.finalTax = 0.0;
                                                                              for (int i = 0; i < quote.quoteTaxList.length; i++) {
                                                                                quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
                                                                                if (_isTaxApply) {
                                                                                  quote.finalTax += quote.quoteTaxList[i].totalAmount;
                                                                                }
                                                                              }
                                                                              quote.netAmount = (_isTaxApply && quote.quoteTaxList.length > 0)
                                                                                  ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : quote.grossAmount - quote.discount;
                                                                            } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                                              quote.finalTax = 0.0;
                                                                              quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                                                                              quote.quoteDetailTaxList.clear();
                                                                              quote.quoteDetailList.forEach((orderDetail) {
                                                                                _productTaxList.forEach((productTax) {
                                                                                  if (orderDetail.productId == productTax.productId) {
                                                                                    quote.quoteTaxList.forEach((orderTax) {
                                                                                      if (orderTax.taxId == productTax.taxMasterId) {
                                                                                        orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                                                                                        SaleQuoteDetailTax _orderDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                                                                                        quote.quoteDetailTaxList.add(_orderDetailTax);
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                });
                                                                              });
                                                                              quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply)
                                                                                  ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : quote.grossAmount - quote.discount;
                                                                              quote.finalTax = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

                                                                              setState(() {});
                                                                            } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                                                              quote.netAmount = quote.grossAmount - quote.discount;
                                                                            }
                                                                          } else {
                                                                            if (quote.quoteTaxList.length != 0 && _orderDetailTaxLen == 0) {
                                                                              quote.finalTax = 0.0;
                                                                              for (int i = 0; i < quote.quoteTaxList.length; i++) {
                                                                                quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
                                                                                if (_isTaxApply) {
                                                                                  quote.finalTax += quote.quoteTaxList[i].totalAmount;
                                                                                }
                                                                              }
                                                                              quote.netAmount = (_isTaxApply && quote.quoteTaxList.length > 0)
                                                                                  ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : quote.grossAmount - quote.discount;
                                                                            } else if (quote.quoteTaxList.length != 0 && _orderDetailTaxLen != 0) {
                                                                              quote.finalTax = 0.0;
                                                                              quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                                                                              quote.quoteDetailTaxList.clear();
                                                                              if (_productTaxList.length == 0) {
                                                                                _productTaxList = await dbHelper.productTaxGetList(productIdList: quote.quoteDetailList.map((orderDetail) => orderDetail.productId).toList());
                                                                              }
                                                                              quote.quoteDetailList.forEach((orderDetail) {
                                                                                _productTaxList.forEach((productTax) {
                                                                                  if (orderDetail.productId == productTax.productId) {
                                                                                    quote.quoteTaxList.forEach((orderTax) {
                                                                                      if (orderTax.taxId == productTax.taxMasterId) {
                                                                                        orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                                                                                        SaleQuoteDetailTax _orderDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                                                                                        quote.quoteDetailTaxList.add(_orderDetailTax);
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                });
                                                                              });
                                                                              quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply)
                                                                                  ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : quote.grossAmount - quote.discount;
                                                                              quote.finalTax = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
                                                                              setState(() {});
                                                                            } else if (_isTaxApply == false) {
                                                                              quote.netAmount = quote.grossAmount - quote.discount;
                                                                            }
                                                                          }

                                                                          _calculate();
                                                                          setState(() {});
                                                                        } catch (e) {
                                                                          print('Exception - saleQuoteAddScreen.dart - UP_onChanged: ' + e.toString());
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
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                        title: Text('${global.appLocaleValues['lbl_sub_total']}', style: Theme.of(context).primaryTextTheme.headline6),
                                        trailing: Text('${global.currency.symbol} ${quote.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: Theme.of(context).primaryTextTheme.headline3)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8, right: 8),
                                      child: Divider(),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8, right: 8),
                                      child: ListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          title: Text('${global.appLocaleValues['lbl_discount']}', textAlign: TextAlign.start, style: Theme.of(context).primaryTextTheme.headline6),
                                          trailing: Container(
                                            width: MediaQuery.of(context).size.width / 2,
                                            child: TextFormField(
                                              inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                                              maxLength: 5,
                                              onChanged: (value) {
                                                quote.discount = (value.length > 0) ? double.parse(value) : 0;
                                                if (quote.id == null) {
                                                  if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false' || quote.quoteDetailList.length < 1)) {
                                                    quote.finalTax = 0.0;
                                                    for (int i = 0; i < quote.quoteTaxList.length; i++) {
                                                      quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
                                                      if (_isTaxApply) {
                                                        quote.finalTax += quote.quoteTaxList[i].totalAmount;
                                                      }
                                                    }
                                                    quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
                                                  } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                    quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
                                                  } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                                    quote.netAmount = quote.grossAmount - quote.discount;
                                                  }
                                                } else {
                                                  if (quote.quoteDetailTaxList == null && quote.quoteTaxList.length != 0 && quote.quoteDetailTaxList.length == 0) {
                                                    quote.finalTax = 0.0;
                                                    for (int i = 0; i < quote.quoteTaxList.length; i++) {
                                                      quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
                                                      if (_isTaxApply) {
                                                        quote.finalTax += quote.quoteTaxList[i].totalAmount;
                                                      }
                                                    }
                                                    quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
                                                  } else if (quote.quoteTaxList.length != 0 && quote.quoteDetailTaxList.length != 0) {
                                                    quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
                                                  } else if (_isTaxApply == false) {
                                                    quote.netAmount = quote.grossAmount - quote.discount;
                                                  }
                                                }
                                                _calculate();
                                                setState(() {});
                                              },
                                              textInputAction: TextInputAction.next,
                                              controller: _cDiscount,
                                              textAlign: TextAlign.end,
                                              style: Theme.of(context).primaryTextTheme.headline3,
                                              //  readOnly: (quote.id != null && DateTime.now().difference(quote.createdAt).inDays != 0) ? true : false,
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
                                    ),
                                    (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' || quote.quoteTaxList.length > 0)
                                        ? Padding(
                                            padding: const EdgeInsets.only(left: 10, right: 10),
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
                                                itemCount: quote.quoteTaxList.length,
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return SizedBox(
                                                    height: 40,
                                                    child: ListTile(
                                                        title: (quote.id == null)
                                                            ? (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false')
                                                                ? Text(
                                                                    '${quote.quoteTaxList[index].taxName} (${quote.quoteTaxList[index].percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%)',
                                                                    style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                  )
                                                                : Text(
                                                                    '${quote.quoteTaxList[index].taxName}',
                                                                    style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                  )
                                                            : (_isTaxApply == true && quote.quoteTaxList.length == 0)
                                                                ? Text(
                                                                    '${quote.quoteTaxList[index].taxName} (${quote.quoteTaxList[index].percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%)',
                                                                    style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                  )
                                                                : Text(
                                                                    '${quote.quoteTaxList[index].taxName}',
                                                                    style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                  ),
                                                        trailing: Text(
                                                          '${global.currency.symbol} ${quote.quoteTaxList[index].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                          style: TextStyle(fontSize: 20),
                                                        )),
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
                                          trailing: Text('${global.currency.symbol} ${quote.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: Theme.of(context).primaryTextTheme.headline5)),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 5, left: 8),
                                  child: Text("${global.appLocaleValues['lbl_note_remark']} (${global.appLocaleValues['lbl_optional']})", style: Theme.of(context).primaryTextTheme.headline3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                child: TextFormField(
                                  maxLines: 8,
                                  controller: _cRemark,
                                  decoration: InputDecoration(
                                    border: nativeTheme().inputDecorationTheme.border,
                                    hintText: '${global.appLocaleValues['lbl_note_remark']}',
                                    // labelText: '${global.appLocaleValues['lbl_note_remark']} (${global.appLocaleValues['lbl_optional']})',
                                    alignLabelWithHint: true,
                                  ),
                                ),
                              ),
                              Divider(),
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
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _fOrderDate.removeListener(_focusListener);
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
      _fOrderDate.addListener(_focusListener);
      _fDeliveryDate.addListener(_focusListener);
      _fDiscount.addListener(_discountListener);
      _fNetAmount.addListener(_netAmountListener);
      _unitList = await dbHelper.unitGetList();
      _unitCombinationList = await dbHelper.unitCombinationGetList();
      if (quote.id != null) {
        await _getDetailForUpdateQuote();
      } else {
        quote = SaleQuote();
        // quote.payment = Payment();
        if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true') {
          _isTaxApply = true;
          await _getTaxes();
        } else {
          _isTaxApply = false;
        }
        //   _cTax.text = '0.0';
        quote.finalTax = 0.0;
        quote.discount = 0.0;
        _cDiscount.text = quote.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        //    _cGrossAmount.text = '0.0';
        quote.netAmount = 0.0;
        //     _cNetAmount.text = '0.0';
        quote.grossAmount = 0.0;
        _cNetAmount.text = quote.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        _generateOrderNumber();
        quote.versionNumber = 1;
        _cVersionNumber.text = quote.versionNumber.toString();
        _cOrderDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _orderDate2 = DateTime.now().toString().substring(0, 10);
        _deliveryDate2 = DateTime.now().toString();
        _cDeliveryTime.text = '9:00 AM';
        _isDataLoaded = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - saleQuoteAddScreen.dart - _getData(): ' + e.toString());
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
      print('Exception - saleQuoteAddScreen.dart - _accountListener(): ' + e.toString());
    }
  }

  Future _addProducts() async {
    try {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductSelectDialog(
              a: widget.analytics,
              o: widget.observer,
              selectedProducts: quote.quoteDetailList.map((quote) => quote.product).toList(),
              returnScreenId: 0,
              onValueSelected: (product) async {
                // quote.quoteDetailList.clear();
                if (quote.id == null) {
                  quote.quoteDetailTaxList.clear();
                }
                // _cUnitPriceList.clear();
                // _cQtyList.clear();
                // _cUnitList.clear();
                // quote.grossAmount = 0;
                // quote.remainAmount = 0;
                product.forEach((item) {
                  SaleQuoteDetail orderDetail = SaleQuoteDetail(null, null, item.id, item.productPriceList[0].unitId, item.productPriceList[0].unitId, _unitList.firstWhere((element) => element.id == item.productPriceList[0].unitId).code, 1, 0, item.productPriceList[0].price,
                      item.productPriceList[0].price, item.name, item.productCode, item.productTypeName, item.productPriceList[0].price, false, null, null, item.description);
                  orderDetail.product = item;
                  quote.quoteDetailList.add(orderDetail);
                  _cUnitPriceList.add(TextEditingController(text: '${orderDetail.unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'));
                  _cQtyList.add(TextEditingController(text: '${orderDetail.quantity}'));
                  if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
                    _cUnitList.add(TextEditingController(text: '${_unitList.firstWhere((element) => element.id == orderDetail.product.productPriceList[0].unitId).code}'));
                  }
                  quote.grossAmount += item.productPriceList[0].price;
                });
                if (quote.id == null) {
                  if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
                    //    quote.finalTax = 0.0;
                    for (int i = 0; i < quote.quoteTaxList.length; i++) {
                      quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
                      if (_isTaxApply) {
                        quote.finalTax += quote.quoteTaxList[i].totalAmount;
                      }
                    }
                    quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
                  } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                    //  quote.finalTax = 0.0;
                    quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                    _productTaxList = await dbHelper.productTaxGetList(productIdList: quote.quoteDetailList.map((orderDetail) => orderDetail.productId).toList());

                    quote.quoteDetailList.forEach((orderDetail) {
                      _productTaxList.forEach((productTax) {
                        if (orderDetail.productId == productTax.productId) {
                          quote.quoteTaxList.forEach((orderTax) {
                            if (orderTax.taxId == productTax.taxMasterId) {
                              orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                              SaleQuoteDetailTax _orderDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.amount * productTax.percentage) / 100);
                              quote.quoteDetailTaxList.add(_orderDetailTax);
                            }
                          });
                        }
                      });
                    });
                    // print('orderDTax: ${quote.quoteDetailTaxList.map((e) => e.taxAmount).reduce((value, element) => value + element)}');
                    quote.netAmount = (quote.quoteTaxList.length > 0) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderDetailTax) => orderDetailTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
                    quote.finalTax = (quote.quoteTaxList.length > 0) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
                    setState(() {});
                  } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                    quote.netAmount = quote.grossAmount - quote.discount;
                  }
                } else {
                  if (quote.quoteTaxList.length != 0 && quote.quoteDetailTaxList.length == 0) {
                    //  quote.finalTax = 0.0;
                    for (int i = 0; i < quote.quoteTaxList.length; i++) {
                      quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
                      if (_isTaxApply) {
                        quote.finalTax += quote.quoteTaxList[i].totalAmount;
                      }
                    }
                    quote.netAmount = (_isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
                  } else if (quote.quoteTaxList.length != 0 && quote.quoteDetailTaxList.length != 0) {
                    //   quote.finalTax = 0.0;
                    quote.quoteDetailTaxList.clear();
                    quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                    _productTaxList = await dbHelper.productTaxGetList(productIdList: quote.quoteDetailList.map((orderDetail) => orderDetail.productId).toList());

                    quote.quoteDetailList.forEach((orderDetail) {
                      _productTaxList.forEach((productTax) {
                        if (orderDetail.productId == productTax.productId) {
                          quote.quoteTaxList.forEach((orderTax) {
                            if (orderTax.taxId == productTax.taxMasterId) {
                              orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                              SaleQuoteDetailTax _orderDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.amount * productTax.percentage) / 100);
                              quote.quoteDetailTaxList.add(_orderDetailTax);
                            }
                          });
                        }
                      });
                    });
                    quote.netAmount = (quote.quoteTaxList.length > 0) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
                    quote.finalTax = (quote.quoteTaxList.length > 0) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
                    setState(() {});
                  } else if (_isTaxApply == false) {
                    quote.netAmount = quote.grossAmount - quote.discount;
                  }
                }
                _calculate();
              })));

      setState(() {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    } catch (e) {
      print('Exception - saleQuoteAddScreen.dart - _addProducts(): ' + e.toString());
    }
  }

  Future<Null> _focusListener() async {
    try {
      if (_fOrderDate.hasFocus || _fDeliveryDate.hasFocus) {
        if (_fOrderDate.hasFocus) {
          _isTransactionDateSelection = true;
        } else {
          _isTransactionDateSelection = false;
        }
        _selectDate(context); //open date picker
      }
    } catch (e) {
      print('Exception - saleQuoteAddScreen.dart - _focusListener(): ' + e.toString());
    }
  }

  Future _generateOrderNumber() async {
    try {
      quote.saleQuoteNumber = await dbHelper.saleQuoteGetNewOrderNumber();
      _generatedOrderNo = '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${quote.saleQuoteNumber}';
      _generatedOrderNo = '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}' + '${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - _generatedOrderNo.length)}' + '${quote.saleQuoteNumber}';
      _cOrderNumber.text = _generatedOrderNo;
      setState(() {});
    } catch (e) {
      print('Exception - saleQuoteAddScreen.dart - _generateOrderNumber(): ' + e.toString());
    }
  }

  Future _getDetailForUpdateQuote() async {
    try {
      quote.quoteDetailList = await dbHelper.saleQuoteDetailGetList(
        orderIdList: [quote.id],
      );
      _selectedTaxGroup = (quote.taxGroup == "GST") ? 0 : 1;
      if (isMakeNewVersion) {
        quote.versionNumber = await dbHelper.getLatestQuoteVersionNumber(saleQuoteNumber: quote.saleQuoteNumber);
        _generatedVersionNo = quote.versionNumber.toString();
      } else {
        _generatedVersionNo = '${quote.versionNumber}';
      }
      _showRemarkInPrint = quote.showRemarkInPrint;
      _generatedOrderNo = '${quote.saleQuoteNumber}';
      _generatedOrderNo = '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${quote.saleQuoteNumber}';
      _generatedOrderNo = '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}' + '${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - _generatedOrderNo.length)}' + '${quote.saleQuoteNumber}';

      _cOrderNumber.text = _generatedOrderNo;
      _cVersionNumber.text = _generatedVersionNo;
      _cOrderDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(quote.orderDate);
      _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(quote.deliveryDate);
      _orderDate2 = quote.orderDate.toString();
      _deliveryDate2 = quote.deliveryDate.toString();
      _timeOfDay = TimeOfDay(hour: quote.deliveryDate.hour, minute: quote.deliveryDate.minute);
      String time = br.formatTimeOfDay(_timeOfDay);
      _cDeliveryTime.text = time;
      _cRemark.text = quote.remark;
      List<Product> _productList = await dbHelper.productGetList(productId: quote.quoteDetailList.map((item) => item.productId).toList());
      for (int i = 0; i < quote.quoteDetailList.length; i++) {
        _cQtyList.add(TextEditingController(text: quote.quoteDetailList[i].quantity.toString()));
        _cUnitPriceList.add(TextEditingController(text: quote.quoteDetailList[i].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString()));
        for (int j = 0; j < _productList.length; j++) {
          if (_productList[j].id == quote.quoteDetailList[i].productId) {
            _productList[j].productPriceList = await dbHelper.productPriceGetList(_productList[j].id);
            quote.quoteDetailList[i].product = _productList[j];
            if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
              UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == _productList[j].unitCombinationId);
              quote.quoteDetailList[i].product.unitList.add(_unitList.firstWhere((element) => element.id == _unitCombination.primaryUnitId));
              if (_unitCombination.secondaryUnitId != null) {
                quote.quoteDetailList[i].product.unitList.add(_unitList.firstWhere((element) => element.id == _unitCombination.secondaryUnitId));
              }
            }
          }
        }
        if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
          _cUnitList.add(TextEditingController(text: '${quote.quoteDetailList[i].product.unitList.firstWhere((element) => element.id == quote.quoteDetailList[i].unitId).code}'));
        }
      }

      quote.quoteTaxList = await dbHelper.saleQuoteTaxGetList(saleQuoteId: quote.id);
      _isTaxApply = (quote.quoteTaxList.length != 0) ? true : false;
      quote.quoteDetailTaxList = await dbHelper.saleQuoteDetailTaxGetList(quoteDetailIdList: quote.quoteDetailList.map((orderDetail) => orderDetail.id).toList());
      _quoteDetailTaxIdList = quote.quoteDetailTaxList.map((e) => e.id).toList();
      _orderDetailTaxLen = quote.quoteDetailTaxList.length;
      _cAccountId.text = '${quote.account.firstName} ${quote.account.lastName}';
      _cDiscount.text = quote.discount == 0 ? '0' : quote.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _cNetAmount.text = quote.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _isComplete = quote.isComplete;
      _cVoucherNumber.text = quote.voucherNumber;
      _calculate();
      _isDataLoaded = true;
      _tempSaleOrder = quote;
      print('SubTotal: ${quote.grossAmount}, Discount: ${quote.discount}, total: ${quote.netAmount}');
      setState(() {});
    } catch (e) {
      print('Exception - saleQuoteAddScreen.dart - _getDetailForUpdateOrder(): ' + e.toString());
    }
  }

  void _calculate() {
    double _paid = 0;
    quote.payment.paymentDetailList.forEach((element) {
      if (!element.deletedFromScreen) {
        _paid += element.amount;
      }
    });
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
                  builder: (BuildContext context) => SaleOrderScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      )));
            },
          ),
        ],
      );
      await showDialog(builder: (context) => dialog, context: context);
    } catch (e) {
      print('Exception - saleQuoteAddScreen.dart - showAlertd(): ' + e.toString());
    }
  }

  Future _onSubmit() async {
    try {
      if (_formKey.currentState.validate()) {
        if (quote.quoteDetailList.length > 0) {
          if (quote.netAmount > 0) {
            showLoader(global.appLocaleValues['txt_wait']);
            setState(() {});
            quote.accountId = (_account != null) ? _account.id : quote.accountId;
            quote.orderDate = DateTime.parse(_orderDate2);
            quote.deliveryDate = DateTime.parse(_deliveryDate2);
            quote.deliveryDate = DateTime(quote.deliveryDate.year, quote.deliveryDate.month, quote.deliveryDate.day, _timeOfDay.hour, _timeOfDay.minute);
            print('date: ${quote.deliveryDate}');
            quote.isComplete = _isComplete;
            quote.showRemarkInPrint = _showRemarkInPrint;
            if (quote.finalTax > 0) {
              quote.taxGroup = (_selectedTaxGroup == 0) ? "GST" : "IGST";
            }
            quote.voucherNumber = _cVoucherNumber.text.trim();
            quote.remark = _cRemark.text.trim();
            if (quote.id == null) {
              quote.status = "OPEN";
              quote = await dbHelper.saleQuoteInsert(quote, _isTaxApply);
            } else {
              if (!isMakeNewVersion) {
                await dbHelper.saleQuoteDetailTaxDelete(quoteDetailTaxIdList: _quoteDetailTaxIdList);
                await dbHelper.saleQuoteTaxDelete(quote.id);
              } else {
                if (quote.quoteTaxList != null && quote.quoteTaxList.length > 0) {
                  quote.quoteTaxList.map((e) => e.id = null).toList();
                }

                if (quote.quoteDetailTaxList != null && quote.quoteDetailTaxList.length > 0) {
                  quote.quoteTaxList.map((e) => e.id = null).toList();
                }
              }
              if (quote.status != 'CANCELLED') {
                bool _isSame = true;
                quote.quoteDetailList.forEach((element) {
                  if (element.quantity != element.invoicedQuantity) {
                    _isSame = false;
                  }
                });
                quote.status = (_isSame) ? "INVOICED" : "OPEN";
              }

              if (isMakeNewVersion) {
                quote.saleQuoteNumber = int.parse(_cOrderNumber.text);
                quote.status = "OPEN";
                quote.id = null;
                quote.saleQuoteNumber = int.parse(_cOrderNumber.text);
                quote.versionNumber = int.parse(_cVersionNumber.text);
                quote.accountId = (_account != null) ? _account.id : quote.accountId;
                quote.orderDate = DateTime.parse(_orderDate2);
                quote.deliveryDate = DateTime.parse(_deliveryDate2);
                quote.deliveryDate = DateTime(quote.deliveryDate.year, quote.deliveryDate.month, quote.deliveryDate.day, _timeOfDay.hour, _timeOfDay.minute);
                quote.isComplete = _isComplete;
                if (quote.finalTax > 0) {
                  quote.taxGroup = (_selectedTaxGroup == 0) ? "GST" : "IGST";
                }
                quote.voucherNumber = _cVoucherNumber.text.trim();
                quote.remark = _cRemark.text.trim();
                quote.discount = double.parse(_cDiscount.text);
                quote.grossAmount = double.parse(_cNetAmount.text);
                // quote. netAmount = double.parse(_cNetAmount.text);

                quote = await dbHelper.saleQuoteInsert(quote, _isTaxApply);
              } else {
                quote = await dbHelper.saleQuoteUpdate(quote: quote, updateFrom: 1, isTaxApplied: _isTaxApply, isAccountChanged: _accountChanged);
              }
            }
            String _notificationTime = br.getSystemFlagValue(global.systemFlagNameList.notificationTime);
            TimeOfDay tod = br.stringToTimeOfDay(_notificationTime);

            bool _scheduleNotification = false;
            if (quote.deliveryDate != null && quote.deliveryDate.isAfter(DateTime.now()) && _tempSaleOrder != null && _tempSaleOrder.deliveryDate != null && _tempSaleOrder.deliveryDate != quote.deliveryDate) {
              _scheduleNotification = true;
            } else if (quote.deliveryDate != null && quote.deliveryDate.isAfter(DateTime.now())) {
              {
                _scheduleNotification = true;
              }
              if (_scheduleNotification) {
                int notificationId = int.parse(global.moduleIds['SaleOrder'].toString() + '01' + quote.id.toString());
                await br.scheduleNotification(notificationId, quote.deliveryDate.add(Duration(hours: tod.hour, minutes: tod.minute)), 'Sale order delivery', 'order number - ${quote.saleQuoteNumber} on ${DateFormat('MMMM dd').format(quote.deliveryDate)}', '{"module":"SaleOrder","id":"${quote.id}"}');
                int notificationId1 = int.parse(global.moduleIds['SaleOrder'].toString() + '02' + quote.id.toString());
                await br.scheduleNotification(notificationId1, (quote.deliveryDate.subtract(Duration(days: br.remainingDays(quote.deliveryDate, false)))).add(Duration(hours: tod.hour, minutes: tod.minute)), 'Sale order delivery',
                    'order number - ${quote.saleQuoteNumber} on ${DateFormat('MMMM dd').format(quote.deliveryDate)}', '{"module":"SaleOrder","id":"${quote.id}"}');
                // get notification at delivery time code start
                int notificationId2 = int.parse(global.moduleIds['SaleOrder'].toString() + '03' + quote.id.toString());
                await br.scheduleNotification(notificationId2, quote.deliveryDate, 'Sale order delivery', 'order number - ${quote.saleQuoteNumber} it is time to delivered', '{"module":"SaleOrder","id":"${quote.id}"}');
                // get notification at delivery time code end
              }
            }
            hideLoader();
            setState(() {});

            if (returnScreenId == 0) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => SalesQuoteScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      )));
            } else if (returnScreenId == 1) {
              Navigator.of(context).pop();
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(global.appLocaleValues['txt_total_vld'])));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text((br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product')
                  ? global.appLocaleValues['tle_inv_return_product_err_vld']
                  : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service')
                      ? global.appLocaleValues['tle_inv_return_service_err_vld']
                      : global.appLocaleValues['tle_inv_return_both_err_vld'])));
        }
      } else {
        _autovalidate = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - saleQuoteAddScreen.dart - _onSubmit(): ' + e.toString());
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
            _cOrderDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
            _orderDate2 = picked.toString().substring(0, 10);
            _cDeliveryDate.text = _cOrderDate.text;
            _deliveryDate2 = _orderDate2;
          } else {
            String _tempDate = picked.toString().substring(0, 10);
            if (DateTime.parse(_tempDate).isAfter(DateTime.parse(_orderDate2)) || _tempDate == _orderDate2) {
              _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
              _deliveryDate2 = picked.toString();
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
      print('Exception - saleQuoteAddScreen.dart - _selectDate(): ' + e.toString());
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
        SaleQuoteTax _quoteTax = SaleQuoteTax(null, null, _taxList[i].id, _taxList[i].percentage, 0.0);
        _quoteTax.taxName = _taxList[i].taxName;
        quote.quoteTaxList.add(_quoteTax);
      }
      setState(() {});
    } catch (e) {
      print('Exception - saleQuoteAddScreen.dart - _getTaxes(): ' + e.toString());
    }
  }

  Future _removeProduct(index) async {
    try {
      quote.grossAmount -= quote.quoteDetailList[index].amount;
      if (quote.id == null) {
        if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false' || quote.quoteDetailList.length < 1)) {
          quote.finalTax = 0.0;
          for (int i = 0; i < quote.quoteTaxList.length; i++) {
            quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
            if (_isTaxApply) {
              quote.finalTax += quote.quoteTaxList[i].totalAmount;
            }
          }
          quote.netAmount = (_isTaxApply && quote.quoteTaxList.length > 0) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
        } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
          quote.finalTax = 0.0;
          quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();

          List<int> _tempProductIdList = [];
          quote.quoteDetailList.forEach((orderDetail) {
            if (orderDetail.productId != quote.quoteDetailList[index].productId) {
              _tempProductIdList.add(orderDetail.productId);
            }
          });

          _productTaxList = await dbHelper.productTaxGetList(productIdList: _tempProductIdList);
          quote.quoteDetailTaxList.clear();
          quote.quoteDetailList.forEach((orderDetail) {
            _productTaxList.forEach((productTax) {
              if (orderDetail.productId == productTax.productId) {
                quote.quoteTaxList.forEach((orderTax) {
                  if (orderTax.taxId == productTax.taxMasterId) {
                    orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                    SaleQuoteDetailTax _quoteDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                    quote.quoteDetailTaxList.add(_quoteDetailTax);
                  }
                });
              }
            });
          });
          quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
          quote.finalTax = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
          quote.netAmount = quote.grossAmount - quote.discount;
        }
      } else {
        if (quote.quoteTaxList.length != 0 && (quote.quoteDetailTaxList.length == 0 || quote.quoteDetailList.length < 1)) {
          quote.finalTax = 0.0;
          for (int i = 0; i < quote.quoteTaxList.length; i++) {
            quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
            if (_isTaxApply) {
              quote.finalTax += quote.quoteTaxList[i].totalAmount;
            }
          }
          quote.netAmount = (_isTaxApply && quote.quoteTaxList.length > 0) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
          setState(() {});
        } else if (quote.quoteTaxList.length != 0 && quote.quoteDetailTaxList.length != 0) {
          quote.finalTax = 0.0;
          quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();

          List<int> _tempProductIdList = [];
          quote.quoteDetailList.forEach((orderDetail) {
            if (orderDetail.productId != quote.quoteDetailList[index].productId) {
              _tempProductIdList.add(orderDetail.productId);
            }
          });

          _productTaxList = await dbHelper.productTaxGetList(productIdList: _tempProductIdList);
          quote.quoteDetailTaxList.clear();
          quote.quoteDetailList.forEach((orderDetail) {
            _productTaxList.forEach((productTax) {
              if (orderDetail.productId == productTax.productId) {
                quote.quoteTaxList.forEach((orderTax) {
                  if (orderTax.taxId == productTax.taxMasterId) {
                    orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                    SaleQuoteDetailTax _quoteDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                    quote.quoteDetailTaxList.add(_quoteDetailTax);
                  }
                });
              }
            });
          });
          quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
          quote.finalTax = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        } else if (_isTaxApply == false) {
          quote.netAmount = quote.grossAmount - quote.discount;
        }
      }
      quote.quoteDetailList.removeAt(index);
      _cUnitPriceList.removeAt(index);
      _cQtyList.removeAt(index);
      if (_cUnitList.length > 0) {
        _cUnitList.removeAt(index);
      }
      if (quote.quoteDetailList.length < 1) {
        _cNetAmount.text = quote.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        quote.discount = 0;
        quote.netAmount = 0;
        _cDiscount.text = quote.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        quote.quoteTaxList.map((e) => e.totalAmount = 0).toList();
      }
      FocusScope.of(context).requestFocus(_focusNode);
      // _calculate();
      setState(() {});
    } catch (e) {
      print('Exception - saleQuoteAddScreen.dart - _removeProduct(): ' + e.toString());
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
      print('Exception - saleQuoteAddScreen.dart - _discountListener(): ' + e.toString());
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
      print('Exception - saleQuoteAddScreen.dart - _netAmountListener(): ' + e.toString());
    }
  }

  Future _onApplyTaxChanged(bool value) async {
    try {
      if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true') {
        _isTaxApply = value;
        if (_isTaxApply != true) {
          quote.netAmount = quote.grossAmount - quote.discount;
          quote.finalTax = 0.0;
        } else {
          if (quote.quoteTaxList.length < 1) {
            await _getTaxes();
          }
          if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false' || quote.quoteDetailList.length < 1)) {
            quote.finalTax = 0.0;
            for (int i = 0; i < quote.quoteTaxList.length; i++) {
              quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
              if (_isTaxApply) {
                quote.finalTax += quote.quoteTaxList[i].totalAmount;
              }
            }
            quote.netAmount = (_isTaxApply && quote.quoteTaxList.length > 0) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
          } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true') {
            quote.finalTax = 0.0;
            quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
            _productTaxList = await dbHelper.productTaxGetList(productIdList: quote.quoteDetailList.map((e) => e.productId).toList());
            quote.quoteDetailTaxList.clear();
            quote.quoteDetailList.forEach((orderDetail) {
              _productTaxList.forEach((productTax) {
                if (orderDetail.productId == productTax.productId) {
                  quote.quoteTaxList.forEach((orderTax) {
                    if (orderTax.taxId == productTax.taxMasterId) {
                      orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                      SaleQuoteDetailTax _quoteDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                      quote.quoteDetailTaxList.add(_quoteDetailTax);
                    }
                  });
                }
              });
            });
            quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
            quote.finalTax = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

            setState(() {});
          } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
            quote.netAmount = quote.grossAmount - quote.discount;
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
      print('Exception - saleQuoteAddScreen.dart - _netAmountListener(): ' + e.toString());
    }
  }

  Future _onTaxGroupChanged(value) async {
    try {
      _isDataLoaded = false;
      setState(() {});
      _selectedTaxGroup = value;
      quote.finalTax = 0;
      quote.quoteTaxList.clear();
      await _getTaxes();
      if (quote.id == null) {
        quote.quoteDetailTaxList.clear();
        if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
          for (int i = 0; i < quote.quoteTaxList.length; i++) {
            quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
            if (_isTaxApply) {
              quote.finalTax += quote.quoteTaxList[i].totalAmount;
            }
          }
          quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
        } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
          quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
          _productTaxList = await dbHelper.productTaxGetList(productIdList: quote.quoteDetailList.map((orderDetail) => orderDetail.productId).toList());

          quote.quoteDetailList.forEach((orderDetail) {
            _productTaxList.forEach((productTax) {
              if (orderDetail.productId == productTax.productId) {
                quote.quoteTaxList.forEach((orderTax) {
                  if (orderTax.taxId == productTax.taxMasterId) {
                    orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                    SaleQuoteDetailTax _orderDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.amount * productTax.percentage) / 100);
                    quote.quoteDetailTaxList.add(_orderDetailTax);
                  }
                });
              }
            });
          });
          quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderDetailTax) => orderDetailTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
          quote.finalTax = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        }
      } else {
        if (quote.quoteTaxList.length != 0 && quote.quoteDetailTaxList.length == 0) {
          for (int i = 0; i < quote.quoteTaxList.length; i++) {
            quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
            if (_isTaxApply) {
              quote.finalTax += quote.quoteTaxList[i].totalAmount;
            }
          }
          quote.netAmount = (_isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
        } else if (quote.quoteTaxList.length != 0 && quote.quoteDetailTaxList.length != 0) {
          quote.quoteDetailTaxList.clear();
          quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
          _productTaxList = await dbHelper.productTaxGetList(productIdList: quote.quoteDetailList.map((orderDetail) => orderDetail.productId).toList());

          quote.quoteDetailList.forEach((orderDetail) {
            _productTaxList.forEach((productTax) {
              if (orderDetail.productId == productTax.productId) {
                quote.quoteTaxList.forEach((orderTax) {
                  if (orderTax.taxId == productTax.taxMasterId) {
                    orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                    SaleQuoteDetailTax _orderDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.amount * productTax.percentage) / 100);
                    quote.quoteDetailTaxList.add(_orderDetailTax);
                  }
                });
              }
            });
          });
          quote.netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
          quote.finalTax = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        }
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - saleOrderAddScreen.dart - _onTaxGroupChanged(): ' + e.toString());
    }
  }

  Future _selectUnit(int index) async {
    try {
      await showDialog(
          context: context,
          builder: (_) {
            return SelectUnitDialog(a: widget.analytics, o: widget.observer, unitList: quote.quoteDetailList[index].product.unitList);
          }).then((value) async {
        if (value != null) {
          List<Unit> _temp = value.toList();
          _cUnitList[index].text = _temp.firstWhere((element) => element.isSelected).code;
          quote.quoteDetailList[index].unitId = _temp.firstWhere((element) => element.isSelected).id;
          quote.quoteDetailList[index].unitCode = _temp.firstWhere((element) => element.isSelected).code;
          if (quote.quoteDetailList[index].unitId == quote.quoteDetailList[index].product.productPriceList[0].unitId) {
            // if product unit and selected unit is same
            quote.quoteDetailList[index].unitPrice = quote.quoteDetailList[index].actualUnitPrice;
            _cUnitPriceList[index].text = quote.quoteDetailList[index].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
            quote.quoteDetailList[index].amount = quote.quoteDetailList[index].quantity * quote.quoteDetailList[index].unitPrice;
          } else {
            // if product unit and selected unit is not same
            UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == quote.quoteDetailList[index].product.unitCombinationId);
            if (quote.quoteDetailList[index].unitId == _unitCombination.primaryUnitId) // if parent unit is selected
            {
              quote.quoteDetailList[index].unitPrice = quote.quoteDetailList[index].actualUnitPrice * _unitCombination.measurement;
              _cUnitPriceList[index].text = quote.quoteDetailList[index].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
              quote.quoteDetailList[index].amount = quote.quoteDetailList[index].quantity * quote.quoteDetailList[index].unitPrice;
            } else if (quote.quoteDetailList[index].unitId == _unitCombination.secondaryUnitId) // if child unit is selected
            {
              quote.quoteDetailList[index].unitPrice = quote.quoteDetailList[index].quantity * (quote.quoteDetailList[index].actualUnitPrice / _unitCombination.measurement);
              _cUnitPriceList[index].text = quote.quoteDetailList[index].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
              quote.quoteDetailList[index].amount = quote.quoteDetailList[index].unitPrice;
            }
          }
          // quote.quoteDetailList[index].amount = quote.quoteDetailList[index].quantity * quote.quoteDetailList[index].unitPrice;
          quote.grossAmount = quote.quoteDetailList.map((orderDetail) => orderDetail.amount).reduce((sum, amount) => sum + amount);
          if (quote.id == null) {
            if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
              quote.finalTax = 0.0;
              for (int i = 0; i < quote.quoteTaxList.length; i++) {
                quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
                // if (_isTaxApply) {
                quote.finalTax += quote.quoteTaxList[i].totalAmount;
                // }
              }
              quote.netAmount = (quote.quoteTaxList.length > 0) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
            } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
              quote.finalTax = 0.0;
              quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
              quote.quoteDetailTaxList.clear();
              quote.quoteDetailList.forEach((orderDetail) {
                _productTaxList.forEach((productTax) {
                  if (orderDetail.productId == productTax.productId) {
                    quote.quoteTaxList.forEach((orderTax) {
                      if (orderTax.taxId == productTax.taxMasterId) {
                        orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                        SaleQuoteDetailTax _quoteDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                        quote.quoteDetailTaxList.add(_quoteDetailTax);
                      }
                    });
                  }
                });
              });
              quote.netAmount = (quote.quoteTaxList.length > 0) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
              quote.finalTax = (quote.quoteTaxList.length > 0) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

              setState(() {});
            } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
              quote.netAmount = quote.grossAmount - quote.discount;
            }
          } else {
            if (quote.quoteTaxList.length != 0 && _orderDetailTaxLen == 0) {
              quote.finalTax = 0.0;
              for (int i = 0; i < quote.quoteTaxList.length; i++) {
                quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
                // if (_isTaxApply) {
                quote.finalTax += quote.quoteTaxList[i].totalAmount;
                // }
              }
              quote.netAmount = (quote.quoteTaxList.length > 0) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
            } else if (quote.quoteTaxList.length != 0 && _orderDetailTaxLen != 0) {
              quote.finalTax = 0.0;
              quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
              quote.quoteDetailTaxList.clear();
              if (_productTaxList.length == 0) {
                _productTaxList = await dbHelper.productTaxGetList(productIdList: quote.quoteDetailList.map((orderDetail) => orderDetail.productId).toList());
              }
              quote.quoteDetailList.forEach((orderDetail) {
                _productTaxList.forEach((productTax) {
                  if (orderDetail.productId == productTax.productId) {
                    quote.quoteTaxList.forEach((orderTax) {
                      if (orderTax.taxId == productTax.taxMasterId) {
                        orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                        SaleQuoteDetailTax _quoteDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                        quote.quoteDetailTaxList.add(_quoteDetailTax);
                      }
                    });
                  }
                });
              });
              quote.netAmount = (quote.quoteTaxList.length > 0) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
              quote.finalTax = (quote.quoteTaxList.length > 0) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
              setState(() {});
            } else if (_isTaxApply == false) {
              quote.netAmount = quote.grossAmount - quote.discount;
            }
          }
          _calculate();
          setState(() {});
          // quote.quoteDetailList[index].unitPrice =
        }
      });
      setState(() {});
    } catch (e) {
      print('Exception - saleQuoteAddScreen.dart - _selectUnit(): ' + e.toString());
    }
  }

  // Future _onTaxGroupChanged(value) async {
  //   try {
  //     _isDataLoaded = false;
  //     setState(() {});
  //     _selectedTaxGroup = value;
  //     quote.finalTax = 0;
  //     quote.quoteTaxList.clear();
  //     await _getTaxes();
  //     if (quote.id == null) {
  //       quote.quoteDetailTaxList.clear();
  //       if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
  //         for (int i = 0; i < quote.quoteTaxList.length; i++) {
  //           quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
  //           if (_isTaxApply) {
  //             quote.finalTax += quote.quoteTaxList[i].totalAmount;
  //           }
  //         }
  //         quote. netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
  //       } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
  //         quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
  //         _productTaxList = await dbHelper.productTaxGetList(productIdList: quote.quoteDetailList.map((orderDetail) => orderDetail.productId).toList());

  //         quote.quoteDetailList.forEach((orderDetail) {
  //           _productTaxList.forEach((productTax) {
  //             if (orderDetail.productId == productTax.productId) {
  //               quote.quoteTaxList.forEach((orderTax) {
  //                 if (orderTax.taxId == productTax.taxMasterId) {
  //                   orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
  //                   SaleQuoteDetailTax _quoteDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.amount * productTax.percentage) / 100);
  //                   quote.quoteDetailTaxList.add(_quoteDetailTax);
  //                 }
  //               });
  //             }
  //           });
  //         });
  //         quote. netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderDetailTax) => orderDetailTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
  //         quote.finalTax = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
  //         setState(() {});
  //       }
  //     } else {
  //       if (quote.quoteTaxList.length != 0 && quote.quoteDetailTaxList.length == 0) {
  //         for (int i = 0; i < quote.quoteTaxList.length; i++) {
  //           quote.quoteTaxList[i].totalAmount = ((quote.grossAmount - quote.discount) * quote.quoteTaxList[i].percentage) / 100;
  //           if (_isTaxApply) {
  //             quote.finalTax += quote.quoteTaxList[i].totalAmount;
  //           }
  //         }
  //         quote. netAmount = (_isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
  //       } else if (quote.quoteTaxList.length != 0 && quote.quoteDetailTaxList.length != 0) {
  //         quote.quoteDetailTaxList.clear();
  //         quote.quoteTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
  //         _productTaxList = await dbHelper.productTaxGetList(productIdList: quote.quoteDetailList.map((orderDetail) => orderDetail.productId).toList());

  //         quote.quoteDetailList.forEach((orderDetail) {
  //           _productTaxList.forEach((productTax) {
  //             if (orderDetail.productId == productTax.productId) {
  //               quote.quoteTaxList.forEach((orderTax) {
  //                 if (orderTax.taxId == productTax.taxMasterId) {
  //                   orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
  //                   SaleQuoteDetailTax _quoteDetailTax = SaleQuoteDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.amount * productTax.percentage) / 100);
  //                   quote.quoteDetailTaxList.add(_quoteDetailTax);
  //                 }
  //               });
  //             }
  //           });
  //         });
  //         quote. netAmount = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.grossAmount - quote.discount + quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : quote.grossAmount - quote.discount;
  //         quote.finalTax = (quote.quoteTaxList.length > 0 && _isTaxApply) ? quote.quoteTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
  //         setState(() {});
  //       }
  //     }
  //     _isDataLoaded = true;
  //     setState(() {});
  //   } catch (e) {
  //     print('Exception - saleQuoteAddScreen.dart - _onTaxGroupChanged(): ' + e.toString());
  //   }
  // }

  // Future<Null> _chooseDeliveryTime() async {
  //   try {
  //     TimeOfDay picked;
  //     picked = await showTimePicker(context: context, initialTime: _timeOfDay);
  //     if (picked != null && picked != _timeOfDay) {
  //       _timeOfDay = picked;
  //       print('time: ${_timeOfDay.hour}');
  //       String time = br.formatTimeOfDay(_timeOfDay);
  //       _cDeliveryTime.text = time;
  //     }
  //     setState(() {});
  //   } catch (e) {
  //     print('Exception - saleQuoteAddScreen.dart - _chooseDeliveryTime(): ' + e.toString());
  //   }
  // }

}
