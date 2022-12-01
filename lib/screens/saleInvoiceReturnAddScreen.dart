// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/dialogs/paymentAddDialog.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceReturnModel.dart';
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnDetailTaxModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnTaxModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/models/unitCombinationModel.dart';
import 'package:accounting_app/screens/saleInvoiceReturnScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ulid/ulid.dart';

class SaleInvoiceReturnAddScreen extends BaseRoute {
  final List<SaleInvoice> saleInvoiceList;
  final List<SaleInvoiceReturn> saleReturnList;
  final bool isTransactionUpdate;
  SaleInvoiceReturnAddScreen({@required a, @required o, this.saleInvoiceList, this.saleReturnList, this.isTransactionUpdate}) : super(a: a, o: o, r: 'SaleInvoiceReturnAddScreen');
  @override
  _SaleInvoiceReturnAddScreenState createState() => _SaleInvoiceReturnAddScreenState(this.saleInvoiceList, this.saleReturnList, this.isTransactionUpdate);
}

class _SaleInvoiceReturnAddScreenState extends BaseRouteState {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool isTransactionUpdate;
  List<SaleInvoice> saleInvoiceList;
  final List<SaleInvoiceReturn> saleReturnList;
  List<SaleInvoiceReturn> _saleInvoiceReturnList = [];
  bool _dataLoaded = false;
  bool isRefundTax = true;
  double _total = 0;
  double _finalTotal = 0;
  List<TaxMaster> _taxList = [];
  bool _autoValidate = false;
  var _cInvoiceDate = TextEditingController();
  String _invoiceDate2;
  String _transactioGroupId = '';
  Payment _payment = Payment();
  double _remainAmount = 0;
  List<UnitCombination> _unitCombinationList;

