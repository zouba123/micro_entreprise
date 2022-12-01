// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/saleOrderModel.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/dialogs/paymentAddDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnModel.dart';

import 'package:accounting_app/screens/AccountDetailScreen.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/paymentScreen.dart';
import 'package:accounting_app/screens/purchaseInvoiceReturnScreen.dart';
import 'package:accounting_app/screens/purchaseInvoiceScreen.dart';
import 'package:accounting_app/screens/saleInvoiceReturnScreen.dart';
import 'package:accounting_app/screens/saleInvoiceScreen.dart';
import 'package:accounting_app/screens/saleOrderScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';

class PaymentAddScreen extends BaseRoute {
  final Payment payment;
  final SaleOrder saleOrder;
  final SaleInvoice saleInvoice;
  final PurchaseInvoice purchaseInvoice;
  final int returnScreenId;
  final Account account;
  final SaleInvoiceReturn saleInvoiceReturn;
  final PurchaseInvoiceReturn purchaseInvoiceReturn;

  PaymentAddScreen({@required a, @required o, @required this.returnScreenId, this.payment, this.saleInvoice, this.account, this.purchaseInvoice, this.saleInvoiceReturn, this.purchaseInvoiceReturn, this.saleOrder}) : super(a: a, o: o, r: 'PaymentAddScreen');
  @override
  _PaymentAddScreenState createState() => _PaymentAddScreenState(this.payment, this.saleInvoice, this.returnScreenId, this.account, this.purchaseInvoice, this.saleInvoiceReturn, this.purchaseInvoiceReturn, this.saleOrder);
}

class _PaymentAddScreenState extends BaseRouteState {
  Payment payment;
  final SaleInvoice saleInvoice;
  final SaleOrder saleOrder;
  final PurchaseInvoice purchaseInvoice;
  final int returnScreenId;
  final SaleInvoiceReturn saleInvoiceReturn;
  final PurchaseInvoiceReturn purchaseInvoiceReturn;
  final Account account;
  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();
  final _fAccountId =  FocusNode();
  final _fTransactioDate =  FocusNode();
  final _focusNode =  FocusNode();
  TextEditingController _cAccountId =  TextEditingController();
  TextEditingController _cTransactionDate =  TextEditingController();
  TextEditingController _cRemark =  TextEditingController();
  TextEditingController _cInvoiceId =  TextEditingController();
  // TextEditingController _cOrderId =  TextEditingController();
  var _formKey = GlobalKey<FormState>();
  int _selectedType = 0;
  String _paymentType = 'RECEIVED';
  double _totalAmount = 0;
  String _transactionDate2;
  Account _account;
  double _remainAmount = 0.0;
  bool _autovalidate = false;
  bool _isDataLoaded = false;

