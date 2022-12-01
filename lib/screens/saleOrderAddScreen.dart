// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
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
import 'package:accounting_app/models/paymentSaleOrderModel.dart';
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/productTaxModel.dart';
import 'package:accounting_app/models/saleOrderDetailModel.dart';
import 'package:accounting_app/models/saleOrderDetailTaxModel.dart';
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/models/saleOrderTaxModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/models/unitCombinationModel.dart';
import 'package:accounting_app/models/unitModel.dart';
import 'package:accounting_app/screens/saleOrderScreen.dart';
import 'package:accounting_app/screens/salesQuoteScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SaleOrderAddSreen extends BaseRoute {
  final SaleOrder order;
  final int screenId;
  SaleOrderAddSreen({@required a, @required o, @required this.order, this.screenId}) : super(a: a, o: o, r: 'SaleOrderAddSreen');
  @override
  _SaleOrderAddSreenState createState() => _SaleOrderAddSreenState(this.order, this.screenId);
}

class _SaleOrderAddSreenState extends BaseRouteState {
  final int screenId;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  TextEditingController _cAccountId = TextEditingController();
  TextEditingController _cOrderDate = TextEditingController();
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
  var _fVoucherNumber = FocusNode();
  var _focusNode = FocusNode();
  String _generatedOrderNo;
//  double _remainAmount;
  bool _isComplete = false;
  String _orderDate2;
  String _deliveryDate2;
  SaleOrder order;
  Account _account;
  bool _isDataLoaded = false;
  bool _isTaxApply = false;
  int _orderDetailTaxLen;
  double _totalDue = 0;
  int _selectedTaxGroup = 0;
  double _totalPaid = 0;
  bool _accountChanged = false;
  bool _autovalidate = false;
  List<UnitCombination> _unitCombinationList = [];
  List<Unit> _unitList = [];
  List<TaxMaster> _allTaxList = [];
  List<int> _orderDetailTaxIdList = []; // use for delete detail tax in edit mode
  SaleOrder _tempSaleOrder = SaleOrder();
  TimeOfDay _timeOfDay = TimeOfDay(hour: 9, minute: 0);
  bool _showRemarkInPrint = false;