  _SaleInvoiceReturnAddScreenState(this.saleInvoiceList, this.saleReturnList, this.isTransactionUpdate) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text((saleReturnList == null) ? global.appLocaleValues['tle_add_return'] : global.appLocaleValues['tle_update_return']),
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
                    builder: (context) => SaleInvoiceReturnScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        )));
                return null;
              },
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: (_autoValidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 10, left: 5),
                          child: Text(global.appLocaleValues['lbl_inv_return_date'], style: Theme.of(context).primaryTextTheme.headline3),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: nativeTheme().inputDecorationTheme.border,
                              // labelText: global.appLocaleValues['lbl_inv_return_date'],
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
                          itemCount: _saleInvoiceReturnList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                          '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleInvoiceReturnList[index].invoiceNumber.toString().length))}${_saleInvoiceReturnList[index].invoiceNumber} - ${br.generateAccountName(_saleInvoiceReturnList[index].account)}',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).primaryColor)),
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
                                  itemCount: _saleInvoiceReturnList[index].invoiceReturnDetailList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    return CheckboxListTile(
                                      title: ListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          title: Text(
                                              '${_saleInvoiceReturnList[index].invoiceReturnDetailList[i].productName} - ${global.currency.symbol} ${_saleInvoiceReturnList[index].invoiceReturnDetailList[i].soldUnitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'),
                                          subtitle: Text((br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                              ? '${global.appLocaleValues['lbl_sold_qty']}: ${_saleInvoiceReturnList[index].invoiceReturnDetailList[i].quantity} ${_saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitCode}'
                                              : '${global.appLocaleValues['lbl_sold_qty']}: ${_saleInvoiceReturnList[index].invoiceReturnDetailList[i].quantity}'),
                                          trailing: (_saleInvoiceReturnList[index].invoiceReturnDetailList[i].isSelect)
                                              ? Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                                        ? SizedBox(
                                                            width: 55,
                                                            child: TextFormField(
                                                              readOnly: true,
                                                              initialValue: '${_saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitCode}',
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
                                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.0]"))],
                                                          initialValue: '${_saleInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity}',
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
                                                            } else if (_saleInvoiceReturnList[index].invoiceReturnDetailList[i].isSelect && double.parse(v) > _saleInvoiceReturnList[index].invoiceReturnDetailList[i].quantity) {
                                                              return global.appLocaleValues['lbl_rQty_err_vld'];
                                                            }
                                                            return null;
                                                          },
                                                          onChanged: (value) {
                                                            try {
                                                              _saleInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity = (value.length > 0) ? double.parse(value) : 0;
                                                              if (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
                                                                if (_saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitId == _saleInvoiceReturnList[index].invoiceReturnDetailList[i].productUnitId) // if product unit and sold unit is same
                                                                {
                                                                  _saleInvoiceReturnList[index].invoiceReturnDetailList[i].amount = _saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitPrice * _saleInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity;
                                                                } else {
                                                                  UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == _saleInvoiceReturnList[index].invoiceReturnDetailList[i].product.unitCombinationId);
                                                                  if (_unitCombination.primaryUnitId == _saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitId) {
                                                                    _saleInvoiceReturnList[index].invoiceReturnDetailList[i].amount = (_saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitPrice * _saleInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity);
                                                                  } else if (_unitCombination.secondaryUnitId == _saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitId) {
                                                                    _saleInvoiceReturnList[index].invoiceReturnDetailList[i].amount =
                                                                        (_saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitPrice * _saleInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity) / _saleInvoiceReturnList[index].invoiceReturnDetailList[i].quantity;
                                                                  }
                                                                }
                                                              } else {
                                                                _saleInvoiceReturnList[index].invoiceReturnDetailList[i].amount = _saleInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity * _saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitPrice;
                                                              }
                                                              _saleInvoiceReturnList[index].netAmount = _saleInvoiceReturnList[index].invoiceReturnDetailList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
                                                              _calculateTaxAmount(index, i);
                                                              _calculate(_saleInvoiceReturnList[index]);
                                                              setState(() {});
                                                            } catch (e) {
                                                              print('Exception - saleInvoiceReturnAddScreen.dart - rQty_onChanged(): ' + e.toString());
                                                            }
                                                          },
                                                        )),
                                                  ],
                                                )
                                              : SizedBox()),
                                      value: _saleInvoiceReturnList[index].invoiceReturnDetailList[i].isSelect,
                                      onChanged: (value) async {
                                        try {
                                          if (_saleInvoiceReturnList[index].invoiceReturnDetailList[i].product == null) {
                                            List<Product> _productList = await dbHelper.productGetList(productId: [_saleInvoiceReturnList[index].invoiceReturnDetailList[i].productId]);
                                            _saleInvoiceReturnList[index].invoiceReturnDetailList[i].product = (_productList.length > 0) ? _productList[0] : null;
                                          }
                                          _saleInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity = (value) ? _saleInvoiceReturnList[index].invoiceReturnDetailList[i].quantity : 0;
                                          if (_saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitId == _saleInvoiceReturnList[index].invoiceReturnDetailList[i].productUnitId) // if product unit and sold unit is same
                                          {
                                            _saleInvoiceReturnList[index].invoiceReturnDetailList[i].amount = (value) ? _saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitPrice * _saleInvoiceReturnList[index].invoiceReturnDetailList[i].quantity : 0;
                                          } else {
                                            UnitCombination _unitCombination = _unitCombinationList.firstWhere((element) => element.id == _saleInvoiceReturnList[index].invoiceReturnDetailList[i].product.unitCombinationId);
                                            if (_unitCombination.primaryUnitId == _saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitId) {
                                              _saleInvoiceReturnList[index].invoiceReturnDetailList[i].amount = (value) ? (_saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitPrice * _saleInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity) : 0;
                                            } else if (_unitCombination.secondaryUnitId == _saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitId) {
                                              _saleInvoiceReturnList[index].invoiceReturnDetailList[i].amount =
                                                  (value) ? (_saleInvoiceReturnList[index].invoiceReturnDetailList[i].unitPrice * _saleInvoiceReturnList[index].invoiceReturnDetailList[i].returnQuantity) / _saleInvoiceReturnList[index].invoiceReturnDetailList[i].quantity : 0;
                                            }
                                          }
                                          _saleInvoiceReturnList[index].netAmount = _saleInvoiceReturnList[index].invoiceReturnDetailList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
                                          _saleInvoiceReturnList[index].invoiceReturnDetailList[i].isSelect = value;
                                          _calculateTaxAmount(index, i, isCheckUncheck: value);
                                          _calculate(_saleInvoiceReturnList[index]);
                                          setState(() {});
                                        } catch (e) {
                                          print('Exception - saleInvoiceReturnAddScreen.dart - checkBox_onChanged(): ' + e.toString());
                                        }
                                      },
                                    );
                                  },
                                ),
                                ((_saleInvoiceReturnList.length - 1) != index) ? Divider() : SizedBox()
                              ],
                            );
                          },
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: <Widget>[
                              Column(
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
                                                if (saleReturnList == null) {
                                                  setState(() {
                                                    isRefundTax = value;

                                                    if (!value) {
                                                      _saleInvoiceReturnList.map((f) => f.finalTax = 0).toList();
                                                      _saleInvoiceReturnList.map((f) => f.grossAmount = f.netAmount).toList();
                                                      _finalTotal = _total;
                                                    } else {
                                                      _saleInvoiceReturnList.forEach((item) {
                                                        item.finalTax = item.invoiceReturnTaxList.map((f) => f.totalAmount).reduce((sum, amt) => sum + amt);
                                                        item.grossAmount = item.finalTax + item.netAmount;
                                                      });
                                                      _finalTotal = _saleInvoiceReturnList.map((f) => f.grossAmount).reduce((sum, amt) => sum + amt);
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
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: <Widget>[
                              (saleReturnList == null || (isTransactionUpdate != null && isTransactionUpdate))
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
                                                  child: (saleReturnList == null || _payment.paymentDetailList[index].isRecentlyAdded == true)
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
      if (saleReturnList == null) {
        _cInvoiceDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _invoiceDate2 = DateTime.now().toString().substring(0, 10);
        await _getData();
      } else {
        await _fetchData();
      }
      _dataLoaded = true;
    } catch (e) {
      print('Exception - saleInvoiceReturnAddScreen.dart - _getDetails(): ' + e.toString());
    }
  }

  Future _getData() async {
    try {
      _transactioGroupId = Ulid().toUuid();
      for (int i = 0; i < saleInvoiceList.length; i++) {
        saleInvoiceList[i].invoiceDetailList = await dbHelper.saleInvoiceDetailGetList(invoiceIdList: [saleInvoiceList[i].id]);
        saleInvoiceList[i].invoiceTaxList = await dbHelper.saleInvoiceTaxGetList(invoiceId: saleInvoiceList[i].id);
        saleInvoiceList[i].invoiceDetailTaxList = await dbHelper.saleInvoiceDetailTaxGetList(invoiceDetailIdList: saleInvoiceList[i].invoiceDetailList.map((item) => item.id).toList());
        SaleInvoiceReturn _saleInvoiceReturn = SaleInvoiceReturn(null, saleInvoiceList[i].id, _transactioGroupId, saleInvoiceList[i].invoiceNumber, saleInvoiceList[i].accountId, 0, 0, 0, 0, DateTime.parse(_invoiceDate2), true, "PENDING", saleInvoiceList[i].account);
        saleInvoiceList[i].invoiceTaxList.forEach((f) {
          SaleInvoiceReturnTax _saleInvoiceReturnTax = SaleInvoiceReturnTax(null, null, f.taxId, f.percentage, 0);
          _saleInvoiceReturn.invoiceReturnTaxList.add(_saleInvoiceReturnTax);
        });

        saleInvoiceList[i].invoiceDetailList.forEach((f) {
          SaleInvoiceReturnDetail _saleInvoiceReturnDetail =
              SaleInvoiceReturnDetail(null, saleInvoiceList[i].id, null, f.productId, f.unitId, f.productUnitId, f.unitCode, f.quantity, f.unitPrice, f.unitPrice, 0, f.productName, f.productCode, f.productTypeName, f.actualUnitPrice, f.isDelete, null, null, 0);
          saleInvoiceList[i].invoiceDetailTaxList.forEach((item) {
            if (f.id == item.invoiceDetailId) {
              SaleInvoiceReturnDetailTax _saleInvoiceReturnDetailTax = SaleInvoiceReturnDetailTax(null, null, item.taxId, item.percentage, 0);
              _saleInvoiceReturnDetail.invoiceReturnDetailTaxList.add(_saleInvoiceReturnDetailTax);
            }
          });
          _saleInvoiceReturn.invoiceReturnDetailList.add(_saleInvoiceReturnDetail);
          //   _saleInvoiceReturn.cList.add(TextEditingController());
        });
        _saleInvoiceReturnList.add(_saleInvoiceReturn);
      }

      List<int> _taxIdList = [];
      saleInvoiceList.forEach((saleInvoice) {
        saleInvoice.invoiceTaxList.forEach((invoiceTax) {
          _taxIdList.add(invoiceTax.taxId);
        });
      });

      _taxList = await dbHelper.taxMasterGetList(taxMasterIdList: _taxIdList);

      setState(() {});
    } catch (e) {
      print('Exception - saleInvoiceReturnAddScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _fetchData() async {
    try {
      _cInvoiceDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(saleReturnList[0].invoiceDate);
      _invoiceDate2 = saleReturnList[0].invoiceDate.toString();

      saleInvoiceList = await dbHelper.saleInvoiceGetList(invoiceIdList: saleReturnList.map((f) => f.saleInvoiceId).toList());

      for (int i = 0; i < saleInvoiceList.length; i++) {
        saleInvoiceList[i].invoiceDetailList = await dbHelper.saleInvoiceDetailGetList(invoiceIdList: [saleInvoiceList[i].id]);
        saleInvoiceList[i].invoiceTaxList = await dbHelper.saleInvoiceTaxGetList(invoiceId: saleInvoiceList[i].id);
        saleInvoiceList[i].invoiceDetailTaxList = await dbHelper.saleInvoiceDetailTaxGetList(invoiceDetailIdList: saleInvoiceList[i].invoiceDetailList.map((item) => item.id).toList());

        SaleInvoiceReturn _saleInvoiceReturn = saleReturnList[i];
        _saleInvoiceReturn.invoiceReturnTaxList = await dbHelper.saleInvoiceReturnTaxGetList(invoiceReturnId: _saleInvoiceReturn.id);
        List<SaleInvoiceReturnDetail> _temp = await dbHelper.saleInvoiceReturnDetailGetList(invoiceReturnId: _saleInvoiceReturn.id);

        for (int j = 0; j < saleInvoiceList[i].invoiceDetailList.length; j++) {
          SaleInvoiceReturnDetail _saleInvoiceReturnDetail;
          bool positionIsExist = _temp.map((ird) => ird.productId).contains(saleInvoiceList[i].invoiceDetailList[j].productId);
          if (!positionIsExist) {
            _saleInvoiceReturnDetail = SaleInvoiceReturnDetail(
                null,
                saleInvoiceList[i].id,
                null,
                saleInvoiceList[i].invoiceDetailList[j].productId,
                saleInvoiceList[i].invoiceDetailList[j].unitId,
                saleInvoiceList[i].invoiceDetailList[j].productUnitId,
                saleInvoiceList[i].invoiceDetailList[j].unitCode,
                saleInvoiceList[i].invoiceDetailList[j].quantity,
                saleInvoiceList[i].invoiceDetailList[j].unitPrice,
                saleInvoiceList[i].invoiceDetailList[j].unitPrice,
                0,
                saleInvoiceList[i].invoiceDetailList[j].productName,
                saleInvoiceList[i].invoiceDetailList[j].productCode,
                saleInvoiceList[i].invoiceDetailList[j].productTypeName,
                saleInvoiceList[i].invoiceDetailList[j].actualUnitPrice,
                saleInvoiceList[i].invoiceDetailList[j].isDelete,
                null,
                null,
                0);

            saleInvoiceList[i].invoiceDetailTaxList.forEach((item) {
              if (saleInvoiceList[i].invoiceDetailList[j].id == item.invoiceDetailId) {
                SaleInvoiceReturnDetailTax _saleInvoiceReturnDetailTax = SaleInvoiceReturnDetailTax(null, null, item.taxId, item.percentage, 0);
                _saleInvoiceReturnDetail.invoiceReturnDetailTaxList.add(_saleInvoiceReturnDetailTax);
              }
            });
          } else {
            for (int k = 0; k < _temp.length; k++) {
              if (saleInvoiceList[i].invoiceDetailList[j].productId == _temp[k].productId) {
                _temp[k].isSelect = true;
                _temp[k].returnQuantity = _temp[k].quantity;
                _temp[k].quantity = saleInvoiceList[i].invoiceDetailList[j].quantity;
                _temp[k].invoiceReturnDetailTaxList = await dbHelper.saleInvoiceReturnDetailTaxGetList(invoiceReturnDetailIdList: [_temp[k].id]);
                _saleInvoiceReturnDetail = _temp[k];
              }
            }
          }
          _saleInvoiceReturn.invoiceReturnDetailList.add(_saleInvoiceReturnDetail);
          //  _saleInvoiceReturn.cList.add(TextEditingController());
        }
        _saleInvoiceReturnList.add(_saleInvoiceReturn);
      }

      _total = _saleInvoiceReturnList.map((f) => f.netAmount).reduce((sum, amt) => sum + amt);
      _finalTotal = _saleInvoiceReturnList.map((f) => f.grossAmount).reduce((sum, amt) => sum + amt);

      if (_total != _finalTotal) {
        List<int> _taxId = [];
        _saleInvoiceReturnList.forEach((item) {
          item.invoiceReturnTaxList.forEach((f) {
            _taxId.add(f.taxId);
          });
        });

        _taxList = await dbHelper.taxMasterGetList(taxMasterIdList: _taxId.toSet().toList());

        _taxList.forEach((f) {
          double _taxAmt = 0;
          _saleInvoiceReturnList.forEach((item) {
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
      List<PaymentSaleInvoiceReturn> _paymentSaleInvoiceReturnList = await dbHelper.paymentSaleInvoiceReturnGetList(transactionGroupId: _saleInvoiceReturnList[0].transactionGroupId);
      _payment.paymentDetailList = (_paymentSaleInvoiceReturnList.length > 0) ? await dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleInvoiceReturnList.map((f) => f.paymentId).toList()) : [];

      setState(() {});
    } catch (e) {
      print('Exception - saleInvoiceReturnAddScreen.dart - _fetchData(): ' + e.toString());
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
            _saleInvoiceReturnList.map((f) => f.status = 'REFUNDED').toList();
          } else {
            _saleInvoiceReturnList.map((f) => f.status = 'PENDING').toList();
          }
          if (saleReturnList == null) {
            await dbHelper.saleInvoiceReturnInsert(_saleInvoiceReturnList, isRefundTax, _payment);
          } else {
            await dbHelper.saleInvoiceReturnUpdate(saleInvoiceReturnList: _saleInvoiceReturnList, isRefundTax: isRefundTax, updateFrom: 1, payment: _payment);
          }
          hideLoader();
          setState(() {});
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SaleInvoiceReturnScreen(
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
      print('Exception - saleInvoiceReturnAddScreen.dart - _onSubmit(): ' + e.toString());
    }
  }

  void _calculate(SaleInvoiceReturn _saleInvoiceReturn) {
    try {
      _saleInvoiceReturn.grossAmount = (isRefundTax) ? _saleInvoiceReturn.netAmount + _saleInvoiceReturn.finalTax : _saleInvoiceReturn.netAmount;
      _total = _saleInvoiceReturnList.map((f) => f.netAmount).reduce((sum, amt) => sum + amt);
      _finalTotal = _saleInvoiceReturnList.map((f) => f.grossAmount).reduce((sum, amt) => sum + amt);

      _taxList.forEach((item) {
        double _totalamount = 0;
        _saleInvoiceReturnList.forEach((f) {
          f.invoiceReturnTaxList.forEach((invoiceReturnTax) {
            if (item.id == invoiceReturnTax.taxId) {
              _totalamount += invoiceReturnTax.totalAmount;
            }
          });
        });
        item.taxAmount = _totalamount;
      });
    } catch (e) {
      print('Exception - saleInvoiceReturnAddScreen.dart - _calculate(): ' + e.toString());
    }
  }

  void _calculateTaxAmount(int index, int i, {bool isCheckUncheck}) {
    try {
      if (_saleInvoiceReturnList[index].invoiceReturnDetailList[i].invoiceReturnDetailTaxList.length > 0) // if product wise tax applied on sale invoice
      {
        _saleInvoiceReturnList[index].invoiceReturnDetailList[i].invoiceReturnDetailTaxList.forEach((item) {
          if (isCheckUncheck != null) {
            item.taxAmount = (isCheckUncheck) ? (_saleInvoiceReturnList[index].invoiceReturnDetailList[i].amount * item.percentage) / 100 : 0;
          } else {
            item.taxAmount = (_saleInvoiceReturnList[index].invoiceReturnDetailList[i].amount * item.percentage) / 100;
          }
        });

        _saleInvoiceReturnList[index].invoiceReturnTaxList.forEach((item) {
          double _taxAmount = 0;
          _saleInvoiceReturnList[index].invoiceReturnDetailList.forEach((f) {
            f.invoiceReturnDetailTaxList.forEach((invoiceReturnDetailTax) {
              if (item.taxId == invoiceReturnDetailTax.taxId) {
                _taxAmount += invoiceReturnDetailTax.taxAmount;
              }
            });
          });
          item.totalAmount = _taxAmount;
        });
        _saleInvoiceReturnList[index].finalTax = (isRefundTax) ? _saleInvoiceReturnList[index].invoiceReturnTaxList.map((f) => f.totalAmount).reduce((sum, amt) => sum + amt) : 0;
      } else if (_saleInvoiceReturnList[index].invoiceReturnTaxList.length > 0) {
        // if product wise tax isnt applied on sale invoice
        _saleInvoiceReturnList[index].invoiceReturnTaxList.forEach((item) {
          item.totalAmount = (item.percentage * _saleInvoiceReturnList[index].netAmount) / 100;
        });
        _saleInvoiceReturnList[index].finalTax = (isRefundTax) ? _saleInvoiceReturnList[index].invoiceReturnTaxList.map((f) => f.totalAmount).reduce((sum, amt) => sum + amt) : 0;
      }
    } catch (e) {
      print('Exception - saleInvoiceReturnAddScreen.dart - _calculateTaxAmount(): ' + e.toString());
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
      _saleInvoiceReturnList.map((f) => f.invoiceDate = DateTime.parse(_invoiceDate2)).toList();
    } catch (e) {
      print('Exception - saleInvoiceReturnAddScreen.dart - _selectDate(): ' + e.toString());
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
                    _payment.paymentDetailList[_payment.paymentDetailList.length - 1].isRecentlyAdded = (saleReturnList != null) ? true : false;
                  },
                );
              });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['lbl_err_vld_payment']}')));
        }
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_inv_return_product_err_vld'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_inv_return_service_err_vld'] : global.appLocaleValues['tle_inv_return_both_err_vld']}'),
        ));
      }
    } catch (e) {
      print('Exception - saleInvoiceReturnAddScreen.dart - _addPaymentMethod(): ' + e.toString());
    }
  }
}