  _PaymentAddScreenState(this.payment, this.saleInvoice, this.returnScreenId, this.account, this.purchaseInvoice, this.saleInvoiceReturn, this.purchaseInvoiceReturn,  this.saleOrder) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: (payment.id == null) ? Text(global.appLocaleValues['lbl_add_payment'], style: Theme.of(context).appBarTheme.titleTextStyle,) : Text(global.appLocaleValues['lbl_update_payment'],style: Theme.of(context).appBarTheme.titleTextStyle),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await _onSave();
              },
              child: Text(global.appLocaleValues['btn_save'],style: Theme.of(context).primaryTextTheme.headline2),
            )
          ],
        ),
        body: (_isDataLoaded)
            ? Scrollbar(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                   autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //  (payment.id == null || (payment.id != null && payment.accountId != null))
                                    // ? 
                                    Text(global.appLocaleValues['lbl_choose_ac'],style: Theme.of(context).primaryTextTheme.headline3),
                                      //  : SizedBox(),
                                // (payment.id == null || (payment.id != null && payment.accountId != null))
                                //     ? 
                                    Padding(
                                        padding: EdgeInsets.only(top: 5,bottom: 10),
                                        child: TextFormField(
                                          controller: _cAccountId,
                                          focusNode: _fAccountId,
                                          readOnly: true,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: global.appLocaleValues['lbl_choose_ac'],
                                           
                                            border: nativeTheme().inputDecorationTheme.border,
                                            suffixIcon: Icon(
                                              Icons.star,
                                              size: 9,
                                              color: Colors.red,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return '${global.appLocaleValues['lbl_choose_ac_err_req']}';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    // : SizedBox(),
                                   (saleInvoice != null || payment.invoiceNumber != null || purchaseInvoice != null) 
                                    ?
                                     Text(global.appLocaleValues['lbl_inv_no'],style: Theme.of(context).primaryTextTheme.headline3)
                                      : SizedBox(),
                                (saleInvoice != null || payment.invoiceNumber != null || purchaseInvoice != null)
                                    ? 
                                    
                                    Padding(
                                       padding: EdgeInsets.only(top: 5,bottom: 10),
                                        child: TextFormField(
                                          controller: _cInvoiceId,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            border: nativeTheme().inputDecorationTheme.border,
                                            hintText: global.appLocaleValues['lbl_inv_no'],
                                            suffixIcon: Icon(
                                              Icons.star,
                                              size: 9,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ) : SizedBox(),
                                //     (quote.saleQuoteNumber != null)
                                //       ? 
                                //       Text(global.appLocaleValues['lbl_sale_order_no'],style: Theme.of(context).primaryTextTheme.headline3) : SizedBox(),
                                // (quote.saleQuoteNumber != null )
                                //     ?
                                //      Padding(
                                //        padding: EdgeInsets.only(top: 5,bottom: 10),
                                //         child: TextFormField(
                                //           controller: _cOrderId,
                                //           readOnly: true,
                                //           decoration: InputDecoration(
                                //             border: nativeTheme().inputDecorationTheme.border,
                                //              hintText: global.appLocaleValues['lbl_sale_order_no'],
                                //             suffixIcon: Icon(
                                //               Icons.star,
                                //               size: 9,
                                //               color: Colors.red,
                                //             ),
                                //           ),
                                //         ),
                                //       ) : SizedBox(),
                                    
                                    
                                     Text(global.appLocaleValues['lbl_transaction_date'],style: Theme.of(context).primaryTextTheme.headline3),
                                Padding(
                                  padding: EdgeInsets.only(top: 5,bottom: 10),
                                  child: TextFormField(
                                    readOnly: true,
                                    focusNode: _fTransactioDate,
                                    decoration: InputDecoration(
                                      // labelText: global.appLocaleValues['lbl_transaction_date'],
                                      suffixIcon: Icon(
                                        Icons.star,
                                        size: 9,
                                        color: Colors.red,
                                      ),
                                      border: nativeTheme().inputDecorationTheme.border,
                                    ),
                                    controller: _cTransactionDate,
                                    keyboardType: null,
                                    validator: (v) {
                                      if (v.isEmpty) {
                                        return global.appLocaleValues['lbl_transaction_err_req'];
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                 Text(global.appLocaleValues['lbl_note_remark'],style: Theme.of(context).primaryTextTheme.headline3),
                                Padding(
                                  padding: EdgeInsets.only(top: 5,bottom: 10),
                                  child: TextFormField(
                                    maxLines: 8,
                                    controller: _cRemark,
                                    decoration: InputDecoration(
                                      hintText: global.appLocaleValues['lbl_note_remark'],
                                      // labelText: '${global.appLocaleValues['lbl_note_remark']} (${global.appLocaleValues['lbl_optional']})',
                                      border: nativeTheme().inputDecorationTheme.border,
                                      alignLabelWithHint: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                           Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                             child: Align(
                               alignment: Alignment.centerLeft,
                               child: Text(global.appLocaleValues['lbl_payment_type'],style: Theme.of(context).primaryTextTheme.headline3)),
                           ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10,top: 5,bottom: 5),
                            child: Container(
                              // height: ,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Color(0xFF7c7e7d))),
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    child: RadioListTile(
                                      dense: false,
                                      value: 0,
                                      groupValue: _selectedType,
                                      title: Text(
                                        global.appLocaleValues['lbl_received'],
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      onChanged: (int value) {
                                        _onTypeChange(value);
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    child: RadioListTile(
                                      dense: false,
                                      value: 1,
                                      groupValue: _selectedType,
                                      title: Text(
                                        global.appLocaleValues['lbl_given'],
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      onChanged: (int value) {
                                        _onTypeChange(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 10,right: 10),
                            title: Text(
                              '${global.appLocaleValues['lbl_tot_amount']}',
                              style: Theme.of(context).primaryTextTheme.headline3
                            ),
                            trailing: Text(
                              '${global.currency.symbol} ${_totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                             style: Theme.of(context).primaryTextTheme.headline5
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: <Widget>[
                                (payment.id == null)
                                    ? SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                         
                                          child: Text(global.appLocaleValues['btn_add_payment_detail'],  style: Theme.of(context).primaryTextTheme.headline2),
                                          onPressed: () async {
                                            await _addPaymentMethods();
                                          },
                                        ),
                                    )
                                    : Text(
                                        global.appLocaleValues['lbl_payment_methods'],
                                        style: Theme.of(context).primaryTextTheme.headline2
                                      ),
                                // ListView.builder(
                                //   itemCount: 2,
                                //   physics: NeverScrollableScrollPhysics(),
                                //   shrinkWrap: true,
                                //   itemBuilder: (context, index) {
                                //     return Row(
                                //       mainAxisSize: MainAxisSize.min,
                                //       children: <Widget>[
                                //         SizedBox(
                                //           width: 20,
                                //           child:
                                //           //  (payment.id == null)
                                //           //     ? 
                                //               IconButton(
                                //                   icon: Icon(
                                //                     Icons.cancel,
                                //                     color: Colors.red,
                                //                   ),
                                //                   onPressed: () {
                                //                     _totalAmount -= payment.paymentDetailList[index].amount;
                                //                     payment.paymentDetailList.removeAt(index);
                                //                     setState(() {});
                                //                   },
                                //                 )
                                //               // : SizedBox(),
                                //         ),
                                //         Expanded(
                                //           child: SizedBox(
                                //             height: 55,
                                //             child: ListTile(
                                //                 title: Text(
                                //                   'Mode',
                                //                   // '${payment.paymentDetailList[index].paymentMode}',
                                //                   style: TextStyle(color: Colors.grey, fontSize: 17),
                                //                 ),
                                //                 //    title: Text('${payment.paymentDetailList[index].paymentMode} - ${global.currency.symbol} ${payment.paymentDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'),
                                //                 subtitle: Text( 'Remark',),
                                //                 //  (payment.paymentDetailList[index].remark != null) ? Text('${payment.paymentDetailList[index].remark}') : null,
                                //                 //   subtitle: Text('${payment.paymentDetailList[index].remark}'),
                                //                 trailing: Text(
                                //                    '${global.currency.symbol} 100',
                                //                   // '${global.currency.symbol} ${payment.paymentDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                //                   style: TextStyle(fontSize: 17),
                                //                 )),
                                //           ),
                                //         )
                                //       ],
                                //     );
                                //   },
                                // ),
                              
                              ],
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
              ));
  }

  @override
  void dispose() {
    super.dispose();
    _fTransactioDate.removeListener(_dateListener);
    _fAccountId.removeListener(_accountListener);
  }

  @override
  void initState() {
    super.initState();
    _getInit();
  }

  Future _getInit() async {
    try {
      _fTransactioDate.addListener(_dateListener);
      _fAccountId.addListener(_accountListener);
      if (payment == null) {
        payment =  Payment();
        _cTransactionDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _transactionDate2 = DateTime.now().toString().substring(0, 10);

        if (saleInvoice != null) {
          _cInvoiceId.text = '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + saleInvoice.invoiceNumber.toString().length))}${saleInvoice.invoiceNumber}';
          _cAccountId.text = '${saleInvoice.account.firstName} ${saleInvoice.account.lastName}';
          //   '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + saleInvoice.account.accountCode.toString().length))}${saleInvoice.account.accountCode} - ${saleInvoice.account.firstName} ${saleInvoice.account.lastName}';
          payment.accountId = saleInvoice.accountId;
          if (returnScreenId == 2 || returnScreenId == 4) {
            _selectedType = 1;
            _paymentType = 'RECEIVED';
            saleInvoice.remainAmount = saleInvoice.remainAmount * -1;
          }
          saleInvoice.remainAmount = double.parse(saleInvoice.remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))));
        }
        //  else  if (purchaseInvoice != null) {
        //   _selectedType = 1;
        //   _paymentType = 'GIVEN';
        //   _cInvoiceId.text = '${purchaseInvoice.invoiceNumber}';
        //   _cAccountId.text = '${purchaseInvoice.account.firstName} ${purchaseInvoice.account.lastName}';
        //   //     '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + purchaseInvoice.account.accountCode.toString().length))}${purchaseInvoice.account.accountCode} - ${purchaseInvoice.account.firstName} ${purchaseInvoice.account.lastName}';
        //   payment.accountId = purchaseInvoice.accountId;
        //   purchaseInvoice.remainAmount = double.parse(purchaseInvoice.remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))));
        // } 
        // else if (saleInvoiceReturn != null) {
        //   if (returnScreenId == 9 || returnScreenId == 5 || returnScreenId == 3) {
        //     _selectedType = 1;
        //     _paymentType = 'GIVEN';
        //   } else {
        //     saleInvoiceReturn.remainAmount = saleInvoiceReturn.remainAmount * -1;
        //   }
        //   _cAccountId.text = '${saleInvoiceReturn.account.firstName} ${saleInvoiceReturn.account.lastName}';
        //   //      '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + saleInvoiceReturn.account.accountCode.toString().length))}${saleInvoiceReturn.account.accountCode} - ${saleInvoiceReturn.account.firstName} ${saleInvoiceReturn.account.lastName}';
        //   payment.accountId = saleInvoiceReturn.accountId;
        //   saleInvoiceReturn.remainAmount = double.parse(saleInvoiceReturn.remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))));
        // } 
        // else if (purchaseInvoiceReturn != null) {
        //   if (returnScreenId == 12 || returnScreenId == 6 || returnScreenId == 4) {
        //     _selectedType = 1;
        //     _paymentType = 'GIVEN';
        //     purchaseInvoiceReturn.remainAmount = purchaseInvoiceReturn.remainAmount * -1;
        //   }
        //   _cAccountId.text = '${purchaseInvoiceReturn.account.firstName} ${purchaseInvoiceReturn.account.lastName}';
        //   //  '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + purchaseInvoiceReturn.account.accountCode.toString().length))}${purchaseInvoiceReturn.account.accountCode} - ${purchaseInvoiceReturn.account.firstName} ${purchaseInvoiceReturn.account.lastName}';
        //   payment.accountId = purchaseInvoiceReturn.accountId;
        //   purchaseInvoiceReturn.remainAmount = double.parse(purchaseInvoiceReturn.remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))));
        // } 
        else if (saleOrder != null) {
          // _cOrderId.text = '${quote.saleQuoteNumber}';
          _cAccountId.text = '${saleOrder.account.firstName} ${saleOrder.account.lastName}';
          payment.accountId = saleOrder.accountId;
          if (returnScreenId == 14 || returnScreenId == 6 || returnScreenId == 4) {
            _selectedType = 1;
            _paymentType = 'RECEIVED';
            saleOrder.remainAmount = saleOrder.remainAmount * -1;
          }
          saleOrder.remainAmount = double.parse(saleOrder.remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))));
        }
        _isDataLoaded = true;
      } else {
        await _fetchDataForUpdate();
      }
    } catch (e) {
      print('Exception - paymentAddScreen.dart - _getInit(): ' + e.toString());
    }
  }

  Future _accountListener() async {
    try {
      // opening alert dialog for choose account
      if (payment.id == null && _fAccountId.hasFocus) {
        await Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) =>  AccountSelectDialog(
                      a: widget.analytics,
                      o: widget.observer,
                      returnScreenId: 0,
                      selectedAccount: (selectedAccount) {
                        if (selectedAccount.id != null) {
                          _account = selectedAccount;
                          //   String _code = '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _account.accountCode.toString().length))}${_account.accountCode}';
                          _cAccountId.text = '${_account.firstName} ${_account.lastName}';
                        }
                      },
                    )))
            .then((v) {
          if (_account == null) {
            if (v != null) {
              _account = v;
              //  String _code = '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _account.accountCode.toString().length))}${_account.accountCode}';
              _cAccountId.text = '${_account.firstName} ${_account.lastName}';
            }
          }
        });
        setState(() {
          FocusScope.of(context).requestFocus(_focusNode);
        });
      }
    } catch (e) {
      print('Exception - paymentAddScreen.dart - _accountListener(): ' + e.toString());
      return null;
    }
  }

  Future<Null> _dateListener() async {
    try {
      if (_fTransactioDate.hasFocus) {
        _selectDate(context); //open _cTransactionDate picker
      }
    } catch (e) {
      print('Exception - paymentAddScreen.dart - _dateListener(): ' + e.toString());
      return null;
    }
  }

  Future _fetchDataForUpdate() async {
    try {
      payment.paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: [payment.id]);
      if (payment.account != null) {
        _cAccountId.text = '${payment.account.firstName} ${payment.account.lastName}';
      }
      //   '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + payment.account.accountCode.toString().length))}${payment.account.accountCode} - ${payment.account.firstName} ${payment.account.lastName}';
      _cTransactionDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(payment.transactionDate);
      _transactionDate2 = payment.transactionDate.toString();
      _cRemark.text = payment.remark;
      _paymentType = payment.paymentType;
      _selectedType = (payment.paymentType == 'RECEIVED') ? 0 : 1;
      _totalAmount = payment.amount;
      _cInvoiceId.text = '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + payment.invoiceNumber.toString().length))}${payment.invoiceNumber}';
      // _cOrderId.text = "${payment.saleQuoteNumber}";
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - paymentAddScreen.dart - _fetchDataForUpdate(): ' + e.toString());
      return null;
    }
  }

  Future _onSave() async {
    try {
      if (payment.paymentDetailList.length != 0) {
        showLoader(global.appLocaleValues['txt_wait']);
        setState(() {});
        if (_formKey.currentState.validate()) {
          payment.accountId = (saleInvoice == null) ? (_account != null) ? _account.id : payment.accountId : saleInvoice.accountId;
          payment.amount = _totalAmount;
          payment.transactionDate = DateTime.parse(_transactionDate2);
          payment.paymentType = _paymentType;
          payment.remark = _cRemark.text.trim();

          if (payment.id == null) {
            payment = await dbHelper.paymentInsert(payment);
            if (returnScreenId != 0 && payment.id != null) {
              if (saleInvoice != null) {
                payment.paymentInvoice.paymentId = payment.id;
                payment.paymentInvoice.invoiceId = saleInvoice.id;
                payment.paymentInvoice.amount = payment.amount;
                payment.paymentInvoice = await dbHelper.paymentSaleInvoiceInsert(payment.paymentInvoice);

                if (payment.paymentInvoice.id != null && returnScreenId != 2) {
                  if ((saleInvoice.remainAmount - payment.amount) <= 0) {
                    saleInvoice.status = 'PAID';
                  } else {
                    saleInvoice.status = 'DUE';
                  }
                  await dbHelper.saleInvoiceUpdate(invoice: saleInvoice);
                }
              } else if (saleInvoiceReturn != null) {
                payment.paymentSaleInvoiceReturn.paymentId = payment.id;
                payment.paymentSaleInvoiceReturn.transactionGroupId = saleInvoiceReturn.transactionGroupId;
                payment.paymentSaleInvoiceReturn.amount = payment.amount;
                payment.paymentSaleInvoiceReturn = await dbHelper.paymentSaleInvoiceReturnInsert(payment.paymentSaleInvoiceReturn);

                if (payment.paymentSaleInvoiceReturn.id != null && returnScreenId != 10) {
                  if ((saleInvoiceReturn.remainAmount - payment.amount) <= 0) {
                    saleInvoiceReturn.childList.map((f) => f.status = 'REFUNDED').toList();
                  } else {
                    saleInvoiceReturn.childList.map((f) => f.status = 'PENDING').toList();
                  }
                  await dbHelper.saleInvoiceReturnUpdate(saleInvoiceReturnList: saleInvoiceReturn.childList, updateFrom: 0);
                }
              } else if (purchaseInvoice != null) {
                payment.paymentPurchaseInvoice.paymentId = payment.id;
                payment.paymentPurchaseInvoice.invoiceId = purchaseInvoice.id;
                payment.paymentPurchaseInvoice.amount = payment.amount;
                payment.paymentPurchaseInvoice = await dbHelper.paymentPurchaseInvoiceInsert(payment.paymentPurchaseInvoice);

                if (payment.paymentPurchaseInvoice.id != null && returnScreenId != 8) {
                  if ((purchaseInvoice.remainAmount - payment.amount) <= 0) {
                    purchaseInvoice.status = 'PAID';
                  } else {
                    purchaseInvoice.status = 'DUE';
                  }
                  await dbHelper.purchaseInvoiceUpdate(invoice: purchaseInvoice);
                }
              } else if (purchaseInvoiceReturn != null) {
                payment.paymentPurchaseInvoiceReturn.paymentId = payment.id;
                payment.paymentPurchaseInvoiceReturn.transactionGroupId = purchaseInvoiceReturn.transactionGroupId;
                payment.paymentPurchaseInvoiceReturn.amount = payment.amount;
                payment.paymentPurchaseInvoiceReturn = await dbHelper.paymentPurchaseInvoiceReturnInsert(payment.paymentPurchaseInvoiceReturn);

                if (payment.paymentPurchaseInvoiceReturn.id != null && returnScreenId != 12) {
                  if ((purchaseInvoiceReturn.remainAmount - payment.amount) <= 0) {
                    purchaseInvoiceReturn.childList.map((f) => f.status = 'REFUNDED').toList();
                  } else {
                    purchaseInvoiceReturn.childList.map((f) => f.status = 'PENDING').toList();
                  }
                  await dbHelper.purchaseInvoiceReturnUpdate(purchaseInvoiceReturnList: purchaseInvoiceReturn.childList, updateFrom: 0);
                }
              } else if (saleOrder != null) {
                // payment.paymentSaleOrder.paymentId = payment.id;
                // payment.paymentSaleOrder.saleOrderId = quote.id;
                // payment.paymentSaleOrder.amount = payment.amount;
                // payment.paymentSaleOrder = await dbHelper.paymentSaleQuoteInsert(payment.paymentSaleQuote);

                if (payment.paymentPurchaseInvoiceReturn.id != null && returnScreenId != 12) {
                  if ((purchaseInvoiceReturn.remainAmount - payment.amount) <= 0) {
                    purchaseInvoiceReturn.childList.map((f) => f.status = 'REFUNDED').toList();
                  } else {
                    purchaseInvoiceReturn.childList.map((f) => f.status = 'PENDING').toList();
                  }
                  await dbHelper.purchaseInvoiceReturnUpdate(purchaseInvoiceReturnList: purchaseInvoiceReturn.childList, updateFrom: 0);
                }
              }
            }
          } else {
            await dbHelper.paymentUpdate(payment);
          }
          hideLoader();
          setState(() {});
          if (returnScreenId == 0) {
             Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PaymentScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
          } else if (returnScreenId == 1 || returnScreenId == 2) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SaleInvoiceScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
          } else if (returnScreenId == 3 || returnScreenId == 4) {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AccountDetailScreen(
                      a: widget.analytics,
                      o: widget.observer,
                       account: account,
                    )));
          } else if (returnScreenId == 5 || returnScreenId == 6) {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DashboardScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
          } else if (returnScreenId == 7 || returnScreenId == 8) {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PurchaseInvoiceScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
          } else if (returnScreenId == 9 || returnScreenId == 10) {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SaleInvoiceReturnScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
          } else if (returnScreenId == 11 || returnScreenId == 12) {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PurchaseInvoiceReturnScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
          } else if (returnScreenId == 13 || returnScreenId == 14) {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SaleOrderScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
          }
        } else {
          _autovalidate = true;
          setState(() {});
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${global.appLocaleValues['tle_payment_err_req']}'),
        ));
      }
    } catch (e) {
      print('Exception - paymentAddScreen.dart - _onSave(): ' + e.toString());
      return null;
    }
  }

  void _onTypeChange(int value) {
    try {
      if (payment.id == null) {
        setState(() {
          _selectedType = value;
        });
        if (_selectedType == 0) {
          _paymentType = 'RECEIVED';
        } else {
          _paymentType = 'GIVEN';
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['tle_payment_err_vld']}')));
      }
    } catch (e) {
      print('Exception - paymentAddScreen.dart - _onTypeChange(): ' + e.toString());
      return null;
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
          _cTransactionDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
          _transactionDate2 = picked.toString().substring(0, 10);
        });
      }
      FocusScope.of(context).requestFocus(_focusNode);
    } catch (e) {
      print('Exception - paymentAddScreen.dart - _selectDate(): ' + e.toString());
      return null;
    }
  }

  Future _addPaymentMethods() async {
    try {
      if (returnScreenId != 0) {
        if (saleInvoice != null) {
          _remainAmount = (payment.paymentDetailList.length != 0) ? saleInvoice.remainAmount - payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount) : saleInvoice.remainAmount;
        } else if (saleInvoiceReturn != null) {
          _remainAmount = (payment.paymentDetailList.length != 0) ? saleInvoiceReturn.remainAmount - payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount) : saleInvoiceReturn.remainAmount;
        } else if (purchaseInvoice != null) {
          _remainAmount = (payment.paymentDetailList.length != 0) ? purchaseInvoice.remainAmount - payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount) : purchaseInvoice.remainAmount;
        } else if (purchaseInvoiceReturn != null) {
          _remainAmount = (payment.paymentDetailList.length != 0) ? purchaseInvoiceReturn.remainAmount - payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount) : purchaseInvoiceReturn.remainAmount;
        }
        //  else if (quote != null) {
        //   _remainAmount = (payment.paymentDetailList.length != 0) ? quote.remainAmount - payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount) : quote.remainAmount;
        // }
        print(_remainAmount);
        if (_remainAmount != 0) {
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return PaymentAddDialog(
                  remainAmountToPay: _remainAmount,
                  paymentDetail: (obj) {
                    payment.paymentDetailList.add(obj);
                    _totalAmount += obj.amount;
                  },
                );
              });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${global.appLocaleValues['tle_payment_detail_err_vld']}'),
          ));
        }
      } else {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return PaymentAddDialog(
                paymentDetail: (obj) {
                  payment.paymentDetailList.add(obj);
                  _totalAmount += obj.amount;
                },
              );
            });
      }
      setState(() {});
    } catch (e) {
      print('Exception - paymentAddScreen.dart - _addPaymentMethods(): ' + e.toString());
      return null;
    }
  }
}