  _SaleOrderAddSreenState(this.order, this.screenId) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: (order.id != null) ? Text(global.appLocaleValues['lbl_update_order'], style: Theme.of(context).appBarTheme.titleTextStyle) : Text(global.appLocaleValues['lbl_add_order'], style: Theme.of(context).appBarTheme.titleTextStyle),
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
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10),
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
                                                padding: const EdgeInsets.only(top: 8, bottom: 8),
                                                child: Text(global.appLocaleValues['tle_sale_order_no'], style: Theme.of(context).primaryTextTheme.headline3),
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
                                                padding: const EdgeInsets.only(top: 8, bottom: 8),
                                                child: Text(global.appLocaleValues['lbl_order_date'], style: Theme.of(context).primaryTextTheme.headline3),
                                              ),
                                              TextFormField(
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  border: nativeTheme().inputDecorationTheme.border,
                                                  hintText: global.appLocaleValues['lbl_order_date'],
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
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  children: <Widget>[
                                    MaterialButton(
                                      child: Text(
                                          '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['btn_add_products'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['btn_add_services'] : global.appLocaleValues['btn_add_both']}',
                                          style: Theme.of(context).primaryTextTheme.headline2),
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
                                              itemCount: order.orderDetailList.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Card(
                                                      child: ListTile(
                                                        leading: Column(
                                                          children: [
                                                            Text(
                                                              '${order.orderDetailList[index].product.name}',
                                                              style: Theme.of(context).primaryTextTheme.subtitle1,
                                                            ),
                                                            Text(
                                                                (br.getSystemFlagValue(global.systemFlagNameList.useProductSupplierCode) == 'true' && order.orderDetailList[index].product.supplierProductCode != '')
                                                                    ? ' ${order.orderDetailList[index].product.supplierProductCode}'
                                                                    : ' ${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + order.orderDetailList[index].product.productCode.toString().length))}${order.orderDetailList[index].product.productCode}',
                                                                style: Theme.of(context).primaryTextTheme.subtitle2),
                                                          ],
                                                        ),
                                                        subtitle: Padding(
                                                            padding: EdgeInsets.only(top: 10),
                                                            child: Text(
                                                              '${global.appLocaleValues['lbl_total']}:  ${global.currency.symbol} ${order.orderDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                                                                          order.orderDetailList[index].quantity = (value.length > 0) ? double.parse(value) : 0;
                                                                          order.orderDetailList[index].amount = (order.orderDetailList[index].quantity * double.parse(_cUnitPriceList[index].text));
                                                                          order.grossAmount = order.orderDetailList.map((orderDetail) => orderDetail.amount).reduce((sum, amount) => sum + amount);

                                                                          if (order.id == null) {
                                                                            if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
                                                                              order.finalTax = 0.0;
                                                                              for (int i = 0; i < order.orderTaxList.length; i++) {
                                                                                order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
                                                                                if (_isTaxApply) {
                                                                                  order.finalTax += order.orderTaxList[i].totalAmount;
                                                                                }
                                                                              }
                                                                              order.netAmount = (_isTaxApply && order.orderTaxList.length > 0)
                                                                                  ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : order.grossAmount - order.discount;
                                                                            } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                                              order.finalTax = 0.0;
                                                                              order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                                                                              order.orderDetailTaxList.clear();
                                                                              order.orderDetailList.forEach((orderDetail) {
                                                                                _productTaxList.forEach((productTax) {
                                                                                  if (orderDetail.productId == productTax.productId) {
                                                                                    order.orderTaxList.forEach((orderTax) {
                                                                                      if (orderTax.taxId == productTax.taxMasterId) {
                                                                                        orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                                                                                        SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                                                                                        order.orderDetailTaxList.add(_orderDetailTax);
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                });
                                                                              });
                                                                              order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply)
                                                                                  ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : order.grossAmount - order.discount;
                                                                              order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

                                                                              setState(() {});
                                                                            } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                                                              order.netAmount = order.grossAmount - order.discount;
                                                                            }
                                                                          } else {
                                                                            if (order.orderTaxList.length != 0 && _orderDetailTaxLen == 0) {
                                                                              order.finalTax = 0.0;
                                                                              for (int i = 0; i < order.orderTaxList.length; i++) {
                                                                                order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
                                                                                if (_isTaxApply) {
                                                                                  order.finalTax += order.orderTaxList[i].totalAmount;
                                                                                }
                                                                              }
                                                                              order.netAmount = (_isTaxApply && order.orderTaxList.length > 0)
                                                                                  ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : order.grossAmount - order.discount;
                                                                            } else if (order.orderTaxList.length != 0 && _orderDetailTaxLen != 0) {
                                                                              order.finalTax = 0.0;
                                                                              order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                                                                              order.orderDetailTaxList.clear();
                                                                              if (_productTaxList.length == 0) {
                                                                                _productTaxList = await dbHelper.productTaxGetList(productIdList: order.orderDetailList.map((orderDetail) => orderDetail.productId).toList());
                                                                              }
                                                                              order.orderDetailList.forEach((orderDetail) {
                                                                                _productTaxList.forEach((productTax) {
                                                                                  if (orderDetail.productId == productTax.productId) {
                                                                                    order.orderTaxList.forEach((orderTax) {
                                                                                      if (orderTax.taxId == productTax.taxMasterId) {
                                                                                        orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                                                                                        SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                                                                                        order.orderDetailTaxList.add(_orderDetailTax);
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                });
                                                                              });
                                                                              order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply)
                                                                                  ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : order.grossAmount - order.discount;
                                                                              order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

                                                                              setState(() {});
                                                                            } else if (_isTaxApply == false) {
                                                                              order.netAmount = order.grossAmount - order.discount;
                                                                            }
                                                                          }
                                                                          _calculate();
                                                                          setState(() {});
                                                                        } catch (e) {
                                                                          print('Exception - saleOrderAddScreen.dart - Qty_onChanged: ' + e.toString());
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
                                                                          order.orderDetailList[index].unitPrice = (value.length > 0) ? double.parse(value) : 0;
                                                                          if (order.orderDetailList[index].product.productPriceList[0].unitId == order.orderDetailList[index].unitId) {
                                                                            // if product unit and sold unit is same
                                                                            order.orderDetailList[index].amount = order.orderDetailList[index].unitPrice * order.orderDetailList[index].quantity;
                                                                          } else {
                                                                            UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == order.orderDetailList[index].product.unitCombinationId);
                                                                            if (order.orderDetailList[index].unitId == _unitCombination.primaryUnitId) // if parent unit is selected
                                                                            {
                                                                              if (_unitCombination.primaryUnitId == order.orderDetailList[index].product.productPriceList[0].unitId) {
                                                                                order.orderDetailList[index].amount = order.orderDetailList[index].unitPrice * order.orderDetailList[index].quantity;
                                                                              } else {
                                                                                order.orderDetailList[index].amount = (order.orderDetailList[index].unitPrice * _unitCombination.measurement) * order.orderDetailList[index].quantity;
                                                                              }
                                                                              order.orderDetailList[index].amount = order.orderDetailList[index].quantity * order.orderDetailList[index].unitPrice;
                                                                            } else // if child unit is selected
                                                                            {
                                                                              if (_unitCombination.secondaryUnitId == order.orderDetailList[index].product.productPriceList[0].unitId) {
                                                                                order.orderDetailList[index].amount = order.orderDetailList[index].unitPrice * order.orderDetailList[index].quantity;
                                                                              } else {
                                                                                order.orderDetailList[index].amount = order.orderDetailList[index].unitPrice;
                                                                              }
                                                                            }
                                                                          }

                                                                          order.grossAmount = order.orderDetailList.map((orderDetail) => orderDetail.amount).reduce((sum, amount) => sum + amount);
                                                                          if (order.id == null) {
                                                                            if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
                                                                              order.finalTax = 0.0;
                                                                              for (int i = 0; i < order.orderTaxList.length; i++) {
                                                                                order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
                                                                                if (_isTaxApply) {
                                                                                  order.finalTax += order.orderTaxList[i].totalAmount;
                                                                                }
                                                                              }
                                                                              order.netAmount = (_isTaxApply && order.orderTaxList.length > 0)
                                                                                  ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : order.grossAmount - order.discount;
                                                                            } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                                              order.finalTax = 0.0;
                                                                              order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                                                                              order.orderDetailTaxList.clear();
                                                                              order.orderDetailList.forEach((orderDetail) {
                                                                                _productTaxList.forEach((productTax) {
                                                                                  if (orderDetail.productId == productTax.productId) {
                                                                                    order.orderTaxList.forEach((orderTax) {
                                                                                      if (orderTax.taxId == productTax.taxMasterId) {
                                                                                        orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                                                                                        SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                                                                                        order.orderDetailTaxList.add(_orderDetailTax);
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                });
                                                                              });
                                                                              order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply)
                                                                                  ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : order.grossAmount - order.discount;
                                                                              order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

                                                                              setState(() {});
                                                                            } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                                                              order.netAmount = order.grossAmount - order.discount;
                                                                            }
                                                                          } else {
                                                                            if (order.orderTaxList.length != 0 && _orderDetailTaxLen == 0) {
                                                                              order.finalTax = 0.0;
                                                                              for (int i = 0; i < order.orderTaxList.length; i++) {
                                                                                order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
                                                                                if (_isTaxApply) {
                                                                                  order.finalTax += order.orderTaxList[i].totalAmount;
                                                                                }
                                                                              }
                                                                              order.netAmount = (_isTaxApply && order.orderTaxList.length > 0)
                                                                                  ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : order.grossAmount - order.discount;
                                                                            } else if (order.orderTaxList.length != 0 && _orderDetailTaxLen != 0) {
                                                                              order.finalTax = 0.0;
                                                                              order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                                                                              order.orderDetailTaxList.clear();
                                                                              if (_productTaxList.length == 0) {
                                                                                _productTaxList = await dbHelper.productTaxGetList(productIdList: order.orderDetailList.map((orderDetail) => orderDetail.productId).toList());
                                                                              }
                                                                              order.orderDetailList.forEach((orderDetail) {
                                                                                _productTaxList.forEach((productTax) {
                                                                                  if (orderDetail.productId == productTax.productId) {
                                                                                    order.orderTaxList.forEach((orderTax) {
                                                                                      if (orderTax.taxId == productTax.taxMasterId) {
                                                                                        orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                                                                                        SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                                                                                        order.orderDetailTaxList.add(_orderDetailTax);
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                });
                                                                              });
                                                                              order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply)
                                                                                  ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount)
                                                                                  : order.grossAmount - order.discount;
                                                                              order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
                                                                              setState(() {});
                                                                            } else if (_isTaxApply == false) {
                                                                              order.netAmount = order.grossAmount - order.discount;
                                                                            }
                                                                          }
                                                                          _calculate();
                                                                          setState(() {});
                                                                        } catch (e) {
                                                                          print('Exception - saleOrderAddScreen.dart - UP_onChanged: ' + e.toString());
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
                                                      ),
                                                    ),
                                                    // Row(
                                                    //   mainAxisSize: MainAxisSize.min,
                                                    //   children: <Widget>[
                                                    //     SizedBox(
                                                    //       width: 25,
                                                    //       child: IconButton(
                                                    //         icon: Icon(
                                                    //           Icons.cancel,
                                                    //           color: Colors.red,
                                                    //         ),
                                                    //         onPressed: () async {
                                                    //           await _removeProduct(index);
                                                    //         },
                                                    //       ),
                                                    //     ),
                                                    //     Expanded(
                                                    //         child: Column(
                                                    //       // mainAxisSize: MainAxisSize.min,
                                                    //       children: [
                                                    //         Align(
                                                    //           alignment: Alignment.centerLeft,
                                                    //           child: Padding(
                                                    //             padding: const EdgeInsets.only(left: 15),
                                                    //             child: Row(
                                                    //               mainAxisSize: MainAxisSize.min,
                                                    //               children: [
                                                    //                 Text(
                                                    //                   '${order.orderDetailList[index].product.name}',
                                                    //                   style: Theme.of(context).primaryTextTheme.headline1,
                                                    //                 ),
                                                    //                 Text(
                                                    //                   (br.getSystemFlagValue(global.systemFlagNameList.useProductSupplierCode) == 'true' && order.orderDetailList[index].product.supplierProductCode != '')
                                                    //                       ? ' ${order.orderDetailList[index].product.supplierProductCode}'
                                                    //                       : ' ${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + order.orderDetailList[index].product.productCode.toString().length))}${order.orderDetailList[index].product.productCode}',
                                                    //                   style: Theme.of(context).primaryTextTheme.headline1,
                                                    //                 )
                                                    //               ],
                                                    //             ),
                                                    //           ),
                                                    //         ),
                                                    //         Align(
                                                    //           alignment: Alignment.centerLeft,
                                                    //           child: Padding(
                                                    //             padding: const EdgeInsets.only(left: 15),
                                                    //             child:
                                                    //              Row(
                                                    //               mainAxisSize: MainAxisSize.min,
                                                    //               children: [
                                                    //                 Container(
                                                    //                   width: 50,
                                                    //                   child: TextFormField(
                                                    //                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                    //                     onChanged: (value) async {
                                                    //                       try {
                                                    //                         order.orderDetailList[index].quantity = (value.length > 0) ? int.parse(value) : 0;
                                                    //                         order.orderDetailList[index].amount = (order.orderDetailList[index].quantity * double.parse(_cUnitPriceList[index].text));
                                                    //                         order.grossAmount = order.orderDetailList.map((orderDetail) => orderDetail.amount).reduce((sum, amount) => sum + amount);
                                                    //                         if (order.id == null) {
                                                    //                           if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
                                                    //                             order.finalTax = 0.0;
                                                    //                             for (int i = 0; i < order.orderTaxList.length; i++) {
                                                    //                               order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
                                                    //                               if (_isTaxApply) {
                                                    //                                 order.finalTax += order.orderTaxList[i].totalAmount;
                                                    //                               }
                                                    //                             }
                                                    //                             order.grossAmount = (_isTaxApply && order.orderTaxList.length > 0) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                                                    //                           } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                    //                             order.finalTax = 0.0;
                                                    //                             order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                                                    //                             order.orderDetailTaxList.clear();
                                                    //                             order.orderDetailList.forEach((orderDetail) {
                                                    //                               _productTaxList.forEach((productTax) {
                                                    //                                 if (orderDetail.productId == productTax.productId) {
                                                    //                                   order.orderTaxList.forEach((orderTax) {
                                                    //                                     if (orderTax.taxId == productTax.taxMasterId) {
                                                    //                                       orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                                                    //                                       SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                                                    //                                       order.orderDetailTaxList.add(_orderDetailTax);
                                                    //                                     }
                                                    //                                   });
                                                    //                                 }
                                                    //                               });
                                                    //                             });
                                                    //                             order.grossAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                                                    //                             order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

                                                    //                             setState(() {});
                                                    //                           } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                                    //                             order.grossAmount = order.grossAmount - order.discount;
                                                    //                           }
                                                    //                         } else {
                                                    //                           if (order.orderTaxList.length != 0 && _orderDetailTaxLen == 0) {
                                                    //                             order.finalTax = 0.0;
                                                    //                             for (int i = 0; i < order.orderTaxList.length; i++) {
                                                    //                               order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
                                                    //                               if (_isTaxApply) {
                                                    //                                 order.finalTax += order.orderTaxList[i].totalAmount;
                                                    //                               }
                                                    //                             }
                                                    //                             order.grossAmount = (_isTaxApply && order.orderTaxList.length > 0) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                                                    //                           } else if (order.orderTaxList.length != 0 && _orderDetailTaxLen != 0) {
                                                    //                             order.finalTax = 0.0;
                                                    //                             order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                                                    //                             order.orderDetailTaxList.clear();
                                                    //                             if (_productTaxList.length == 0) {
                                                    //                               _productTaxList = await dbHelper.productTaxGetList(productIdList: order.orderDetailList.map((orderDetail) => orderDetail.productId).toList());
                                                    //                             }
                                                    //                             order.orderDetailList.forEach((orderDetail) {
                                                    //                               _productTaxList.forEach((productTax) {
                                                    //                                 if (orderDetail.productId == productTax.productId) {
                                                    //                                   order.orderTaxList.forEach((orderTax) {
                                                    //                                     if (orderTax.taxId == productTax.taxMasterId) {
                                                    //                                       orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                                                    //                                       SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                                                    //                                       order.orderDetailTaxList.add(_orderDetailTax);
                                                    //                                     }
                                                    //                                   });
                                                    //                                 }
                                                    //                               });
                                                    //                             });
                                                    //                             order.grossAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                                                    //                             order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

                                                    //                             setState(() {});
                                                    //                           } else if (_isTaxApply == false) {
                                                    //                             order.grossAmount = order.grossAmount - order.discount;
                                                    //                           }
                                                    //                         }
                                                    //                         _calculate();
                                                    //                         setState(() {});
                                                    //                       } catch (e) {
                                                    //                         print('Exception - saleOrderAddScreen.dart - Qty_onChanged: ' + e.toString());
                                                    //                       }
                                                    //                     },
                                                    //                     keyboardType:  TextInputType.numberWithOptions(decimal: true),
                                                    //                     maxLength: 3,
                                                    //                     textAlign: TextAlign.center,
                                                    //                     controller: _cQtyList[index],
                                                    //                     //    readOnly: (order.id != null && DateTime.now().difference(order.createdAt).inDays != 0) ? true : false,
                                                    //                     decoration: InputDecoration(
                                                    //                       focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4e2eb5))),
                                                    //                       enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                                                    //                       errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                    //                       disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[700])),
                                                    //                       border: UnderlineInputBorder(borderSide: BorderSide(width: 0.2)),
                                                    //                       counterText: '',
                                                    //                       labelText: global.appLocaleValues['lbl_qty'],
                                                    //                     ),
                                                    //                     validator: (v) {
                                                    //                       if (v.isEmpty) {
                                                    //                         return '';
                                                    //                       } else if (v.contains(RegExp('[a-zA-Z]'))) {
                                                    //                         return global.appLocaleValues['vel_enter_number_only'];
                                                    //                       }
                                                    //                       return null;
                                                    //                     },
                                                    //                   ),
                                                    //                 ),
                                                    //                 (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                                    //                     ? SizedBox(
                                                    //                         width: 10,
                                                    //                       )
                                                    //                     : SizedBox(),
                                                    //                 (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                                    //                     ? Container(
                                                    //                         width: 55,
                                                    //                         child: TextFormField(
                                                    //                           readOnly: true,
                                                    //                           controller: _cUnitList[index],
                                                    //                           decoration: InputDecoration(
                                                    //                             focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4e2eb5))),
                                                    //                             enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                                                    //                             errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                    //                             disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[700])),
                                                    //                             border: UnderlineInputBorder(borderSide: BorderSide(width: 0.2)),
                                                    //                             labelText: global.appLocaleValues['lbl_unit'],
                                                    //                           ),
                                                    //                           onTap: () async {
                                                    //                             await _selectUnit(index);
                                                    //                           },
                                                    //                         ),
                                                    //                       )
                                                    //                     : SizedBox(),
                                                    //                 SizedBox(
                                                    //                   width: 0,
                                                    //                 ),
                                                    //                 Padding(
                                                    //                   padding: const EdgeInsets.only(top: 15),
                                                    //                   child: Text(
                                                    //                     ' X ',
                                                    //                     style: Theme.of(context).primaryTextTheme.headline5,
                                                    //                     textAlign: TextAlign.justify,
                                                    //                   ),
                                                    //                 ),
                                                    //                 SizedBox(
                                                    //                   width: 0,
                                                    //                 ),
                                                    //                 Container(
                                                    //                   width: 70,
                                                    //                   //  height: MediaQuery.of(context).size.height / 0.9,
                                                    //                   child: TextFormField(
                                                    //                     //    readOnly: (order.id != null && DateTime.now().difference(order.createdAt).inDays != 0) ? true : false,
                                                    //                     controller: _cUnitPriceList[index],
                                                    //                     textAlign: TextAlign.justify,
                                                    //                     //   style: TextStyle(height: 1),
                                                    //                     decoration: InputDecoration(
                                                    //                       focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4e2eb5))),
                                                    //                       enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                                                    //                       errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                    //                       disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[700])),
                                                    //                       border: UnderlineInputBorder(borderSide: BorderSide(width: 0.2)),
                                                    //                       labelText: global.appLocaleValues['lbl_price'],
                                                    //                       counterText: '',
                                                    //                     ),
                                                    //                     onChanged: (value) async {
                                                    //                       try {
                                                    //                         order.orderDetailList[index].unitPrice = (value.length > 0) ? double.parse(value) : 0;
                                                    //                         if (order.orderDetailList[index].product.productPriceList[0].unitId == order.orderDetailList[index].unitId) {
                                                    //                           // if product unit and sold unit is same
                                                    //                           order.orderDetailList[index].amount = order.orderDetailList[index].unitPrice * order.orderDetailList[index].quantity;
                                                    //                         } else {
                                                    //                           UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == order.orderDetailList[index].product.unitCombinationId);
                                                    //                           if (order.orderDetailList[index].unitId == _unitCombination.primaryUnitId) // if parent unit is selected
                                                    //                           {
                                                    //                             if (_unitCombination.primaryUnitId == order.orderDetailList[index].product.productPriceList[0].unitId) {
                                                    //                               order.orderDetailList[index].amount = order.orderDetailList[index].unitPrice * order.orderDetailList[index].quantity;
                                                    //                             } else {
                                                    //                               order.orderDetailList[index].amount = (order.orderDetailList[index].unitPrice * _unitCombination.measurement) * order.orderDetailList[index].quantity;
                                                    //                             }
                                                    //                             order.orderDetailList[index].amount = order.orderDetailList[index].quantity * order.orderDetailList[index].unitPrice;
                                                    //                           } else // if child unit is selected
                                                    //                           {
                                                    //                             if (_unitCombination.secondaryUnitId == order.orderDetailList[index].product.productPriceList[0].unitId) {
                                                    //                               order.orderDetailList[index].amount = order.orderDetailList[index].unitPrice * order.orderDetailList[index].quantity;
                                                    //                             } else {
                                                    //                               order.orderDetailList[index].amount = order.orderDetailList[index].unitPrice;
                                                    //                             }
                                                    //                           }
                                                    //                         }

                                                    //                         order.grossAmount = order.orderDetailList.map((orderDetail) => orderDetail.amount).reduce((sum, amount) => sum + amount);
                                                    //                         if (order.id == null) {
                                                    //                           if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
                                                    //                             order.finalTax = 0.0;
                                                    //                             for (int i = 0; i < order.orderTaxList.length; i++) {
                                                    //                               order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
                                                    //                               if (_isTaxApply) {
                                                    //                                 order.finalTax += order.orderTaxList[i].totalAmount;
                                                    //                               }
                                                    //                             }
                                                    //                             order.grossAmount = (_isTaxApply && order.orderTaxList.length > 0) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                                                    //                           } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                    //                             order.finalTax = 0.0;
                                                    //                             order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                                                    //                             order.orderDetailTaxList.clear();
                                                    //                             order.orderDetailList.forEach((orderDetail) {
                                                    //                               _productTaxList.forEach((productTax) {
                                                    //                                 if (orderDetail.productId == productTax.productId) {
                                                    //                                   order.orderTaxList.forEach((orderTax) {
                                                    //                                     if (orderTax.taxId == productTax.taxMasterId) {
                                                    //                                       orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                                                    //                                       SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                                                    //                                       order.orderDetailTaxList.add(_orderDetailTax);
                                                    //                                     }
                                                    //                                   });
                                                    //                                 }
                                                    //                               });
                                                    //                             });
                                                    //                             order.grossAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                                                    //                             order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

                                                    //                             setState(() {});
                                                    //                           } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                                                    //                             order.grossAmount = order.grossAmount - order.discount;
                                                    //                           }
                                                    //                         } else {
                                                    //                           if (order.orderTaxList.length != 0 && _orderDetailTaxLen == 0) {
                                                    //                             order.finalTax = 0.0;
                                                    //                             for (int i = 0; i < order.orderTaxList.length; i++) {
                                                    //                               order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
                                                    //                               if (_isTaxApply) {
                                                    //                                 order.finalTax += order.orderTaxList[i].totalAmount;
                                                    //                               }
                                                    //                             }
                                                    //                             order.grossAmount = (_isTaxApply && order.orderTaxList.length > 0) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                                                    //                           } else if (order.orderTaxList.length != 0 && _orderDetailTaxLen != 0) {
                                                    //                             order.finalTax = 0.0;
                                                    //                             order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                                                    //                             order.orderDetailTaxList.clear();
                                                    //                             if (_productTaxList.length == 0) {
                                                    //                               _productTaxList = await dbHelper.productTaxGetList(productIdList: order.orderDetailList.map((orderDetail) => orderDetail.productId).toList());
                                                    //                             }
                                                    //                             order.orderDetailList.forEach((orderDetail) {
                                                    //                               _productTaxList.forEach((productTax) {
                                                    //                                 if (orderDetail.productId == productTax.productId) {
                                                    //                                   order.orderTaxList.forEach((orderTax) {
                                                    //                                     if (orderTax.taxId == productTax.taxMasterId) {
                                                    //                                       orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                                                    //                                       SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                                                    //                                       order.orderDetailTaxList.add(_orderDetailTax);
                                                    //                                     }
                                                    //                                   });
                                                    //                                 }
                                                    //                               });
                                                    //                             });
                                                    //                             order.grossAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                                                    //                             order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
                                                    //                             setState(() {});
                                                    //                           } else if (_isTaxApply == false) {
                                                    //                             order.grossAmount = order.grossAmount - order.discount;
                                                    //                           }
                                                    //                         }
                                                    //                         _calculate();
                                                    //                         setState(() {});
                                                    //                       } catch (e) {
                                                    //                         print('Exception - saleOrderAddScreen.dart - UP_onChanged: ' + e.toString());
                                                    //                       }
                                                    //                     },
                                                    //                     validator: (v) {
                                                    //                       if (v.isEmpty) {
                                                    //                         return '';
                                                    //                       } else if (v == '0') {
                                                    //                         return '';
                                                    //                       } else if (v.contains(RegExp('[a-zA-Z]'))) {
                                                    //                         return global.appLocaleValues['vel_enter_number_only'];
                                                    //                       }
                                                    //                       return null;
                                                    //                     },
                                                    //                     inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                                                    //                     keyboardType:  TextInputType.numberWithOptions(decimal: true),
                                                    //                   ),
                                                    //                 ),
                                                    //                 Padding(
                                                    //                     padding: EdgeInsets.only(left: 10),
                                                    //                     child: Text(
                                                    //                       '= ${global.currency.symbol} ${order.orderDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                    //                       style: Theme.of(context).primaryTextTheme.headline2,
                                                    //                     )),
                                                    //               ],
                                                    //             ),

                                                    //           ),
                                                    //         )
                                                    //       ],
                                                    //     )),
                                                    //   ],
                                                    // ),
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
                                        title: Text('${global.appLocaleValues['lbl_sub_total']}', style: Theme.of(context).primaryTextTheme.headline6),
                                        trailing: Text('${global.currency.symbol} ${order.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: Theme.of(context).primaryTextTheme.headline3)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                      child: Divider(),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10, right: 10),
                                      child: ListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          title: Text('${global.appLocaleValues['lbl_discount']}', textAlign: TextAlign.start, style: Theme.of(context).primaryTextTheme.headline6),
                                          trailing: Container(
                                            width: MediaQuery.of(context).size.width / 2,
                                            child: TextFormField(
                                              inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                                              maxLength: 5,
                                              onChanged: (value) {
                                                order.discount = (value.length > 0) ? double.parse(value) : 0;
                                                if (order.id == null) {
                                                  if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false' || order.orderDetailList.length < 1)) {
                                                    order.finalTax = 0.0;
                                                    for (int i = 0; i < order.orderTaxList.length; i++) {
                                                      order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
                                                      if (_isTaxApply) {
                                                        order.finalTax += order.orderTaxList[i].totalAmount;
                                                      }
                                                    }
                                                    order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                                                  } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                                                    order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                                                  } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == '') {
                                                    //'false') {
                                                    order.netAmount = order.grossAmount - order.discount;
                                                  }
                                                } else {
                                                  if (order.orderTaxList.length != 0 && order.orderDetailTaxList.length == 0) {
                                                    order.finalTax = 0.0;
                                                    for (int i = 0; i < order.orderTaxList.length; i++) {
                                                      order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
                                                      if (_isTaxApply) {
                                                        order.finalTax += order.orderTaxList[i].totalAmount;
                                                      }
                                                    }
                                                    order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                                                  } else if (order.orderTaxList.length != 0 && order.orderDetailTaxList.length != 0) {
                                                    order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                                                  } else if (_isTaxApply == false) {
                                                    order.netAmount = order.grossAmount - order.discount;
                                                  }
                                                }
                                                _calculate();
                                                setState(() {});
                                              },
                                              textInputAction: TextInputAction.next,
                                              controller: _cDiscount,
                                              textAlign: TextAlign.end,
                                              style: Theme.of(context).primaryTextTheme.headline3,
                                              //  readOnly: (order.id != null && DateTime.now().difference(order.createdAt).inDays != 0) ? true : false,
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
                                    // (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' || order.orderTaxList.length > 0)
                                    //     ? Padding(
                                    //         padding: const EdgeInsets.only(left: 10, right: 10),
                                    //         child: Divider(),
                                    //       )
                                    //     : SizedBox(),
                                    (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true')
                                        ? SizedBox(
                                            height: 40,
                                            child: ListTile(
                                              title: Text(global.appLocaleValues['lbl_apply_tax'], style: Theme.of(context).primaryTextTheme.headline6),
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
                                                itemCount: order.orderTaxList.length,
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return SizedBox(
                                                    height: 40,
                                                    child: ListTile(
                                                        title: (order.id == null)
                                                            ? (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false')
                                                                ? Text(
                                                                    '${order.orderTaxList[index].taxName} (${order.orderTaxList[index].percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%)',
                                                                    style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                  )
                                                                : Text(
                                                                    '${order.orderTaxList[index].taxName}',
                                                                    style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                  )
                                                            : (_isTaxApply == true && order.orderDetailTaxList.length == 0)
                                                                ? Text(
                                                                    '${order.orderTaxList[index].taxName} (${order.orderTaxList[index].percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%)',
                                                                    style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                  )
                                                                : Text(
                                                                    '${order.orderTaxList[index].taxName}',
                                                                    style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                  ),
                                                        trailing: Text(
                                                          '${global.currency.symbol} ${order.orderTaxList[index].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                                          trailing: Text('${global.currency.symbol} ${order.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: Theme.of(context).primaryTextTheme.headline5)),
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
                                      child: Text('${global.appLocaleValues['btn_add_payment']}', style: Theme.of(context).primaryTextTheme.headline2),
                                      onPressed: () async {
                                        await _addPaymentMethod();
                                      },
                                    ),
                                    SingleChildScrollView(
                                      child: Container(
                                          // width: 500,
                                          child: Column(
                                        children: <Widget>[
                                          ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: order.payment.paymentDetailList.length,
                                            itemBuilder: (context, index) {
                                              return (!order.payment.paymentDetailList[index].deletedFromScreen)
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
                                                                if (order.id == null) {
                                                                  order.payment.paymentDetailList.removeAt(index);
                                                                } else {
                                                                  order.payment.paymentDetailList[index].deletedFromScreen = true;
                                                                }
                                                                _calculate();
                                                                setState(() {});
                                                              } catch (e) {
                                                                print('Exception - saleOrderAddScreen.dart - _onDeletePayment(): ' + e.toString());
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
                                                                    order.payment.paymentDetailList[index].isEdited = true;
                                                                    await showDialog(
                                                                        context: context,
                                                                        builder: (_) {
                                                                          return PaymentAddDialog(
                                                                            remainAmountToPay: double.parse((_totalDue + order.payment.paymentDetailList[index].amount).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))),
                                                                            paymentDetailEdit: order.payment.paymentDetailList[index],
                                                                          );
                                                                        }).then((value) {
                                                                      if (value != null) {
                                                                        order.payment.paymentDetailList.insert(index, value);
                                                                        order.payment.paymentDetailList.removeAt(index + 1);
                                                                        _calculate();
                                                                        setState(() {});
                                                                      }
                                                                    });
                                                                  } catch (e) {
                                                                    print('Exception - saleOrderAddScreen.dart - _onEditPayment(): ' + e.toString());
                                                                  }
                                                                },
                                                                title: Text(
                                                                  '${order.payment.paymentDetailList[index].paymentMode}',
                                                                  style: TextStyle(color: Colors.grey, fontSize: 17),
                                                                ),
                                                                subtitle: (order.payment.paymentDetailList[index].remark.isNotEmpty) ? Text('${order.payment.paymentDetailList[index].remark}') : null,
                                                                trailing: Text(
                                                                  '${global.currency.symbol} ${order.payment.paymentDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                                  style: TextStyle(fontSize: 17),
                                                                )),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : SizedBox();
                                            },
                                          ),
                                          (order.payment.paymentDetailList.length > 0)
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10),
                                  child: Text("${global.appLocaleValues['lbl_note_remark']} (${global.appLocaleValues['lbl_optional']})", style: Theme.of(context).primaryTextTheme.headline3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
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

  Future _generateOrder() async {
    try {
      await _generateOrderNumber();
      order.finalTax = 0;
      _isTaxApply = (order.saleQuoteList[0].quoteTaxList != null && order.saleQuoteList[0].quoteTaxList.length != 0) ? true : false;
      order.grossAmount = order.orderDetailList.map((e) => e.amount).reduce((value, element) => element + value);
      if (order.saleQuoteList[0].quoteTaxList != null && order.saleQuoteList[0].quoteTaxList.length > 0 && order.saleQuoteList[0].quoteDetailTaxList.length < 1) {
        for (int i = 0; i < order.orderTaxList.length; i++) {
          order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
          if (_isTaxApply) {
            order.finalTax += order.orderTaxList[i].totalAmount;
          }
        }
        order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
      } else if (order.saleQuoteList[0].quoteTaxList != null && order.saleQuoteList[0].quoteTaxList.length > 0 && order.saleQuoteList[0].quoteDetailTaxList.length > 0) {
        order.orderTaxList.map((invoiceTax) => invoiceTax.totalAmount = 0.0).toList();
        _productTaxList = await dbHelper.productTaxGetList(productIdList: order.orderDetailList.map((invoiceDetail) => invoiceDetail.productId).toList());
        order.orderDetailList.forEach((invoiceDetail) {
          _productTaxList.forEach((productTax) {
            if (invoiceDetail.productId == productTax.productId) {
              order.orderTaxList.forEach((invoiceTax) {
                if (invoiceTax.taxId == productTax.taxMasterId) {
                  invoiceTax.totalAmount += (invoiceDetail.amount * productTax.percentage) / 100;
                  SaleOrderDetailTax _invoiceDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (invoiceDetail.amount * productTax.percentage) / 100);
                  order.orderDetailTaxList.add(_invoiceDetailTax);
                }
              });
            }
          });
        });
        order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((invoiceDetailTax) => invoiceDetailTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
        order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((invoiceTax) => invoiceTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
        setState(() {});
      } else if (order.saleQuoteList[0].quoteTaxList == null || order.saleQuoteList[0].quoteTaxList.length == 0) {
        order.netAmount = order.grossAmount - order.discount;
      }
      _selectedTaxGroup = (order.taxGroup == "GST") ? 0 : 1;
      if (order.orderDate != null) {
        _cOrderDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(order.orderDate);
        _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(order.deliveryDate);
        _orderDate2 = order.orderDate.toString();
        _deliveryDate2 = order.deliveryDate.toString();
      } else {
        _cOrderDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _orderDate2 = DateTime.now().toString().substring(0, 10);
        _deliveryDate2 = DateTime.now().toString().substring(0, 10);
      }
      _timeOfDay = TimeOfDay(hour: order.deliveryDate.hour, minute: order.deliveryDate.minute);
      String time = br.formatTimeOfDay(_timeOfDay);
      _showRemarkInPrint = order.showRemarkInPrint;
      _cDeliveryTime.text = time;

      _cRemark.text = order.remark;
      List<Product> _productList = await dbHelper.productGetList(productId: order.orderDetailList.map((item) => item.productId).toList());
      for (int i = 0; i < order.orderDetailList.length; i++) {
        _cQtyList.add(TextEditingController(text: order.orderDetailList[i].quantity.toString()));
        _cUnitPriceList.add(TextEditingController(text: order.orderDetailList[i].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString()));
        for (int j = 0; j < _productList.length; j++) {
          if (_productList[j].id == order.orderDetailList[i].productId) {
            _productList[j].productPriceList = await dbHelper.productPriceGetList(_productList[j].id);
            order.orderDetailList[i].product = _productList[j];
            if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
              UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == _productList[j].unitCombinationId);
              order.orderDetailList[i].product.unitList.add(_unitList.firstWhere((element) => element.id == _unitCombination.primaryUnitId));
              if (_unitCombination.secondaryUnitId != null) {
                order.orderDetailList[i].product.unitList.add(_unitList.firstWhere((element) => element.id == _unitCombination.secondaryUnitId));
              }
            }
          }
        }
        if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
          _cUnitList.add(TextEditingController(text: '${order.orderDetailList[i].product.unitList.firstWhere((element) => element.id == order.orderDetailList[i].unitId).code}'));
        }
      }
      _isTaxApply = (order.orderTaxList != null && order.orderTaxList.length != 0) ? true : false;
      _orderDetailTaxIdList = order.orderDetailTaxList.map((e) => e.id).toList();
      _orderDetailTaxLen = order.orderDetailTaxList.length;
      _cAccountId.text = '${order.account.firstName} ${order.account.lastName}';
      //     '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + invoice.account.accountCode.toString().length))}${invoice.account.accountCode} - ${invoice.account.firstName} ${invoice.account.lastName}';
      _cDiscount.text = order.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _cNetAmount.text = order.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _isComplete = order.isComplete;
      _showRemarkInPrint = order.showRemarkInPrint;
      _cVoucherNumber.text = order.voucherNumber;

      _calculate();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - saleInvoiceAddScreen.dart - _generateOrder(): ' + e.toString());
    }
  }

  Future _getData() async {
    try {
      _fOrderDate.addListener(_focusListener);
      _fDeliveryDate.addListener(_focusListener);
      _fDiscount.addListener(_discountListener);
      _fNetAmount.addListener(_netAmountListener);
      _unitList = await dbHelper.unitGetList();
      _unitCombinationList = await dbHelper.unitCombinationGetList();
      if (order.id != null) {
        await _getDetailForUpdateOrder();
      } else if (screenId != null) {
        await _generateOrder();
      } else {
        order = SaleOrder();
        order.payment = Payment();
        if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true') {
          _isTaxApply = true;
          await _getTaxes();
        } else {
          _isTaxApply = false;
        }
        //   _cTax.text = '0.0';
        order.finalTax = 0.0;
        order.discount = 0.0;
        _cDiscount.text = order.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        //    _cGrossAmount.text = '0.0';
        order.netAmount = 0.0;
        //     _cNetAmount.text = '0.0';
        order.grossAmount = 0.0;
        _cNetAmount.text = order.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        _generateOrderNumber();
        _cOrderDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _orderDate2 = DateTime.now().toString().substring(0, 10);
        _deliveryDate2 = DateTime.now().toString();
        _cDeliveryTime.text = '9:00 AM';
        _isDataLoaded = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - saleOrderAddScreen.dart - _getData(): ' + e.toString());
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
      print('Exception - saleOrderAddScreen.dart - _accountListener(): ' + e.toString());
    }
  }

  Future _addPaymentMethod() async {
    try {
      if (order.netAmount != null) {
        //   _remainAmount = (order.payment.paymentDetailList.length != 0) ? order.grossAmount - order.payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount) : order.grossAmount;
        if (order.grossAmount != 0) {
          if (_totalDue > 0) {
            await showDialog(
                context: context,
                builder: (_) {
                  return PaymentAddDialog(
                    remainAmountToPay: double.parse(_totalDue.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))),
                    paymentDetail: (object) {
                      order.payment.paymentDetailList.add(object);
                      order.payment.paymentDetailList[order.payment.paymentDetailList.length - 1].isRecentlyAdded = (order.id != null) ? true : false;
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
                  ? global.appLocaleValues['lbl_err_vld_payment_pro_']
                  : br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service'
                      ? global.appLocaleValues['lbl_err_vld_payment_ser_']
                      : global.appLocaleValues['lbl_err_vld_payment_both_']))));
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
      print('Exception - saleOrderAddScreen.dart - _addPaymentMethod(): ' + e.toString());
    }
  }

  Future _addProducts() async {
    try {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductSelectDialog(
              a: widget.analytics,
              o: widget.observer,
              selectedProducts: order.orderDetailList.map((order) => order.product).toList(),
              returnScreenId: 0,
              onValueSelected: (product) async {
                // order.orderDetailList.clear();
                if (order.id == null) {
                  order.orderDetailTaxList.clear();
                }
                //  _cUnitPriceList.clear();
                //  _cQtyList.clear();
                //   _cUnitList.clear();
                //   order.grossAmount = 0;
                //  _remainAmount = 0;
                product.forEach((item) {
                  SaleOrderDetail orderDetail = SaleOrderDetail(null, null, item.id, item.productPriceList[0].unitId, item.productPriceList[0].unitId, _unitList.firstWhere((element) => element.id == item.productPriceList[0].unitId).code, 1, 0, item.productPriceList[0].price,
                      item.productPriceList[0].price, item.name, item.productCode, item.productTypeName, item.productPriceList[0].price, false, null, null, item.description);
                  orderDetail.product = item;
                  order.orderDetailList.add(orderDetail);
                  _cUnitPriceList.add(TextEditingController(text: '${orderDetail.unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'));
                  _cQtyList.add(TextEditingController(text: '${orderDetail.quantity}'));
                  if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
                    _cUnitList.add(TextEditingController(text: '${_unitList.firstWhere((element) => element.id == orderDetail.product.productPriceList[0].unitId).code}'));
                  }
                  order.grossAmount += item.productPriceList[0].price;
                });
                if (order.id == null) {
                  if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
                    //    order.finalTax = 0.0;
                    for (int i = 0; i < order.orderTaxList.length; i++) {
                      order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
                      if (_isTaxApply) {
                        order.finalTax += order.orderTaxList[i].totalAmount;
                      }
                    }
                    order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                  } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
                    //  order.finalTax = 0.0;
                    order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                    _productTaxList = await dbHelper.productTaxGetList(productIdList: order.orderDetailList.map((orderDetail) => orderDetail.productId).toList());

                    order.orderDetailList.forEach((orderDetail) {
                      _productTaxList.forEach((productTax) {
                        if (orderDetail.productId == productTax.productId) {
                          order.orderTaxList.forEach((orderTax) {
                            if (orderTax.taxId == productTax.taxMasterId) {
                              orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                              SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.amount * productTax.percentage) / 100);
                              order.orderDetailTaxList.add(_orderDetailTax);
                            }
                          });
                        }
                      });
                    });
                    // print('orderDTax: ${order.orderDetailTaxList.map((e) => e.taxAmount).reduce((value, element) => value + element)}');
                    order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderDetailTax) => orderDetailTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                    order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
                    setState(() {});
                  } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
                    order.netAmount = order.grossAmount - order.discount;
                  }
                } else {
                  if (order.orderTaxList.length != 0 && order.orderDetailTaxList.length == 0) {
                    //  order.finalTax = 0.0;
                    for (int i = 0; i < order.orderTaxList.length; i++) {
                      order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
                      if (_isTaxApply) {
                        order.finalTax += order.orderTaxList[i].totalAmount;
                      }
                    }
                    order.netAmount = (_isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                  } else if (order.orderTaxList.length != 0 && order.orderDetailTaxList.length != 0) {
                    //   order.finalTax = 0.0;
                    order.orderDetailTaxList.clear();
                    order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
                    _productTaxList = await dbHelper.productTaxGetList(productIdList: order.orderDetailList.map((orderDetail) => orderDetail.productId).toList());

                    order.orderDetailList.forEach((orderDetail) {
                      _productTaxList.forEach((productTax) {
                        if (orderDetail.productId == productTax.productId) {
                          order.orderTaxList.forEach((orderTax) {
                            if (orderTax.taxId == productTax.taxMasterId) {
                              orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                              SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.amount * productTax.percentage) / 100);
                              order.orderDetailTaxList.add(_orderDetailTax);
                            }
                          });
                        }
                      });
                    });
                    order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
                    order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
                    setState(() {});
                  } else if (_isTaxApply == false) {
                    order.netAmount = order.grossAmount - order.discount;
                  }
                }
                _calculate();
              })));

      setState(() {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    } catch (e) {
      print('Exception - saleOrderAddScreen.dart - _addProducts(): ' + e.toString());
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
      print('Exception - saleOrderAddScreen.dart - _focusListener(): ' + e.toString());
    }
  }

  Future _generateOrderNumber() async {
    try {
      order.saleOrderNumber = await dbHelper.saleOrderGetNewOrderNumber();
      _generatedOrderNo = '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${order.saleOrderNumber}';
      _generatedOrderNo = '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}' + '${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - _generatedOrderNo.length)}' + '${order.saleOrderNumber}';
      _cOrderNumber.text = _generatedOrderNo;
      setState(() {});
    } catch (e) {
      print('Exception - saleOrderAddScreen.dart - _generateOrderNumber(): ' + e.toString());
    }
  }

  Future _getDetailForUpdateOrder() async {
    try {
      order.orderDetailList = await dbHelper.saleOrderDetailGetList(
        orderIdList: [order.id],
      );
      _selectedTaxGroup = (order.taxGroup == "GST") ? 0 : 1;
      // _generatedOrderNo = '${order.saleOrderNumber}';
      _generatedOrderNo = '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${order.saleOrderNumber}';
      _generatedOrderNo = '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}' + '${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - _generatedOrderNo.length)}' + '${order.saleOrderNumber}';
      _cOrderNumber.text = _generatedOrderNo;
      _cOrderDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(order.orderDate);
      _cDeliveryDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(order.deliveryDate);
      _orderDate2 = order.orderDate.toString();
      _deliveryDate2 = order.deliveryDate.toString();
      _timeOfDay = TimeOfDay(hour: order.deliveryDate.hour, minute: order.deliveryDate.minute);
      String time = br.formatTimeOfDay(_timeOfDay);
      _showRemarkInPrint = order.showRemarkInPrint;
      _cDeliveryTime.text = time;
      _cRemark.text = order.remark;
      List<Product> _productList = await dbHelper.productGetList(productId: order.orderDetailList.map((item) => item.productId).toList());
      for (int i = 0; i < order.orderDetailList.length; i++) {
        _cQtyList.add(TextEditingController(text: order.orderDetailList[i].quantity.toString()));
        _cUnitPriceList.add(TextEditingController(text: order.orderDetailList[i].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString()));
        for (int j = 0; j < _productList.length; j++) {
          if (_productList[j].id == order.orderDetailList[i].productId) {
            _productList[j].productPriceList = await dbHelper.productPriceGetList(_productList[j].id);
            order.orderDetailList[i].product = _productList[j];
            if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
              UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == _productList[j].unitCombinationId);
              order.orderDetailList[i].product.unitList.add(_unitList.firstWhere((element) => element.id == _unitCombination.primaryUnitId));
              if (_unitCombination.secondaryUnitId != null) {
                order.orderDetailList[i].product.unitList.add(_unitList.firstWhere((element) => element.id == _unitCombination.secondaryUnitId));
              }
            }
          }
        }
        if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
          _cUnitList.add(TextEditingController(text: '${order.orderDetailList[i].product.unitList.firstWhere((element) => element.id == order.orderDetailList[i].unitId).code}'));
        }
      }
      List<PaymentSaleOrder> _paymentIrderList = await dbHelper.paymentSaleOrderGetList(orderIdList: [order.id], isCancel: false);
      List<PaymentDetail> _paymentDetailList = (_paymentIrderList.length != 0) ? await dbHelper.paymentDetailGetList(paymentIdList: _paymentIrderList.map((paymentDetail) => paymentDetail.paymentId).toList()) : null;
      order.payment.paymentDetailList = (_paymentDetailList != null)
          ? (_paymentDetailList.length != 0)
              ? _paymentDetailList
              : []
          : [];

      order.orderTaxList = await dbHelper.saleOrderTaxGetList(saleOrderId: order.id);
      _isTaxApply = (order.orderTaxList.length != 0) ? true : false;
      order.orderDetailTaxList = await dbHelper.saleOrderDetailTaxGetList(orderDetailIdList: order.orderDetailList.map((orderDetail) => orderDetail.id).toList());
      _orderDetailTaxIdList = order.orderDetailTaxList.map((e) => e.id).toList();
      _orderDetailTaxLen = order.orderDetailTaxList.length;
      _cAccountId.text = '${order.account.firstName} ${order.account.lastName}';
      //     '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + order.account.accountCode.toString().length))}${order.account.accountCode} - ${order.account.firstName} ${order.account.lastName}';
      _cDiscount.text = order.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _cNetAmount.text = order.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _isComplete = order.isComplete;
      _cVoucherNumber.text = order.voucherNumber;
      _calculate();
      _isDataLoaded = true;
      _tempSaleOrder = order;
      setState(() {});
    } catch (e) {
      print('Exception - saleOrderAddScreen.dart - _getDetailForUpdateOrder(): ' + e.toString());
    }
  }

  void _calculate() {
    double _paid = 0;
    order.payment.paymentDetailList.forEach((element) {
      if (!element.deletedFromScreen) {
        _paid += element.amount;
      }
    });
    _totalPaid = _paid;
    _totalDue = order.netAmount - _totalPaid;
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
      print('Exception - saleOrderAddscreen.dart - showAlertd(): ' + e.toString());
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
        _saleQuoteList[i].status = (_isInvoicedOrder == 0) ? 'ORDERED' : 'OPEN';
        await dbHelper.saleQuoteUpdate(quote: _saleQuoteList[i], updateFrom: 2);
      }
    } catch (e) {
      print('Exception - saleInvoiceAddScreen.dart - _updateSaleQuote(): ' + e.toString());
    }
  }

  Future _onSubmit() async {
    try {
      if (_formKey.currentState.validate()) {
        if (order.orderDetailList.length > 0) {
          if (order.netAmount > 0) {
            List<SaleOrderDetail> _tempSaleOrderDetailList = [];
            if (order.saleQuoteList.length > 0) {
              _tempSaleOrderDetailList = await dbHelper.saleOrderDetailGetList(orderIdList: [order.id]);
            }
            showLoader(global.appLocaleValues['txt_wait']);
            setState(() {});
            order.accountId = (_account != null) ? _account.id : order.accountId;
            order.orderDate = DateTime.parse(_orderDate2);
            order.deliveryDate = DateTime.parse(_deliveryDate2);
            order.deliveryDate = DateTime(order.deliveryDate.year, order.deliveryDate.month, order.deliveryDate.day, _timeOfDay.hour, _timeOfDay.minute);
            print('date: ${order.deliveryDate}');
            order.isComplete = _isComplete;
            if (order.finalTax > 0) {
              order.taxGroup = (_selectedTaxGroup == 0) ? "GST" : "IGST";
            }
            order.voucherNumber = _cVoucherNumber.text.trim();
            order.showRemarkInPrint = _showRemarkInPrint;
            order.remark = _cRemark.text.trim();
            if (order.id == null) {
              order.status = "OPEN";
              List<SaleQuote> _saleQuoteList = order.saleQuoteList.toList();
              order = await dbHelper.saleOrderInsert(order, _isTaxApply);
              if (order.id != null && _saleQuoteList.length > 0) {
                order.orderDetailList.forEach((invoiceDetail) {
                  _saleQuoteList[0].quoteDetailList.forEach((orderDetail) async {
                    if (invoiceDetail.productId == orderDetail.productId) {
                      orderDetail.invoicedQuantity += invoiceDetail.quantity;
                    }
                    await dbHelper.saleQuoteDetailUpdate(orderDetail);
                  });
                });

                await _updateSaleQuote(_saleQuoteList);
              }
            } else {
              List<SaleQuote> _saleQuoteList = order.saleQuoteList.toList();
              await dbHelper.saleOrderDetailTaxDelete(orderDetailTaxIdList: _orderDetailTaxIdList);
              await dbHelper.saleOrderTaxDelete(order.id);
              if (order.status != 'CANCELLED') {
                bool _isSame = true;
                order.orderDetailList.forEach((element) {
                  if (element.quantity != element.invoicedQuantity) {
                    _isSame = false;
                  }
                });
                order.status = (_isSame) ? "INVOICED" : "OPEN";
              }
              order = await dbHelper.saleOrderUpdate(order: order, updateFrom: 1, isTaxApplied: _isTaxApply, isAccountChanged: _accountChanged);
              if (order.saleQuoteList.length > 0) // if any sale invoice attached with this invoice
              {
                for (int i = 0; i < _tempSaleOrderDetailList.length; i++) {
                  bool _exist = _saleQuoteList[0].quoteDetailList.map((e) => e.productId).contains(_tempSaleOrderDetailList[i].productId);
                  if (_exist) // if product exist in saleOrderDetail
                  {
                    bool _isExist = order.orderDetailList.map((e) => e.productId).contains(_tempSaleOrderDetailList[i].productId);
                    if (_isExist) {
                      // if product is not deleted during update
                      double _latestQty = order.orderDetailList.firstWhere((element) => element.productId == _tempSaleOrderDetailList[i].productId).quantity;
                      if (_latestQty != _tempSaleOrderDetailList[i].quantity) // if qty is not same
                      {
                        _saleQuoteList[0].quoteDetailList.forEach((element) async {
                          if (element.productId == _tempSaleOrderDetailList[i].productId) {
                            if (_latestQty < _tempSaleOrderDetailList[i].quantity) // if qty is lesser than previous
                            {
                              double _a = _tempSaleOrderDetailList[i].quantity - _latestQty;
                              element.invoicedQuantity = element.invoicedQuantity - _a;
                            } else {
                              double _a = _latestQty - _tempSaleOrderDetailList[i].quantity;
                              element.invoicedQuantity = element.invoicedQuantity + _a;
                            }
                            await dbHelper.saleQuoteDetailUpdate(element);
                          }
                        });
                      }
                    } else {
                      // if product is deleted during update
                      _saleQuoteList[0].quoteDetailList.forEach((element) async {
                        if (element.productId == _tempSaleOrderDetailList[i].productId) {
                          element.invoicedQuantity = element.invoicedQuantity - _tempSaleOrderDetailList[i].quantity;
                          await dbHelper.saleQuoteDetailUpdate(element);
                        }
                      });
                    }
                  }
                }
                await _updateSaleQuote(_saleQuoteList);
              }
            }
            String _notificationTime = br.getSystemFlagValue(global.systemFlagNameList.notificationTime);
            TimeOfDay tod = br.stringToTimeOfDay(_notificationTime);

            bool _scheduleNotification = false;
            if (order.deliveryDate != null && order.deliveryDate.isAfter(DateTime.now()) && _tempSaleOrder != null && _tempSaleOrder.deliveryDate != null && _tempSaleOrder.deliveryDate != order.deliveryDate) {
              _scheduleNotification = true;
            } else if (order.deliveryDate != null && order.deliveryDate.isAfter(DateTime.now())) {
              {
                _scheduleNotification = true;
              }
              if (_scheduleNotification) {
                int notificationId = int.parse(global.moduleIds['SaleOrder'].toString() + '01' + order.id.toString());
                await br.scheduleNotification(notificationId, order.deliveryDate.add(Duration(hours: tod.hour, minutes: tod.minute)), 'Sale order delivery', 'order number - ${order.saleOrderNumber} on ${DateFormat('MMMM dd').format(order.deliveryDate)}', '{"module":"SaleOrder","id":"${order.id}"}');
                int notificationId1 = int.parse(global.moduleIds['SaleOrder'].toString() + '02' + order.id.toString());
                await br.scheduleNotification(notificationId1, (order.deliveryDate.subtract(Duration(days: br.remainingDays(order.deliveryDate, false)))).add(Duration(hours: tod.hour, minutes: tod.minute)), 'Sale order delivery',
                    'order number - ${order.saleOrderNumber} on ${DateFormat('MMMM dd').format(order.deliveryDate)}', '{"module":"SaleOrder","id":"${order.id}"}');
                // get notification at delivery time code start
                int notificationId2 = int.parse(global.moduleIds['SaleOrder'].toString() + '03' + order.id.toString());
                await br.scheduleNotification(notificationId2, order.deliveryDate, 'Sale order delivery', 'order number - ${order.saleOrderNumber} it is time to delivered', '{"module":"SaleOrder","id":"${order.id}"}');
                // get notification at delivery time code end
              }
            }
            hideLoader();
            setState(() {});
            (screenId == null)
                ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => SaleOrderScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        )))
                : Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => SalesQuoteScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        )));
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
      print('Exception - saleOrderAddScreen.dart - _onSubmit(): ' + e.toString());
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
      print('Exception - saleOrderAddScreen.dart - _selectDate(): ' + e.toString());
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
        SaleOrderTax _orderTax = SaleOrderTax(null, null, _taxList[i].id, _taxList[i].percentage, 0.0);
        _orderTax.taxName = _taxList[i].taxName;
        order.orderTaxList.add(_orderTax);
      }
      setState(() {});
    } catch (e) {
      print('Exception - saleOrderAddScreen.dart - _getTaxes(): ' + e.toString());
    }
  }

  Future _removeProduct(index) async {
    try {
      order.grossAmount -= order.orderDetailList[index].amount;
      if (order.id == null) {
        if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false' || order.orderDetailList.length < 1)) {
          order.finalTax = 0.0;
          for (int i = 0; i < order.orderTaxList.length; i++) {
            order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
            if (_isTaxApply) {
              order.finalTax += order.orderTaxList[i].totalAmount;
            }
          }
          order.netAmount = (_isTaxApply && order.orderTaxList.length > 0) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
        } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
          order.finalTax = 0.0;
          order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();

          List<int> _tempProductIdList = [];
          order.orderDetailList.forEach((orderDetail) {
            if (orderDetail.productId != order.orderDetailList[index].productId) {
              _tempProductIdList.add(orderDetail.productId);
            }
          });

          _productTaxList = await dbHelper.productTaxGetList(productIdList: _tempProductIdList);
          order.orderDetailTaxList.clear();
          order.orderDetailList.forEach((orderDetail) {
            _productTaxList.forEach((productTax) {
              if (orderDetail.productId == productTax.productId) {
                order.orderTaxList.forEach((orderTax) {
                  if (orderTax.taxId == productTax.taxMasterId) {
                    orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                    SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                    order.orderDetailTaxList.add(_orderDetailTax);
                  }
                });
              }
            });
          });
          order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
          order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
          order.netAmount = order.grossAmount - order.discount;
        }
      } else {
        if (order.orderTaxList.length != 0 && (order.orderDetailTaxList.length == 0 || order.orderDetailList.length < 1)) {
          order.finalTax = 0.0;
          for (int i = 0; i < order.orderTaxList.length; i++) {
            order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
            if (_isTaxApply) {
              order.finalTax += order.orderTaxList[i].totalAmount;
            }
          }
          order.netAmount = (_isTaxApply && order.orderTaxList.length > 0) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
          setState(() {});
        } else if (order.orderTaxList.length != 0 && order.orderDetailTaxList.length != 0) {
          order.finalTax = 0.0;
          order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();

          List<int> _tempProductIdList = [];
          order.orderDetailList.forEach((orderDetail) {
            if (orderDetail.productId != order.orderDetailList[index].productId) {
              _tempProductIdList.add(orderDetail.productId);
            }
          });

          _productTaxList = await dbHelper.productTaxGetList(productIdList: _tempProductIdList);
          order.orderDetailTaxList.clear();
          order.orderDetailList.forEach((orderDetail) {
            _productTaxList.forEach((productTax) {
              if (orderDetail.productId == productTax.productId) {
                order.orderTaxList.forEach((orderTax) {
                  if (orderTax.taxId == productTax.taxMasterId) {
                    orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                    SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                    order.orderDetailTaxList.add(_orderDetailTax);
                  }
                });
              }
            });
          });
          order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
          order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        } else if (_isTaxApply == false) {
          order.netAmount = order.grossAmount - order.discount;
        }
      }
      order.orderDetailList.removeAt(index);
      _cUnitPriceList.removeAt(index);
      _cQtyList.removeAt(index);
      if (_cUnitList.length > 0) {
        _cUnitList.removeAt(index);
      }
      if (order.orderDetailList.length < 1) {
        _cNetAmount.text = order.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        order.discount = 0;
        order.netAmount = 0;
        _cDiscount.text = order.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        order.orderTaxList.map((e) => e.totalAmount = 0).toList();
      }
      FocusScope.of(context).requestFocus(_focusNode);
      _calculate();
      setState(() {});
    } catch (e) {
      print('Exception - saleOrderAddScreen.dart - _removeProduct(): ' + e.toString());
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
      print('Exception - saleOrderAddScreen.dart - _discountListener(): ' + e.toString());
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
      print('Exception - saleOrderAddScreen.dart - _netAmountListener(): ' + e.toString());
    }
  }

  Future _onApplyTaxChanged(bool value) async {
    try {
      if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true') {
        _isTaxApply = value;
        if (_isTaxApply != true) {
          order.netAmount = order.grossAmount - order.discount;
          order.finalTax = 0.0;
        } else {
          if (order.orderTaxList.length < 1) {
            await _getTaxes();
          }
          if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && (br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false' || order.orderDetailList.length < 1)) {
            order.finalTax = 0.0;
            for (int i = 0; i < order.orderTaxList.length; i++) {
              order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
              if (_isTaxApply) {
                order.finalTax += order.orderTaxList[i].totalAmount;
              }
            }
            order.netAmount = (_isTaxApply && order.orderTaxList.length > 0) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
          } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
            order.finalTax = 0.0;
            order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
            _productTaxList = await dbHelper.productTaxGetList(productIdList: order.orderDetailList.map((e) => e.productId).toList());
            order.orderDetailTaxList.clear();
            order.orderDetailList.forEach((orderDetail) {
              _productTaxList.forEach((productTax) {
                if (orderDetail.productId == productTax.productId) {
                  order.orderTaxList.forEach((orderTax) {
                    if (orderTax.taxId == productTax.taxMasterId) {
                      orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                      SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                      order.orderDetailTaxList.add(_orderDetailTax);
                    }
                  });
                }
              });
            });
            order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
            order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

            setState(() {});
          } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
            order.netAmount = order.grossAmount - order.discount;
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

  Future _selectUnit(int index) async {
    try {
      await showDialog(
          context: context,
          builder: (_) {
            return SelectUnitDialog(a: widget.analytics, o: widget.observer, unitList: order.orderDetailList[index].product.unitList);
          }).then((value) async {
        if (value != null) {
          List<Unit> _temp = value.toList();
          _cUnitList[index].text = _temp.firstWhere((element) => element.isSelected).code;
          order.orderDetailList[index].unitId = _temp.firstWhere((element) => element.isSelected).id;
          order.orderDetailList[index].unitCode = _temp.firstWhere((element) => element.isSelected).code;
          if (order.orderDetailList[index].unitId == order.orderDetailList[index].product.productPriceList[0].unitId) {
            // if product unit and selected unit is same
            order.orderDetailList[index].unitPrice = order.orderDetailList[index].actualUnitPrice;
            _cUnitPriceList[index].text = order.orderDetailList[index].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
            order.orderDetailList[index].amount = order.orderDetailList[index].quantity * order.orderDetailList[index].unitPrice;
          } else {
            // if product unit and selected unit is not same
            UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == order.orderDetailList[index].product.unitCombinationId);
            if (order.orderDetailList[index].unitId == _unitCombination.primaryUnitId) // if parent unit is selected
            {
              order.orderDetailList[index].unitPrice = order.orderDetailList[index].actualUnitPrice * _unitCombination.measurement;
              _cUnitPriceList[index].text = order.orderDetailList[index].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
              order.orderDetailList[index].amount = order.orderDetailList[index].quantity * order.orderDetailList[index].unitPrice;
            } else if (order.orderDetailList[index].unitId == _unitCombination.secondaryUnitId) // if child unit is selected
            {
              order.orderDetailList[index].unitPrice = order.orderDetailList[index].quantity * (order.orderDetailList[index].actualUnitPrice / _unitCombination.measurement);
              _cUnitPriceList[index].text = order.orderDetailList[index].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
              order.orderDetailList[index].amount = order.orderDetailList[index].unitPrice;
            }
          }
          // order.orderDetailList[index].amount = order.orderDetailList[index].quantity * order.orderDetailList[index].unitPrice;
          order.grossAmount = order.orderDetailList.map((orderDetail) => orderDetail.amount).reduce((sum, amount) => sum + amount);
          if (order.id == null) {
            if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
              order.finalTax = 0.0;
              for (int i = 0; i < order.orderTaxList.length; i++) {
                order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
                if (_isTaxApply) {
                  order.finalTax += order.orderTaxList[i].totalAmount;
                }
              }
              order.netAmount = (_isTaxApply && order.orderTaxList.length > 0) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
            } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
              order.finalTax = 0.0;
              order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
              order.orderDetailTaxList.clear();
              order.orderDetailList.forEach((orderDetail) {
                _productTaxList.forEach((productTax) {
                  if (orderDetail.productId == productTax.productId) {
                    order.orderTaxList.forEach((orderTax) {
                      if (orderTax.taxId == productTax.taxMasterId) {
                        orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                        SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                        order.orderDetailTaxList.add(_orderDetailTax);
                      }
                    });
                  }
                });
              });
              order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
              order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;

              setState(() {});
            } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'false') {
              order.netAmount = order.grossAmount - order.discount;
            }
          } else {
            if (order.orderTaxList.length != 0 && _orderDetailTaxLen == 0) {
              order.finalTax = 0.0;
              for (int i = 0; i < order.orderTaxList.length; i++) {
                order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
                if (_isTaxApply) {
                  order.finalTax += order.orderTaxList[i].totalAmount;
                }
              }
              order.netAmount = (_isTaxApply && order.orderTaxList.length > 0) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
            } else if (order.orderTaxList.length != 0 && _orderDetailTaxLen != 0) {
              order.finalTax = 0.0;
              order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
              order.orderDetailTaxList.clear();
              if (_productTaxList.length == 0) {
                _productTaxList = await dbHelper.productTaxGetList(productIdList: order.orderDetailList.map((orderDetail) => orderDetail.productId).toList());
              }
              order.orderDetailList.forEach((orderDetail) {
                _productTaxList.forEach((productTax) {
                  if (orderDetail.productId == productTax.productId) {
                    order.orderTaxList.forEach((orderTax) {
                      if (orderTax.taxId == productTax.taxMasterId) {
                        orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                        SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.unitPrice * productTax.percentage) / 100);
                        order.orderDetailTaxList.add(_orderDetailTax);
                      }
                    });
                  }
                });
              });
              order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
              order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
              setState(() {});
            } else if (_isTaxApply == false) {
              order.netAmount = order.grossAmount - order.discount;
            }
          }
          _calculate();
          setState(() {});
          // order.orderDetailList[index].unitPrice =
        }
      });
      setState(() {});
    } catch (e) {
      print('Exception - saleOrderAddScreen.dart - _selectUnit(): ' + e.toString());
    }
  }

  Future _onTaxGroupChanged(value) async {
    try {
      _isDataLoaded = false;
      setState(() {});
      _selectedTaxGroup = value;
      order.finalTax = 0;
      order.orderTaxList.clear();
      await _getTaxes();
      if (order.id == null) {
        order.orderDetailTaxList.clear();
        if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'false') {
          for (int i = 0; i < order.orderTaxList.length; i++) {
            order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
            if (_isTaxApply) {
              order.finalTax += order.orderTaxList[i].totalAmount;
            }
          }
          order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
        } else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableProductWiseTax) == 'true') {
          order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
          _productTaxList = await dbHelper.productTaxGetList(productIdList: order.orderDetailList.map((orderDetail) => orderDetail.productId).toList());

          order.orderDetailList.forEach((orderDetail) {
            _productTaxList.forEach((productTax) {
              if (orderDetail.productId == productTax.productId) {
                order.orderTaxList.forEach((orderTax) {
                  if (orderTax.taxId == productTax.taxMasterId) {
                    orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                    SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.amount * productTax.percentage) / 100);
                    order.orderDetailTaxList.add(_orderDetailTax);
                  }
                });
              }
            });
          });
          order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderDetailTax) => orderDetailTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
          order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        }
      } else {
        if (order.orderTaxList.length != 0 && order.orderDetailTaxList.length == 0) {
          for (int i = 0; i < order.orderTaxList.length; i++) {
            order.orderTaxList[i].totalAmount = ((order.grossAmount - order.discount) * order.orderTaxList[i].percentage) / 100;
            if (_isTaxApply) {
              order.finalTax += order.orderTaxList[i].totalAmount;
            }
          }
          order.netAmount = (_isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
        } else if (order.orderTaxList.length != 0 && order.orderDetailTaxList.length != 0) {
          order.orderDetailTaxList.clear();
          order.orderTaxList.map((orderTax) => orderTax.totalAmount = 0.0).toList();
          _productTaxList = await dbHelper.productTaxGetList(productIdList: order.orderDetailList.map((orderDetail) => orderDetail.productId).toList());

          order.orderDetailList.forEach((orderDetail) {
            _productTaxList.forEach((productTax) {
              if (orderDetail.productId == productTax.productId) {
                order.orderTaxList.forEach((orderTax) {
                  if (orderTax.taxId == productTax.taxMasterId) {
                    orderTax.totalAmount += (orderDetail.amount * productTax.percentage) / 100;
                    SaleOrderDetailTax _orderDetailTax = SaleOrderDetailTax(null, null, productTax.taxMasterId, productTax.percentage, (orderDetail.amount * productTax.percentage) / 100);
                    order.orderDetailTaxList.add(_orderDetailTax);
                  }
                });
              }
            });
          });
          order.netAmount = (order.orderTaxList.length > 0 && _isTaxApply) ? order.grossAmount - order.discount + order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : order.grossAmount - order.discount;
          order.finalTax = (order.orderTaxList.length > 0 && _isTaxApply) ? order.orderTaxList.map((orderTax) => orderTax.totalAmount).reduce((sum, amount) => sum + amount) : 0;
          setState(() {});
        }
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - saleOrderAddScreen.dart - _onTaxGroupChanged(): ' + e.toString());
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
