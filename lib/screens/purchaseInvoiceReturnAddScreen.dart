// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/dialogs/paymentAddDialog.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnDetailModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnDetailTaxModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnTaxModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/models/unitCombinationModel.dart';
import 'package:accounting_app/screens/purchaseInvoiceReturnScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';

import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:flutter/services.dart';
//import 'package:googleapis/adsense/v1_4.dart';
import 'package:intl/intl.dart';
import 'package:ulid/ulid.dart';

class PurchaseInvoiceReturnAddScreen extends BaseRoute {
  final List<PurchaseInvoice> purchaseInvoiceList;
  final List<PurchaseInvoiceReturn> purchaseReturnList;
  final bool isTransactionUpdate;
  PurchaseInvoiceReturnAddScreen({@required a, @required o, this.purchaseInvoiceList, this.purchaseReturnList, this.isTransactionUpdate}) : super(a: a, o: o, r: 'PurchaseInvoiceReturnAddScreen');
  @override
  _PurchaseInvoiceReturnAddScreenState createState() => _PurchaseInvoiceReturnAddScreenState(this.purchaseInvoiceList, this.purchaseReturnList, this.isTransactionUpdate);
}

class _PurchaseInvoiceReturnAddScreenState extends BaseRouteState {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bool isTransactionUpdate;
  List<PurchaseInvoice> purchaseInvoiceList;
  final List<PurchaseInvoiceReturn> purchaseReturnList;
  List<PurchaseInvoiceReturn> _purchaseInvoiceReturnList = [];
  bool _dataLoaded = false;
  bool isRefundTax = true;
  double _total = 0;
  double _finalTotal = 0;
  List<TaxMaster> _taxList = [];
  var _cInvoiceDate = TextEditingController();
  String _invoiceDate2;
  String _transactioGroupId = '';
  Payment _payment = Payment();
  double _remainAmount = 0;
  List<UnitCombination> _unitCombinationList;
  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _PurchaseInvoiceReturnAddScreenState(this.purchaseInvoiceList, this.purchaseReturnList, this.isTransactionUpdate) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text((purchaseReturnList == null) ? global.appLocaleValues['tle_add_return'] : global.appLocaleValues['tle_update_return']),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              _onSubmit();
            },
            child: Text(global.appLocaleValues['btn_save'], style: TextStyle(color: Colors.white, fontSize: 18)),
          )
        ],
      ),
      body: (_dataLoaded)
          ? WillPopScope(
              onWillPop: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PurchaseInvoiceReturnScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        )));
                return null;
              },
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Form(
                    autovalidateMode: (_autoValidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 10, left: 10, right: 10),
                          child: Text('${global.appLocaleValues['lbl_inv_return_date']}', style: Theme.of(context).primaryTextTheme.headline3),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              // labelText: ,
                              border: nativeTheme().inputDecorationTheme.border,
                              suffixIcon: Icon(
                                Icons.star,
                                size: 9,
                                color: Colors.red,
                              ),
                            ),
                            controller: _cInvoiceDate,
                            keyboardType: null,
                            validator: (v) {
                              if (v.isEmpty) {
                                return global.appLocaleValues['lbl_date_err_req'];
                              }
                              return null;
                            },
                            onTap: () {
                              _selectDate(context);
                            },
                          ),
                        ),
                        Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _purchaseInvoiceReturnList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text('${_purchaseInvoiceReturnList[index].purchaseInvoiceNumber} - ${br.generateAccountName(_purchaseInvoiceReturnList[index].account)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).primaryColor)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_select_return_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_select_return_service'] : global.appLocaleValues['tle_select_return_both']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                ListView.builder(
                                  itemCount: _purchaseInvoiceReturnList[index].invoiceReturnDetailList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    return CheckboxListTile(
                                      title: ListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          title: Text(
                                              '${_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].productName} - ${global.currency.symbol} ${_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].soldUnitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'),
                                          subtitle: Text((br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                              ? '${global.appLocaleValues['lbl_sold_qty']}: ${_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].quantity} ${_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitCode}'
                                              : '${global.appLocaleValues['lbl_sold_qty']}: ${_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].quantity}'),
                                          trailing: (_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].isSelect)
                                              ? Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                                        ? SizedBox(
                                                            width: 55,
                                                            child: TextFormField(
                                                              readOnly: true,
                                                              initialValue: '${_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitCode}',
                                                              decoration: InputDecoration(
                                                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4e2eb5))),
                                                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                                                                errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                                disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[700])),
                                                                border: UnderlineInputBorder(borderSide: BorderSide(width: 0.2)),
                                                                labelText: global.appLocaleValues['lbl_unit'],
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                    (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                                        ? SizedBox(
                                                            width: 5,
                                                          )
                                                        : SizedBox(),
                                                    SizedBox(
                                                        width: 67,
                                                        child: TextFormField(
                                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
                                                          initialValue: '${_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity}',
                                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                          maxLength: 3,
                                                          textAlign: TextAlign.center,
                                                          decoration: InputDecoration(
                                                              counterText: '',
                                                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4e2eb5))),
                                                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                                                              errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                              disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[700])),
                                                              border: UnderlineInputBorder(borderSide: BorderSide(width: 0.2)),
                                                              labelText: '${global.appLocaleValues['lbl_return_qty']}'),
                                                          validator: (v) {
                                                            if (v.isEmpty) {
                                                              return '';
                                                            } else if (v.contains(RegExp('[a-zA-Z]'))) {
                                                              return global.appLocaleValues['vel_enter_number_only'];
                                                            } else if (v == '0') {
                                                              return global.appLocaleValues['lbl_return_qty_err_req'];
                                                            } else if (_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].isSelect && double.parse(v) > _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].quantity) {
                                                              return global.appLocaleValues['lbl_rQty_err_vld'];
                                                            }
                                                            return null;
                                                          },
                                                          onChanged: (value) {
                                                            try {
                                                              _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity = (value.length > 0) ? double.parse(value) : 0;
                                                              if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
                                                                if (_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitId == _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].productUnitId) // if product unit and sold unit is same
                                                                {
                                                                  _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].amount = _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitPrice * _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity;
                                                                } else {
                                                                  UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].product.unitCombinationId);
                                                                  if (_unitCombination.primaryUnitId == _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitId) {
                                                                    _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].amount = (_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitPrice * _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity);
                                                                  } else if (_unitCombination.secondaryUnitId == _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitId) {
                                                                    _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].amount =
                                                                        (_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitPrice * _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity) / _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].quantity;
                                                                  }
                                                                }
                                                              } else {
                                                                _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].amount = _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity * _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitPrice;
                                                              }
                                                              _purchaseInvoiceReturnList[index].grossAmount = _purchaseInvoiceReturnList[index].invoiceReturnDetailList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
                                                              _calculateTaxAmount(index, i);
                                                              _calculate(_purchaseInvoiceReturnList[index]);
                                                              setState(() {});
                                                            } catch (e) {
                                                              print('Exception - PurchaseInvoiceReturnAddScreen.dart - rQty_onChanged(): ' + e.toString());
                                                            }
                                                          },
                                                        )),
                                                  ],
                                                )
                                              : SizedBox()),
                                      value: _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].isSelect,
                                      onChanged: (value) async {
                                        try {
                                          if (_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].product == null) {
                                            List<Product> _productList = await dbHelper.productGetList(productId: [_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].productId]);
                                            _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].product = (_productList.length > 0) ? _productList[0] : null;
                                          }
                                          _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity = (value) ? _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].quantity : 0;
                                          if (_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitId == _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].productUnitId) // if product unit and sold unit is same
                                          {
                                            _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].amount = (value) ? _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitPrice * _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].quantity : 0;
                                          } else {
                                            UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].product.unitCombinationId);
                                            if (_unitCombination.primaryUnitId == _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitId) {
                                              _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].amount = (value) ? (_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitPrice * _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity) : 0;
                                            } else if (_unitCombination.secondaryUnitId == _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitId) {
                                              _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].amount =
                                                  (value) ? (_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].unitPrice * _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity) / _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].quantity : 0;
                                            }
                                          }
                                          _purchaseInvoiceReturnList[index].grossAmount = _purchaseInvoiceReturnList[index].invoiceReturnDetailList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
                                          _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].isSelect = value;
                                          _calculateTaxAmount(index, i, isCheckUncheck: value);
                                          _calculate(_purchaseInvoiceReturnList[index]);
                                          setState(() {});
                                        } catch (e) {
                                          print('Exception - PurchaseInvoiceReturnAddScreen.dart - checkBox_onChanged(): ' + e.toString());
                                        }
                                      },
                                    );
                                  },
                                ),
                                ((_purchaseInvoiceReturnList.length - 1) != index) ? Divider() : SizedBox()
                              ],
                            );
                          },
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                                child: ListTile(
                                    title: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        '${global.appLocaleValues['lbl_sub_total']}',
                                        style: TextStyle(color: Colors.grey, fontSize: 17),
                                      ),
                                    ),
                                    trailing: Text(
                                      '${global.currency.symbol} ${_total.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                      style: TextStyle(fontSize: 20),
                                    )),
                              ),
                              (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == "true") ? Divider() : SizedBox(),
                              (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == "true")
                                  ? SizedBox(
                                      height: 40,
                                      child: ListTile(
                                        title: Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            global.appLocaleValues['lbl_refund_tax'],
                                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        trailing: Switch(
                                          value: isRefundTax,
                                          onChanged: (value) {
                                            if (purchaseReturnList == null) {
                                              setState(() {
                                                isRefundTax = value;

                                                if (!value) {
                                                  _purchaseInvoiceReturnList.map((f) => f.finalTax = 0).toList();
                                                  _purchaseInvoiceReturnList.map((f) => f.netAmount = f.grossAmount).toList();
                                                  _finalTotal = _total;
                                                } else {
                                                  _purchaseInvoiceReturnList.forEach((item) {
                                                    item.finalTax = item.invoiceReturnTaxList.map((f) => f.totalAmount).reduce((sum, amt) => sum + amt);
                                                    item.netAmount = item.finalTax + item.grossAmount;
                                                  });
                                                  _finalTotal = _purchaseInvoiceReturnList.map((f) => f.netAmount).reduce((sum, amt) => sum + amt);
                                                }
                                              });
                                            } else {
                                              showToast('${global.appLocaleValues['lbl_refund_tax_vld']}');
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              (isRefundTax && br.getSystemFlagValue(global.systemFlagNameList.enableTax) == "true")
                                  ? ListView.builder(
                                      itemCount: _taxList.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          height: 40,
                                          child: ListTile(
                                              title: Padding(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text(
                                                  '${_taxList[index].taxName}',
                                                  style: TextStyle(color: Colors.grey, fontSize: 17),
                                                ),
                                              ),
                                              trailing: Text(
                                                '${global.currency.symbol} ${_taxList[index].taxAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                style: TextStyle(fontSize: 20),
                                              )),
                                        );
                                      },
                                    )
                                  : SizedBox(),
                              Divider(),
                              SizedBox(
                                height: 40,
                                child: ListTile(
                                    title: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        '${global.appLocaleValues['lbl_total']}',
                                        style: TextStyle(color: Colors.grey, fontSize: 17),
                                      ),
                                    ),
                                    trailing: Text(
                                      '${global.currency.symbol} ${_finalTotal.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                      style: TextStyle(fontSize: 20),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: <Widget>[
                              (purchaseReturnList == null || (isTransactionUpdate != null && isTransactionUpdate))
                                  ? MaterialButton(
                                      color: Theme.of(context).primaryColor,
                                      minWidth: MediaQuery.of(context).size.width,
                                      child: Text(
                                        '${global.appLocaleValues['btn_add_payment']}',
                                      ),
                                      onPressed: () async {
                                        await _addPaymentMethod();
                                      },
                                    )
                                  : ListTile(
                                      title: Text(
                                        '${global.appLocaleValues['lbl_payment_methods_']}',
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                    ),
                              SingleChildScrollView(
                                child: Container(
                                    width: 500,
                                    child: Column(
                                      children: <Widget>[
                                        ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: _payment.paymentDetailList.length,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 20,
                                                  child: (purchaseReturnList == null || _payment.paymentDetailList[index].isRecentlyAdded == true)
                                                      ? IconButton(
                                                          icon: Icon(
                                                            Icons.cancel,
                                                            color: Colors.red,
                                                          ),
                                                          onPressed: () {
                                                            _remainAmount -= _payment.paymentDetailList[index].amount;
                                                            _payment.paymentDetailList.removeAt(index);
                                                            //   print(_remainAmount);
                                                            setState(() {});
                                                          },
                                                        )
                                                      : null,
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 55,
                                                    child: ListTile(
                                                        title: Text(
                                                          '${_payment.paymentDetailList[index].paymentMode}',
                                                          style: TextStyle(color: Colors.grey, fontSize: 17),
                                                        ),
                                                        subtitle: (_payment.paymentDetailList[index].remark.isNotEmpty) ? Text('${_payment.paymentDetailList[index].remark}') : null,
                                                        trailing: Text(
                                                          '${global.currency.symbol} ${_payment.paymentDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                          style: TextStyle(fontSize: 17),
                                                        )),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          : Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getDetails();
  }

  Future _getDetails() async {
    try {
      _unitCombinationList = await dbHelper.unitCombinationGetList();
      if (purchaseReturnList == null) {
        _cInvoiceDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _invoiceDate2 = DateTime.now().toString().substring(0, 10);
        _getData();
      } else {
        _fetchData();
      }
      _dataLoaded = true;
    } catch (e) {
      print('Exception - PurchaseInvoiceReturnAddScreen.dart - _getDetails(): ' + e.toString());
    }
  }

  Future _getData() async {
    try {
      _transactioGroupId = Ulid().toUuid();
      for (int i = 0; i < purchaseInvoiceList.length; i++) {
        purchaseInvoiceList[i].invoiceDetailList = await dbHelper.purchaseInvoiceDetailGetList(invoiceId: purchaseInvoiceList[i].id);
        purchaseInvoiceList[i].invoiceTaxList = await dbHelper.purchaseInvoiceTaxGetList(invoiceId: purchaseInvoiceList[i].id);
        purchaseInvoiceList[i].invoiceDetailTaxList = await dbHelper.purchaseInvoiceDetailTaxGetList(invoiceDetailIdList: purchaseInvoiceList[i].invoiceDetailList.map((item) => item.id).toList());
        PurchaseInvoiceReturn _purchaseInvoiceReturn = PurchaseInvoiceReturn(null, purchaseInvoiceList[i].id, _transactioGroupId, purchaseInvoiceList[i].invoiceNumber, purchaseInvoiceList[i].accountId, 0, 0, 0, 0, DateTime.parse(_invoiceDate2), true, "PENDING", purchaseInvoiceList[i].account);
        purchaseInvoiceList[i].invoiceTaxList.forEach((f) {
          PurchaseInvoiceReturnTax _purchaseInvoiceReturnTax = PurchaseInvoiceReturnTax(null, null, f.taxId, f.percentage, 0);
          _purchaseInvoiceReturn.invoiceReturnTaxList.add(_purchaseInvoiceReturnTax);
        });

        purchaseInvoiceList[i].invoiceDetailList.forEach((f) {
          PurchaseInvoiceReturnDetail _purchaseInvoiceReturnDetail =
              PurchaseInvoiceReturnDetail(null, purchaseInvoiceList[i].id, null, f.productId, f.unitId, f.productUnitId, f.unitCode, f.quantity, f.unitPrice, f.unitPrice, 0, f.productName, f.productCode, f.productTypeName, f.actualUnitPrice, f.isDelete, null, null, 0);
          purchaseInvoiceList[i].invoiceDetailTaxList.forEach((item) {
            if (f.id == item.invoiceDetailId) {
              PurchaseInvoiceReturnDetailTax _purchaseInvoiceReturnDetailTax = PurchaseInvoiceReturnDetailTax(null, null, item.taxId, item.percentage, 0);
              _purchaseInvoiceReturnDetail.invoiceReturnDetailTaxList.add(_purchaseInvoiceReturnDetailTax);
            }
          });

          _purchaseInvoiceReturn.invoiceReturnDetailList.add(_purchaseInvoiceReturnDetail);
        });
        _purchaseInvoiceReturnList.add(_purchaseInvoiceReturn);
      }

      List<int> _taxIdList = [];
      purchaseInvoiceList.forEach((purchaseInvoice) {
        purchaseInvoice.invoiceTaxList.forEach((invoiceTax) {
          _taxIdList.add(invoiceTax.taxId);
        });
      });

      _taxList = await dbHelper.taxMasterGetList(taxMasterIdList: _taxIdList);

      setState(() {});
    } catch (e) {
      print('Exception - PurchaseInvoiceReturnAddScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _fetchData() async {
    try {
      _cInvoiceDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(purchaseReturnList[0].invoiceDate);
      _invoiceDate2 = purchaseReturnList[0].invoiceDate.toString();

      purchaseInvoiceList = await dbHelper.purchaseInvoiceGetList(invoiceIdList: purchaseReturnList.map((f) => f.purchaseInvoiceId).toList());

      for (int i = 0; i < purchaseInvoiceList.length; i++) {
        purchaseInvoiceList[i].invoiceDetailList = await dbHelper.purchaseInvoiceDetailGetList(invoiceId: purchaseInvoiceList[i].id);

        purchaseInvoiceList[i].invoiceTaxList = await dbHelper.purchaseInvoiceTaxGetList(invoiceId: purchaseInvoiceList[i].id);
        purchaseInvoiceList[i].invoiceDetailTaxList = await dbHelper.purchaseInvoiceDetailTaxGetList(invoiceDetailIdList: purchaseInvoiceList[i].invoiceDetailList.map((item) => item.id).toList());

        PurchaseInvoiceReturn _purchaseInvoiceReturn = purchaseReturnList[i];
        _purchaseInvoiceReturn.invoiceReturnTaxList = await dbHelper.purchaseInvoiceReturnTaxGetList(purchaseInvoiceReturnId: _purchaseInvoiceReturn.id);
        List<PurchaseInvoiceReturnDetail> _temp = await dbHelper.purchaseInvoiceReturnDetailGetList(purchaseInvoiceReturnId: _purchaseInvoiceReturn.id);

        for (int j = 0; j < purchaseInvoiceList[i].invoiceDetailList.length; j++) {
          PurchaseInvoiceReturnDetail _purchaseInvoiceReturnDetail;
          bool positionIsExist = _temp.map((ird) => ird.productId).contains(purchaseInvoiceList[i].invoiceDetailList[j].productId);
          if (!positionIsExist) {
            _purchaseInvoiceReturnDetail = PurchaseInvoiceReturnDetail(
                null,
                purchaseInvoiceList[i].id,
                null,
                purchaseInvoiceList[i].invoiceDetailList[j].productId,
                purchaseInvoiceList[i].invoiceDetailList[j].unitId,
                purchaseInvoiceList[i].invoiceDetailList[j].productUnitId,
                purchaseInvoiceList[i].invoiceDetailList[j].unitCode,
                purchaseInvoiceList[i].invoiceDetailList[j].quantity,
                purchaseInvoiceList[i].invoiceDetailList[j].unitPrice,
                purchaseInvoiceList[i].invoiceDetailList[j].unitPrice,
                0,
                purchaseInvoiceList[i].invoiceDetailList[j].productName,
                purchaseInvoiceList[i].invoiceDetailList[j].productCode,
                purchaseInvoiceList[i].invoiceDetailList[j].productTypeName,
                purchaseInvoiceList[i].invoiceDetailList[j].actualUnitPrice,
                purchaseInvoiceList[i].invoiceDetailList[j].isDelete,
                null,
                null,
                0);

            purchaseInvoiceList[i].invoiceDetailTaxList.forEach((item) {
              if (purchaseInvoiceList[i].invoiceDetailList[j].id == item.invoiceDetailId) {
                PurchaseInvoiceReturnDetailTax _purchaseInvoiceReturnDetailTax = PurchaseInvoiceReturnDetailTax(null, null, item.taxId, item.percentage, 0);
                _purchaseInvoiceReturnDetail.invoiceReturnDetailTaxList.add(_purchaseInvoiceReturnDetailTax);
              }
            });
          } else {
            for (int k = 0; k < _temp.length; k++) {
              if (purchaseInvoiceList[i].invoiceDetailList[j].productId == _temp[k].productId) {
                _temp[k].isSelect = true;
                _temp[k].returnQuantity = _temp[k].quantity;
                _temp[k].quantity = purchaseInvoiceList[i].invoiceDetailList[j].quantity;
                _temp[k].invoiceReturnDetailTaxList = await dbHelper.purchaseInvoiceReturnDetailTaxGetList(purchaseInvoiceReturnDetailIdList: [_temp[k].id]);
                _purchaseInvoiceReturnDetail = _temp[k];
              }
            }
          }

          _purchaseInvoiceReturn.invoiceReturnDetailList.add(_purchaseInvoiceReturnDetail);
        }
        _purchaseInvoiceReturnList.add(_purchaseInvoiceReturn);
      }

      _total = _purchaseInvoiceReturnList.map((f) => f.grossAmount).reduce((sum, amt) => sum + amt);
      _finalTotal = _purchaseInvoiceReturnList.map((f) => f.netAmount).reduce((sum, amt) => sum + amt);

      if (_total != _finalTotal) {
        List<int> _taxId = [];
        _purchaseInvoiceReturnList.forEach((item) {
          item.invoiceReturnTaxList.forEach((f) {
            _taxId.add(f.taxId);
          });
        });

        _taxList = await dbHelper.taxMasterGetList(taxMasterIdList: _taxId.toSet().toList());

        _taxList.forEach((f) {
          double _taxAmt = 0;
          _purchaseInvoiceReturnList.forEach((item) {
            item.invoiceReturnTaxList.forEach((tax) {
              if (f.id == tax.taxId) {
                _taxAmt += tax.totalAmount;
              }
            });
          });
          f.taxAmount = _taxAmt;
        });
      } else {
        isRefundTax = false;
      }
      List<PaymentPurchaseInvoiceReturn> _paymentPurchaseInvoiceReturnList = await dbHelper.paymentPurchaseInvoiceReturnGetList(transactionGroupId: _purchaseInvoiceReturnList[0].transactionGroupId);
      //   List<Payment> _paymentList = (_paymentPurchaseInvoiceReturnList.length > 0) ? await dbHelper.paymentGetList(paymentIdList: _paymentPurchaseInvoiceReturnList.map((f)=> f.paymentId).toList()) : [];
      _payment.paymentDetailList = (_paymentPurchaseInvoiceReturnList.length > 0) ? await dbHelper.paymentDetailGetList(paymentIdList: _paymentPurchaseInvoiceReturnList.map((f) => f.paymentId).toList()) : [];

      setState(() {});
    } catch (e) {
      print('Exception - PurchaseInvoiceReturnAddScreen.dart - _fetchData(): ' + e.toString());
    }
  }

  Future _onSubmit() async {
    try {
      if (_formKey.currentState.validate()) {
        if (_finalTotal > 0) {
          showLoader(global.appLocaleValues['txt_wait']);
          setState(() {});
          double _paidamount = (_payment.paymentDetailList.length > 0) ? _payment.paymentDetailList.map((f) => f.amount).reduce((sum, amt) => sum + amt) : 0;
          if (_finalTotal <= _paidamount) {
            _purchaseInvoiceReturnList.map((f) => f.status = 'REFUNDED').toList();
          } else {
            _purchaseInvoiceReturnList.map((f) => f.status = 'PENDING').toList();
          }
          if (purchaseReturnList == null) {
            await dbHelper.purchaseInvoiceReturnInsert(_purchaseInvoiceReturnList, isRefundTax, _payment);
          } else {
            await dbHelper.purchaseInvoiceReturnUpdate(purchaseInvoiceReturnList: _purchaseInvoiceReturnList, isRefundTax: isRefundTax, updateFrom: 1, payment: _payment);
          }
          hideLoader();
          setState(() {});
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PurchaseInvoiceReturnScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )));
        } else {
          showToast(
              '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_inv_return_product_err_vld'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_inv_return_service_err_vld'] : global.appLocaleValues['tle_inv_return_both_err_vld']}');
        }
      } else {
        _autoValidate = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - PurchaseInvoiceReturnAddScreen.dart - _onSubmit(): ' + e.toString());
    }
  }

  void _calculate(PurchaseInvoiceReturn _purchaseInvoiceReturn) {
    try {
      _purchaseInvoiceReturn.netAmount = (isRefundTax) ? _purchaseInvoiceReturn.grossAmount + _purchaseInvoiceReturn.finalTax : _purchaseInvoiceReturn.grossAmount;
      _total = _purchaseInvoiceReturnList.map((f) => f.grossAmount).reduce((sum, amt) => sum + amt);
      _finalTotal = _purchaseInvoiceReturnList.map((f) => f.netAmount).reduce((sum, amt) => sum + amt);

      _taxList.forEach((item) {
        double _totalamount = 0;
        _purchaseInvoiceReturnList.forEach((f) {
          f.invoiceReturnTaxList.forEach((invoiceReturnTax) {
            if (item.id == invoiceReturnTax.taxId) {
              _totalamount += invoiceReturnTax.totalAmount;
            }
          });
        });
        item.taxAmount = _totalamount;
      });
    } catch (e) {
      print('Exception - PurchaseInvoiceReturnAddScreen.dart - _calculate(): ' + e.toString());
    }
  }

  void _calculateTaxAmount(int index, int i, {bool isCheckUncheck}) {
    try {
      if (_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].invoiceReturnDetailTaxList.length > 0) // if product wise tax applied on purchase invoice
      {
        _purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].invoiceReturnDetailTaxList.forEach((item) {
          if (isCheckUncheck != null) {
            item.taxAmount = (isCheckUncheck) ? (_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].amount * item.percentage) / 100 : 0;
          } else {
            item.taxAmount = (_purchaseInvoiceReturnList[index].invoiceReturnDetailList[i].amount * item.percentage) / 100;
          }
        });

        _purchaseInvoiceReturnList[index].invoiceReturnTaxList.forEach((item) {
          double _taxAmount = 0;
          _purchaseInvoiceReturnList[index].invoiceReturnDetailList.forEach((f) {
            f.invoiceReturnDetailTaxList.forEach((invoiceReturnDetailTax) {
              if (item.taxId == invoiceReturnDetailTax.taxId) {
                _taxAmount += invoiceReturnDetailTax.taxAmount;
              }
            });
          });
          item.totalAmount = _taxAmount;
          //   print('${item.taxId}: $_taxAmount');
        });
        _purchaseInvoiceReturnList[index].finalTax = (isRefundTax) ? _purchaseInvoiceReturnList[index].invoiceReturnTaxList.map((f) => f.totalAmount).reduce((sum, amt) => sum + amt) : 0;
      } else if (_purchaseInvoiceReturnList[index].invoiceReturnTaxList.length > 0) {
        // if product wise tax isnt applied on purchase invoice
        _purchaseInvoiceReturnList[index].invoiceReturnTaxList.forEach((item) {
          item.totalAmount = (item.percentage * _purchaseInvoiceReturnList[index].grossAmount) / 100;
        });
        _purchaseInvoiceReturnList[index].finalTax = (isRefundTax) ? _purchaseInvoiceReturnList[index].invoiceReturnTaxList.map((f) => f.totalAmount).reduce((sum, amt) => sum + amt) : 0;
      }
    } catch (e) {
      print('Exception - PurchaseInvoiceReturnAddScreen.dart - _calculateTaxAmount(): ' + e.toString());
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
          //   _date=picked;
          _cInvoiceDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
          _invoiceDate2 = picked.toString().substring(0, 10);
        });
      }
      _purchaseInvoiceReturnList.map((f) => f.invoiceDate = DateTime.parse(_invoiceDate2)).toList();
    } catch (e) {
      print('Exception - PurchaseInvoiceReturnAddScreen.dart - _selectDate(): ' + e.toString());
    }
  }

  Future _addPaymentMethod() async {
    try {
      if (_finalTotal > 0) {
        _remainAmount = (_payment.paymentDetailList.length != 0) ? _finalTotal - _payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount) : _finalTotal;
        if (_remainAmount >= 0) {
          await showDialog(
              context: context,
              builder: (_) {
                return PaymentAddDialog(
                  remainAmountToPay: _remainAmount,
                  paymentDetail: (object) {
                    _payment.paymentDetailList.add(object);
                    _payment.paymentDetailList[_payment.paymentDetailList.length - 1].isRecentlyAdded = (purchaseReturnList != null) ? true : false;
                  },
                );
              });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['lbl_err_vld_payment']}')));
        }
        setState(() {
          // FocusScope.of(context).requestFocus(_focusNode);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_inv_return_product_err_vld'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_inv_return_service_err_vld'] : global.appLocaleValues['tle_inv_return_both_err_vld']}'),
        ));
      }
    } catch (e) {
      print('Exception - purchaseInvoiceAddScreen.dart - _addPaymentMethod(): ' + e.toString());
    }
  }
}
